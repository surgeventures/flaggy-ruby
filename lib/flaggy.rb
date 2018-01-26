begin
  require "google/protobuf"
  require 'protein'
rescue LoadError
end

require "flaggy/flaggy"
require "flaggy/config"
require "flaggy/rule"
require "flaggy/source"

require "flaggy/sources/json_source"
require "flaggy/sources/memory_source"
if defined?(Protein)
  require "flaggy/sources/protein_source"
  require "flaggy/sources/protein_source/client"
  require "flaggy/sources/protein_source/loader"
  require "flaggy/sources/protein_source/observer"
  require "flaggy/sources/protein_source/proto/get_features_pb"
  require "flaggy/sources/protein_source/proto/log_resolution_pb"
end
