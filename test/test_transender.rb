#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib transender]))

puts "Testing with local transform repository...\n"
Transender::Ji.transform_and_zip({:app_title=>"myClonedProject", :transform=>File.join(File.dirname(__FILE__), %w[iproject]), :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) }) do |zip|
  puts "Transender::Ji.transform_and_zip finished with #{zip}."
end

puts "Testing with remote transform repository...\n"
Transender::Ji.transform_and_zip({:app_title=>"myRemotelyClonedProject", :transform=>"git://github.com/mihael/iproject.git", :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) }) do |zip|
  puts "Transender::Ji.transform_and_zip remote finished with #{zip}."
end