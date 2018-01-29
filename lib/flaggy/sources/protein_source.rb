require 'concurrent'
require 'json'

module Flaggy
class ProteinSource
  class << self
    def get_opts
      Source.get_opts()
    end

    def get_app
      get_opts().fetch(:app)
    end

    def get_refresh_interval
      get_opts().fetch(:refresh_interval, 30_000) * 0.001
    end

    def push_resolution(feature, meta, resolution)
      @resolutions ||= []
      @resolutions.push([feature, meta, resolution])
    end

    def flush_resolutions
      old_resolutions = @resolutions || []
      @resolutions = []
      old_resolutions
    end
  end

  def initialize
    @features = {}
    @resolutions = []

    transport_opts = Source.get_opts().fetch(:transport)
    adapter = transport_opts.fetch(:adapter)
    Client.transport(adapter, transport_opts)

    manager_task = Concurrent::TimerTask.new(get_manager_opts()) { @features = ManagerTask.call() }
    manager_task.add_observer(ManagerObserver.new)
    manager_task.execute
  end

  def get_features
    @features
  end

  def update_features(&block)
    raise("This source cannot be updated")
  end

  def log_resolution(feature, meta, resolution)
    self.class.push_resolution(feature, meta, resolution)
  end

  private

  def get_manager_opts
    {
      execution_interval: self.class.get_refresh_interval(),
      run_now: true,
    }
  end
end
end
