require 'bundler/setup'

require 'sinatra'
require 'nokogiri'
require 'httpclient'
require 'json'
require 'open-uri'

get "/" do
  slideshows = JSON.parse(open("http://www.funnyordie.com/json/media/slideshows").read)

  html = <<-HTML
  <body style="text-align:center">
  <h1>I don't wanna wait</h1>
  <img src="http://public0.ordienetworks.com/assets/vandermemes/vandermeme-25-8695f522b4c5a44b871a73567cf1e70a.gif" />
  <h1>For these slides to be over</h1>
  <div style="border-top: 1px solid black; padding-top: 20px; margin-top: 20px">
  HTML

  slideshows.each do |slideshow|
    html += <<-HTML
      <div style="text-align: center; margin-bottom: 20px">
        <a href="#{slideshow["web_url"]}">
          <img src="#{slideshow["thumb_url"]}" style="width: 150px; display: block; margin: 0 auto"/>
          #{slideshow["title"]}
        </a>
      </div>
    HTML
  end
  html += <<-HTML
  </div>
  HTML
end
