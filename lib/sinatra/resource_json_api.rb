require "sinatra"
require "sinatra/contrib"

module Sinatra
  module ResourceJsonApi

    class ActionNotSupported < NoMethodError; end

    SUPPORTED_ACTIONS = %i(index)

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

    private

    def index(model, options)
      get "/" do
        content_type "application/json;charset=utf-8"

        records = model.all

        json entries: records.map(&:as_json),
          pagination: {total_entries: records.count, total_pages: 1}
      end
    end
  end

  register ResourceJsonApi
end

