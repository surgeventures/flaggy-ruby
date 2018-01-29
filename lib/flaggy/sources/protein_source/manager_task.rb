require "json"

module Flaggy
class ProteinSource
class ManagerTask
class << self
  def call
    features = get_features()
    log_resolutions()
    features
  end

  private

  def get_app
    ProteinSource.get_app()
  end

  def get_features
    request = GetFeatures::Request.new(app: get_app())
    response = Client.call!(request)

    JSON.parse(response.features)
  end

  def log_resolutions
    resolutions = ProteinSource.flush_resolutions()
    resolutions.each do |feature, meta, resolution|
      Client.push(LogResolution::Request.new(
        app: get_app(),
        feature: feature.to_s,
        meta: JSON.dump(meta),
        resolution: resolution
      ))
    end
  end
end
end
end
end
