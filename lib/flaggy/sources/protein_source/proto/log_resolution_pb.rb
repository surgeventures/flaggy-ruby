module Flaggy
class ProteinSource
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: log_resolution.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "push_resolution.Request" do
    optional :app, :string, 1
    optional :feature, :string, 2
    optional :meta, :string, 3
    optional :resolution, :bool, 4
  end
end

module PushResolution
  Request = Google::Protobuf::DescriptorPool.generated_pool.lookup("push_resolution.Request").msgclass
end
end
end