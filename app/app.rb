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

    def has_contact?
      !session[:contact_id].nil?
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

    def api_get(route = 'contacts')
      response = access_token.get("/api/v1/#{route}.json")
      JSON.parse response.body
    end

    def api_post(route = 'contacts', data = {})
      response = access_token.post("/api/v1/#{route}.json", {
        :body => data,
      })
      JSON.parse response.body
    end

    def api_put(route = 'contacts', data = {})
      response = access_token.put("/api/v1/#{route}.json", {
        :body => data,
      })
      JSON.parse response.body
    end

    def api_delete(route = 'contacts')
      response = access_token.delete("/api/v1/#{route}.json")
      JSON.parse response.body
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

    get '/api/create_contact' do
      number = rand(1000)
      @message = api_post('contacts', {
        'first_name' => 'Test',
        'last_name'  => "User#{number}",
        'email'      => "test.user#{number}@example.com",
        'company'    => '',
        'group_name' => '',
      })
      session[:contact_id] = @message['id']
      erb :index
    end

    get '/api/update_contact' do
      number = rand(1000)
      @message = api_put("contacts/#{session[:contact_id]}", {
        'first_name' => 'Test',
        'last_name'  => "User#{number}",
        'email'      => "test.user#{number}@example.com",
        'company'    => "Company #{number}",
        'group_name' => '',
      })
      erb :index
    end

    get '/api/delete_contact' do
      @message = api_delete("contacts/#{session[:contact_id]}")
      session[:contact_id] = nil
      erb :index
    end

    get '/api/:route/:id' do
      @message = api_get("/#{params[:route]}/#{params[:id]}")
      erb :index
    end

    get '/api/:route' do
       @message = api_get("/#{params[:route]}")
      erb :index
    end

  end
end