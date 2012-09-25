module Nesta
  module App
    
    def print_code(opt={})
      filename = opt[:filename]
      theme = opt[:theme] || "eiffel"
      syntax = opt[:syntax]
  
      text = File.read(Dir.pwd + '/public/' + filename)
      processor = Textpow::RecordingProcessor.new
      result = Uv.parse( text, "xhtml", "shell", false, "eiffel")
  
      download_link = "<span id=\"download\"><a href=\"/files/#{filename}\">Download the #{filename}</a></span><br><br>"
      result = result + download_link
      return result
    end

  end
end