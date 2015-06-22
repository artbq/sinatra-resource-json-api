require "sinatra"
require "sinatra/contrib"

require "sinatra/resource_json_api/normalized_params"
require "sinatra/resource_json_api/crud_actions"
require "sinatra/resource_json_api/getter_methods"

module Sinatra
  module ResourceJsonApi

    class ActionNotSupported < NoMethodError; end

    SUPPORTED_ACTIONS = %i(index show create update destroy destroy_all)

    def self.registered(app)
      app.use NormalizedParams
      app.register CrudActions
      app.helpers GetterMethods
    end

    def def_crud_actions(model, options={})
      actions = options[:only] || SUPPORTED_ACTIONS
      actions.each do |action|
        if SUPPORTED_ACTIONS.include?(action)
          send(action, model, options)
        else
          raise ActionNotSupported, "action not supported: #{action}"
        end
      end
    end
  end

  register ResourceJsonApi
end

