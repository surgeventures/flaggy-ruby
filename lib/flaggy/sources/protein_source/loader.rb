module Flaggy
class ProteinSource
class Loader
class << self
  def call
    sleep 5

    {
      "my_feature" => {
        "enabled" => true
      }
    }
  end
end
end
end
end
