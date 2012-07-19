# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.
require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

# code coloring
require "rack/pygments"

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/pro_v0.1/public/pro_v0.1.
    #
    use Rack::Static, :urls => ["/pro_v0.1"], :root => "themes/pro_v0.1/public"

    helpers WillPaginate::Sinatra::Helpers
    
    helpers do
      # Add new helpers here.
      
    end

    # Add new routes here.
  end
end
