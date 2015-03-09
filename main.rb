#!/usr/bin/env ruby
require 'sinatra'
require 'json'
require 'cucumber'
require_relative 'step_finder.rb'

def client
  $client ||= StepFinder.new(File.read('location').chomp)
end

def search_for(query)
  client.search_steps(query)
end

get '/' do
  erb :layout
end

post '/search'  do
  query = request.params.fetch('query')
  @results = client.search_steps(query)
  erb :layout
end

post '/match'  do
  query = request.params.fetch('query')
  @results = [client.match_steps(query)].compact
  erb :layout
end
