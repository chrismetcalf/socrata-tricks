APP_TOKEN = 'Ik3u4zlg7leEKNkLJDaSs7rsY'

require 'curb'
require 'hashie'

# Monkey patch the SODA::Client class to allow us to upload a file
module SODA
  class Client
    def upload_file(path, filename, params = {}, field = 'file', remote_filename = filename)
      c = Curl::Easy.new("https://#{@config[:domain]}#{path}?#{query_string(params)}")
      c.multipart_form_post = true
      c.http_auth_types = :basic
      c.username = @config[:username]
      c.password = @config[:password]
      c.headers['X-App-Token'] = @config[:app_token]
      c.http_post(Curl::PostField.file(field, filename, remote_filename))

      return Hashie::Mash.new(JSON.parse(c.body_str))
    end

    def form_post(path, params = {})
      c = Curl::Easy.new("https://#{@config[:domain]}#{path}")
      c.http_auth_types = :basic
      c.username = @config[:username]
      c.password = @config[:password]
      c.headers['X-App-Token'] = @config[:app_token]
      c.http_post(Curl::PostField.file(field, filename, remote_filename))
    end
  end
end

