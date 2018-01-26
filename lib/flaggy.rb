begin
  require 'protein'
rescue LoadError
end

require "flaggy/flaggy"
require "flaggy/config"
require "flaggy/rule"
require "flaggy/source"

require "flaggy/sources/json_source"
require "flaggy/sources/memory_source"
require "flaggy/sources/protein_source"
require "flaggy/sources/protein_source/client"
require "flaggy/sources/protein_source/loader"
require "flaggy/sources/protein_source/observer"
