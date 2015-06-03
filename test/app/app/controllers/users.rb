require "sinatra/resource_json_api"

App::App.controllers :users do

  register Sinatra::ResourceJsonApi

  def_crud_actions User
end

