require 'minitest/autorun'
require 'flaggy'

class FlaggyTest < Minitest::Test
  MY_FEATURE_DEFINITION = {
    "rules" => {
      "attribute" => "country_code",
      "is" => "PL"
    }
  }

  MALFORMED_FEATURE_DEFINITION = {
    "rulesx" => {
      "attr" => "country_code",
      "yes" => "PL"
    }
  }

  MALFORMED_RULE_DEFINITION = {
    "rules" => {
      "attr" => "country_code",
      "yes" => "PL"
    }
  }

  describe "active?" do
    before do
      Flaggy.configure do |config|
        config.source = {
          type: :memory
        }
      end

      Flaggy.put_feature(:my_feature, MY_FEATURE_DEFINITION)
      Flaggy.put_feature(:malformed_feature, MALFORMED_FEATURE_DEFINITION)
      Flaggy.put_feature(:malformed_rule, MALFORMED_RULE_DEFINITION)
    end

    it "returns false on missing feature" do
      refute Flaggy.active?(:missing_feature, {})
    end

    it "returns false on malformed feature" do
      refute Flaggy.active?(:malformed_feature, {})
    end

    it "returns false on malformed rule" do
      refute Flaggy.active?(:malformed_rule, {})
    end

    it "returns false on missing attribute" do
      refute Flaggy.active?(:my_feature, {})
    end

    it "returns true on enabled" do
      Flaggy.put_feature(:my_feature, {"enabled" => true})
      assert Flaggy.active?(:my_feature, {}) == true
    end

    it "returns true/false depending on 'is' rule" do
      Flaggy.put_feature(:my_feature, {"rules" => {"attribute" => "x", "is" => "y"}})
      assert Flaggy.active?(:my_feature, {"x" => "y"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "z"}) == false
    end

    it "returns true/false depending on 'in' rule" do
      Flaggy.put_feature(:my_feature, {"rules" => {"attribute" => "x", "in" => ["y", "z"]}})
      assert Flaggy.active?(:my_feature, {"x" => "y"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "z"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "x"}) == false
    end

    it "returns true/false depending on 'all' rule" do
      Flaggy.put_feature(:my_feature, {
        "rules" => {
          "all" => [
            {
              "attribute" => "x",
              "is" => "y"
            },
            {
              "attribute" => "a",
              "is" => "b"
            }
          ]
        }
      })

      assert Flaggy.active?(:my_feature, {"x" => "y", "a" => "b"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "y"}) == false
      assert Flaggy.active?(:my_feature, {"a" => "b"}) == false
      assert Flaggy.active?(:my_feature, {"x" => "z", "a" => "b"}) == false
    end

    it "returns true/false depending on 'any' rule" do
      Flaggy.put_feature(:my_feature, {
        "rules" => {
          "any" => [
            {
              "attribute" => "x",
              "is" => "y"
            },
            {
              "attribute" => "a",
              "is" => "b"
            }
          ]
        }
      })

      assert Flaggy.active?(:my_feature, {"x" => "y", "a" => "b"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "y"}) == true
      assert Flaggy.active?(:my_feature, {"a" => "b"}) == true
      assert Flaggy.active?(:my_feature, {"x" => "z", "a" => "c"}) == false
    end

    it "returns true/false depending on 'not' rule" do
      Flaggy.put_feature(:my_feature, {
        "rules" => {
          "not" => {
            "attribute" => "x",
            "is" => "y"
          }
        }
      })

      assert Flaggy.active?(:my_feature, {"x" => "y"}) == false
      assert Flaggy.active?(:my_feature, {"x" => "z"}) == true
      assert Flaggy.active?(:my_feature, {"a" => "b"}) == true
      assert Flaggy.active?(:my_feature, {}) == true
    end
  end

  describe "put_feature/2" do
    it "creates new feature" do
      Flaggy.put_feature(:absolutely_unique_feature, {"enabled" => true})
      assert Flaggy.active?(:absolutely_unique_feature, {}) == true
    end

    it "updates existing feature" do
      Flaggy.put_feature(:my_feature, {"enabled" => true})
      assert Flaggy.active?(:my_feature, {}) == true
      Flaggy.put_feature(:my_feature, {"enabled" => false})
      assert Flaggy.active?(:my_feature, {}) == false
    end
  end
end
