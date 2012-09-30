ENV['GEM_PATH'] = '/usr/local/rvm/gems/ruby-1.9.2-p320:/usr/local/rvm/gems/ruby-1.9.2-p320@global'
ENV['LD_LIBRARY_PATH'] = '/usr/local/rvm/rubies/ruby-1.9.2-p320/lib'

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'nesta/env'
Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))


require 'nesta/app'

# use Rack::Codehighlighter, :coderay, :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/, :logging => true, :debug => true, :markdown => true
# use Rack::Codehighlighter, :coderay, :element => "pre>code", :markdown => true
use Rack::Codehighlighter, :ultraviolet, :element => "pre>code", :markdown => true, :theme => "eiffel"
# use Rack::Codehighlighter, :ultraviolet, :theme => "dawn", :lines => false, :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false

# use Rack::Pygments, :html_tag => "pre", :html_attr => "lang"

run Nesta::App
