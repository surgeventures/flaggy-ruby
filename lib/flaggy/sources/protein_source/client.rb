if defined?(Protein)
module Flaggy
class ProteinSource
class Client < Protein::Client
  proto "Flaggy::ProteinSource::GetFeatures"
  proto "Flaggy::ProteinSource::LogResolution"
end
end
end
end
