require 'json'

module Flaggy
class JSONSource
  def initialize
    @features = Flaggy.config.source.fetch(:eager_load, false) ? load_features() : nil
  end

  def get_features
    @features ||= load_features()
  end

  def update_features(&block)
    raise("This source cannot be updated")
  end

  def log_resolution(feature, meta, resolution)
  end

  private

  def load_features
    filename = Flaggy.config.source.fetch(:file)
    json = File.read(filename)

    JSON.parse(json)
  end
end
end
