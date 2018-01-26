# Flaggy for Ruby

**Multi-source Ruby client for managing feature flags.**

## Installation

The package can be installed by adding `flaggy` to your list of gems in `Gemfile`:

```ruby
gem :flaggy, "~> x.y.z"
```

If you want to use the `protein` source, you'll also have to add its gem:

```ruby
gem :flaggy, "~> x.y.z"
gem :protein, "~> x.y.z"
```

## Definition sources

Following definition sources are available:

### `memory`

Starts empty and can be filled using `Flaggy.put_definition()`. It's most useful for testing.
This is the default source in case no configuration was provided.

#### Configuration

```ruby
Flaggy.configure do |config|
  config.source = {
    type: :memory
  }
end
```

### `json`

Loads definition from JSON file. It's most useful for development.

#### Configuration

```ruby
Flaggy.configure do |config|
  config.source = {
    type: :json,
    eager_load: false,
    file: "path/to/definition.json"
  }
end
```

### `protein`

Loads, caches and periodically updates definition from RPC server via `Protein`.

#### Configuration

```ruby
Flaggy.configure do |config|
  config.source = {
    type: :protein,
    app: :my_app,
    transport: {
      adapter: :amqp,
      url: "amqp://rabbitmqhost",
      queue: "my_queue"
    }
  }
end
```

## Rules

### `is`

Checks equality of specific meta attribute with given value.

#### Example

JSON snippet:

```json
{
  "attribute": "country_code",
  "is": "PL"
}
```

Code snippet:

```ruby
irb> Flaggy.put_feature(:my_feature, {"rules" => {"attribute" => "x", "is" => "y"}})
irb> Flaggy.active?(:my_feature, {"x" => "y"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "z"})
 => false
```

### `in`

Checks inclusion of specific meta attribute in a set of given values.

#### Example

JSON snippet:

```json
{
  "attribute": "country_code",
  "in": ["PL", "AE", "US"]
}
```

Code snippet:

```ruby
irb> Flaggy.put_feature(:my_feature, {"rules" => {"attribute" => "x", "in" => ["y", "z"]}})
irb> Flaggy.active?(:my_feature, {"x" => "y"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "z"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "x"})
 => false
```

### `all`

Checks if all sub-rules are met.

#### Example

JSON snippet:

```json
{
  "all": [
    {
      "attribute": "country_code",
      "in": ["PL", "AE", "US"]
    },
    {
      "attribute": "user_id",
      "in": [1, 2, 3, 4, 5]
    }
  ]
}
```

Code snippet:

```ruby
irb> Flaggy.put_feature(:my_feature, {"rules" => {"all" => [
        {
          "attribute" => "x",
          "is" => "y"
        },
        {
          "attribute" => "a",
          "is" => "b"
        }
      ]}})
irb> Flaggy.active?(:my_feature, {"x" => "y", "a" => "b"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "y"})
 => false
irb> Flaggy.active?(:my_feature, {"a" => "b"})
 => false
irb> Flaggy.active?(:my_feature, {"x" => "z", "a" => "b"})
 => false
```

### `any`

Checks if any of sub-rules is met.

#### Example

JSON snippet:

```json
{
  "any": [
    {
      "attribute": "country_code",
      "in": ["PL", "AE", "US"]
    },
    {
      "attribute": "user_id",
      "in": [1, 2, 3, 4, 5]
    }
  ]
}
```

Code snippet:

```ruby
irb> Flaggy.put_feature(:my_feature, {"rules" => {"any" => [
        {
          "attribute" => "x",
          "is" => "y"
        },
        {
          "attribute" => "a",
          "is" => "b"
        }
      ]}})
irb> Flaggy.active?(:my_feature, {"x" => "y", "a" => "b"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "y"})
 => true
irb> Flaggy.active?(:my_feature, {"a" => "b"})
 => true
irb> Flaggy.active?(:my_feature, {"x" => "z", "a" => "c"})
 => false
```

### `not`

Checks if sub-rule is not met.

#### Example

JSON snippet:

```json
{
  "not": {
    "attribute": "country_code",
    "in": ["PL", "AE", "US"]
  }
}
```

Code snippet:

```ruby
irb> Flaggy.put_feature(:my_feature, {"rules" => {"not" => {
        "attribute" => "x",
        "is" => "y"
      }}})
irb> Flaggy.active?(:my_feature, {"x" => "y"})
 => false
irb> Flaggy.active?(:my_feature, {"x" => "z"})
 => true
irb> Flaggy.active?(:my_feature, {"a" => "b"})
 => true
irb> Flaggy.active?(:my_feature, {})
 => true
```

## Fault tolerance

The `Flaggy.active?()` function is guaranteed to return `false` instead of raising in following
circumstances:

- feature doesn't exist or was removed
- rule uses non-sent attribute
- source is unavailable (but raises if JSON file doesn't exist)
- feature/rule definition is malformed
