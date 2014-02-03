# Getting Started Ruby
## Using the Client Heartbeat API with Ruby 2


### Initial Setup

Run `bundle install` to install the necessary gems.


You'll also need to setup the following variables:

    ENV['OAUTH2_CLIENT_ID']           ||= 'YOUR CLIENT ID'
    ENV['OAUTH2_CLIENT_SECRET']       ||= 'YOUR CLIENT SECRET'
    ENV['SITE']                       ||= 'https://clientheartbeat.com'
    ENV['OAUTH2_CLIENT_REDIRECT_URI'] ||= 'http://localhost:9292/callback'

* `OAUTH2_CLIENT_ID` - your Client Heartbeat app id
* `OAUTH2_CLIENT_SECRET` - your Client Heartbeat app secret
* `SITE` - the site the OAuth client is connecting to (i.e. https://clientheartbeat.com)
* `OAUTH2_CLIENT_REDIRECT_URI` - where Client Heartbeat will return to once the user has authenticated

### Running the Application

After setting things up, use the `rackup` command.