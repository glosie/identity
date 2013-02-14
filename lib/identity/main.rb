module Identity
  Main = Rack::Builder.new do
    use Rack::Instruments
    use Rack::SSL if Config.production?

    # general cookie storing information of the logged in user; should be
    # scoped to the app's specific domain
    use Rack::Session::Cookie,
      coder: FernetCookieCoder.new(Config.cookie_encryption_key),
      domain: Config.cookie_domain,
      http_only: true,
      path: '/',
      expire_after: 2592000

    # cookie with a domain scoped to all heroku domains, used to set a session
    # nonce value so that consumers can recognize when the logged in user has
    # changed
    if Config.heroku_cookie_domain
      use Rack::Session::Cookie,
        domain: Config.heroku_cookie_domain,
        expire_after: 2592000,
        http_only: true,
        key: 'rack.session.heroku',
        secret: Config.secure_key
    end

    use Rack::Csrf, skip: ["POST:/oauth/.*"]
    use Rack::Flash

    run Sinatra::Router.new {
      mount Identity::Account
      mount Identity::Assets
      mount Identity::Auth
      run   Identity::Default # index + error handlers
    }
  end
end
