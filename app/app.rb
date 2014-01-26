module SinatraApp
  class App < Sinatra::Base

    enable :sessions

    before do
      ENV['OAUTH2_CLIENT_ID']           ||= 'YOUR CLIENT ID'
      ENV['OAUTH2_CLIENT_SECRET']       ||= 'YOUR CLIENT SECRET'
      ENV['SITE']                       ||= 'https://clientheartbeat.com'
      ENV['OAUTH2_CLIENT_REDIRECT_URI'] ||= 'http://localhost:9292/callback'
    end

    def logged_in?
      !session[:access_token].nil?
    end

    def oauth_client(token_method = :post)
      OAuth2::Client.new(
        ENV['OAUTH2_CLIENT_ID'],
        ENV['OAUTH2_CLIENT_SECRET'],
        :site         => ENV['SITE'],
        :token_method => token_method,
      )
    end

    def access_token
      @access_token ||= OAuth2::AccessToken.new(oauth_client, session[:access_token], :refresh_token => session[:refresh_token])
    end

    def redirect_uri
      ENV['OAUTH2_CLIENT_REDIRECT_URI']
    end

    get '/' do
      erb :index
    end

    get '/log_in/?' do
      redirect oauth_client.auth_code.authorize_url(:redirect_uri => redirect_uri)
    end

    get '/log_out/?' do
      session[:access_token] = nil
      redirect '/'
    end
    
    get '/callback/?' do
      new_token = oauth_client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      session[:access_token]  = new_token.token
      session[:refresh_token] = new_token.refresh_token
      redirect '/'
    end

  end
end