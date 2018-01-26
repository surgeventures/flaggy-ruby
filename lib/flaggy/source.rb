module Flaggy
module Source
class << self
  def get_features
    get_type_instance().get_features()
  end

  def log_resolution(feature, meta, resolution)
    get_type_instance().log_resolution(feature, meta, resolution)
  end

  def update_features(&block)
    get_type_instance().update_features(&block)
  end

  def get_type_instance
    @type_instance ||= get_type_class().new
  end

  def get_type_class
    case get_type()
    when :memory
      MemorySource
    when :protein
      ProteinSource
    when :json
      JSONSource
    else
      raise(ArgumentError)
    end
  end

  def get_type
    get_opts().fetch(:type, :memory)
  end

  def get_opts
    Flaggy.config.source || {}
  end
end
end
end
