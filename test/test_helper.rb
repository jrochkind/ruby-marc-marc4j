gem 'minitest' # I feel like this messes with bundler, but only way to get minitest to shut up
require 'minitest/autorun'
require 'minitest/spec'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems."
  exit e.status_code
end


def ext_file_path(relative_path)
  return File.expand_path(File.join("../ext", relative_path), File.dirname(__FILE__))
end

def support_file_path(relative_path)
  return File.expand_path(File.join("test_support", relative_path), File.dirname(__FILE__))
end

