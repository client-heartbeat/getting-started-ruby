#!/usr/bin/env rackup
require File.expand_path("../config/boot", __FILE__)

map '/' do
  run SinatraApp::App
end