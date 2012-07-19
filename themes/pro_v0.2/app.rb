# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

# pagination
require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

# table of contents support
require 'maruku'
require 'nokogiri'

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
      def can_generate_toc?
        [:Maruku, :Nokogiri].all? { |cls| Object.const_defined?(cls) }
      end

      # Provide page TOC    
      def toc(page, toc_template = :table_of_contents)
        return nil unless can_generate_toc?
        headings = Nokogiri::HTML(page.body(self)).css('h2')
        toc_headers = headings.inject({}) do |mappings, header_node|
          mappings[header_node.attr('id')] = header_node.content
          mappings
        end
        haml(toc_template, :layout => false, :locals => { :toc_headers => toc_headers })
      end
    end

    # Add new routes here.
  end
end
