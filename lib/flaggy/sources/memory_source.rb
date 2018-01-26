module Flaggy
class MemorySource
  def initialize
    @features = Source.get_opts().fetch(:initial_features, {})
  end

  def get_features
    @features
  end

  def update_features(&block)
    new_features = Marshal.load(Marshal.dump(@features))
    block.call(new_features)

    @features = new_features
  end

  def log_resolution(feature, meta, resolution)
  end
end
end
