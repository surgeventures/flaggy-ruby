module Flaggy
class << self
  def active?(feature_symbol, meta)
    raise(ArgumentError) unless feature_symbol.is_a?(Symbol)

    feature_string = feature_symbol.to_s
    features = Source.get_features()
    feature_def = features[feature_string]
    return false unless feature_def
    return false unless feature_def.key?("enabled") || feature_def.key?("rules")

    enabled = feature_def["enabled"]
    rules = feature_def["rules"]
    resolution = enabled.nil? ? Rule.satisfied?(rules, meta) : enabled
    Source.log_resolution(feature_symbol, meta, resolution)

    resolution
  end

  def put_feature(feature_symbol, feature_definition)
    feature_string = feature_symbol.to_s
    Source.update_features do |features|
      features[feature_string] = feature_definition
    end
  end

  def configure(&block)
    new_config = Config.new
    block.call(new_config)

    @config = new_config

    Source.reset

    @config
  end

  def config
    @config ||= Config.new
  end

  def logger
    @logger ||= begin
      Logger.new($stdout).tap do |log|
        log.progname = 'flaggy'
      end
    end
  end
end
end
