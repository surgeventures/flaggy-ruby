module Flaggy
class ProteinSource
class ManagerObserver
  def update(time, result, error)
    return if result

    if error.is_a?(Concurrent::TimeoutError)
      Flaggy.logger.error("Failed to load features due to task timeout")
    else
      Flaggy.logger.error("Failed to load features due to error (#{error})")
    end
  end
end
end
end
