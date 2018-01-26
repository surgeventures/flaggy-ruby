require 'concurrent'

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

  class Observer
    def update(time, result, ex)
      if result
        print "(#{time}) Execution successfully returned #{result}\n"
      elsif ex.is_a?(Concurrent::TimeoutError)
        print "(#{time}) Execution timed out\n"
      else
        print "(#{time}) Execution failed with error #{ex}\n"
      end
    end
  end

  def initialize
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
    # todo
  end

  private

  def get_loader_opts
    {
      execution_interval: 60,
      run_now: true,
    }
  end
end
end
