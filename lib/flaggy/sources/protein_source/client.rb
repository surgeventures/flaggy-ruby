# In order to re-generate changed protos, do the following:
#
# - run 'bundle exec irb -I lib'
# - require 'protein'
# - require 'shellwords'
# - call Protein::ProtoCompiler.call(proto_directory: "./lib/flaggy/sources/protein_source/proto")
# - wrap new files in module Flaggy; class ProteinSource; ...; end; end

module Flaggy
class ProteinSource
class Client < ::Protein::Client
  proto "Flaggy::ProteinSource::GetFeatures"
  proto "Flaggy::ProteinSource::LogResolution"
end
end
end
