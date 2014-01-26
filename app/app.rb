module SinatraApp
  class App < Sinatra::Base

    enable :sessions

    before do
      ENV['OAUTH2_CLIENT_ID']           ||= 'YOUR CLIENT ID'
      ENV['OAUTH2_CLIENT_SECRET']       ||= 'YOUR CLIENT SECRET'
      ENV['SITE']                       ||= 'https://clientheartbeat.com'
      ENV['OAUTH2_CLIENT_REDIRECT_URI'] ||= 'http://localhost:9292/callback'
    end

    get '/' do
      erb :index
    end

  end
end