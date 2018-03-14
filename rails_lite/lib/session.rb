require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    p req
  end

  def [](key)
    req_hash = @req.env['rack.request.cookie_hash']['_rails_lite_app']
    JSON.parse(req_hash)[key]
  end

  def []=(key, val)
    # Rack::Response.set_cookie('_rails_lite_app',key, val)

  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app_',@req[])

    # @req.env['rack.request.cookie_hash']['_rails_lite_app']
    # if @req.env['rack.request.cookie_hash']['_rails_lite_app']
    # else
    # end
  end
end
