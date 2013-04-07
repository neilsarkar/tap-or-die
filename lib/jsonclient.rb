require "httpclient"
require "yajl"

class JsonClient < HTTPClient
  def post(uri, *args, &block)
    if args[0].is_a?(Hash) && !args[0][:body].nil?
      args[0][:body] = Yajl::Encoder.encode(args[0][:body])
    end

    super(uri, *args, &block)
  end

  def request(*args)
    response = super(*args)
    if response.status >= 200 && response.status <= 300
      Yajl::Parser.parse(response.body)["response"] rescue response
    else
      response
    end
  end
end
