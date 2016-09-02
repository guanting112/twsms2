require 'net/http'
require 'cgi'

module Twsms2
  module Network
    def get(host, request_uri, params = {})
      uri = URI('https://' + host + request_uri)
      uri.query = query_string(params.merge(username: @username, password: @password))

      message = Net::HTTP::Get.new(uri.request_uri)
      message['User-Agent'] = @user_agent

      parse(request(uri, message), host)
    end

    def parse(http_response, host)
      case http_response
      when Net::HTTPSuccess
        http_response.body
      when Net::HTTPClientError
        raise ClientError, "#{http_response.code} response from #{host}"
      when Net::HTTPServerError
        raise ServerError, "#{http_response.code} response from #{host}"
      else
        raise Error, "#{http_response.code} response from #{host}"
      end
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true
      http.request(message)
    end

    def query_string(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    def escape(component)
      CGI.escape(component.to_s)
    end
  end
end