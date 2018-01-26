require 'concurrent'
require 'json'

module Flaggy
class ProteinSource
  def initialize
    transport_opts = Source.get_opts().fetch(:transport)
    adapter = transport_opts.fetch(:adapter)
    Client.transport(adapter, transport_opts)

    @features = {}
    @loader_task = Concurrent::TimerTask.new(get_loader_opts()) { @features = Loader.call() }
    @loader_task.add_observer(Observer.new)
    @loader_task.execute
  end

  def get_features
    @features
  end

  def update_features(&block)
    raise("This source cannot be updated")
  end

  def log_resolution(feature, meta, resolution)
    Client.push(LogResolution::Request.new(
      app: get_app(),
      feature: feature.to_s,
      meta: JSON.dump(meta),
      resolution: resolution
    ))
  end

  def get_app
    Source.get_opts().fetch(:app)
  end

  private

  def get_loader_opts
    {
      execution_interval: get_refresh_interval(),
      run_now: true,
    }
  end

  def get_refresh_interval
    Source.get_opts().fetch(:refresh_interval, 60_000) * 0.001
  end
end
end
