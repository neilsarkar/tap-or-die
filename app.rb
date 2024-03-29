require 'bundler/setup'

require 'sinatra'
require 'nokogiri'
require 'httpclient'
require 'yajl'
require 'uri'
require 'open-uri'

require './lib/ripper'
require './lib/uploader'

get "/" do
  slideshows = Yajl::Parser.parse(open("http://www.funnyordie.com/json/media/slideshows").read)

  html = <<-HTML
  <body style="text-align:center">
  <h1>&#9835;I don't wanna wait&#9835;</h1>
  <img src="http://public0.ordienetworks.com/assets/vandermemes/vandermeme-25-8695f522b4c5a44b871a73567cf1e70a.gif" />
  <h1>&#9835;For these slides to be over&#9835;</h1>
  <div style="border-top: 1px solid black; padding-top: 20px; margin-top: 20px">
  HTML

  slideshows.each do |slideshow|
    html += <<-HTML
      <div style="text-align: center; margin-bottom: 20px">
        <a href="/create?title=#{URI.escape(slideshow["title"])}&amp;uri=#{URI.escape(slideshow["web_url"])}">
          <img src="#{slideshow["thumb_url"].gsub(/fullsize/,"rectangle_large")}" style="width: 150px; display: block; margin: 0 auto"/>
          #{slideshow["title"]}
        </a>
      </div>
    HTML
  end
  html += <<-HTML
  </div>
  HTML
end

get "/create" do
  # sinatra inexplicably stripping the first slash in http://
  title = URI.unescape(params[:title])
  uri = URI.unescape(params[:uri]).gsub(/^http.*www/, "http://www")
  ripper = Ripper.new(uri)

  uploader = Uploader.new({
    title: title,
    html:  ripper.html,
    css:   ripper.css
  })
  uploader.upload
  "<a href='#{uploader.url}'>#{uploader.url}</a>"
end
