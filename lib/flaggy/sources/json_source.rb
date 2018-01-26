require 'json'

module Flaggy
class JSONSource
  def initialize
    filename = Flaggy.config.source.fetch(:file)
    json = File.read(filename)

    @features = JSON.parse(json)
  end

  def get_features
    @features
  end

  def update_features(&block)
    raise("This source cannot be updated")
  end

  def log_resolution(feature, meta, resolution)
  end
end
end
