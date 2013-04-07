class Uploader
  attr_accessor :url

  def initialize(options)
    @html = options[:html]
    @css  = options[:css]
    @title = options[:title]
  end

  def upload
    response = HTTPClient.new.post("http://tapestri.es/api/story/", body: {
      title: @title,
      description: "",
      html: @html,
      css: @css,
      client_key: "fdc3f8ef08ae2b07cbf677ac87947e",
      client_secret: "73afa39ac1b9613e4da700e128d205"
    })

    @url = "http://tapestri.es/f/#{Yajl::Parser.parse(response.body)["id"]}"
  end
end
