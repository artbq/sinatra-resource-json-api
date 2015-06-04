require "sinatra"
require "sinatra/contrib"

require "sinatra/resource_json_api/query_params_to_sql"
require "sinatra/resource_json_api/util"

module Sinatra
  module ResourceJsonApi

    class ActionNotSupported < NoMethodError; end

    SUPPORTED_ACTIONS = %i(index)

    def self.registered(app)
      app.helpers QueryParamsToSql
      app.helpers Util
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

    private

    def index(model, options)
      get "/" do
        content_type "application/json;charset=utf-8"

        fixed_params = array_hash_to_array(params)

        records = if fixed_params[:query]
          model.where(query_params_to_sql(fixed_params[:query]))
        else
          model.all
        end

        if fixed_params[:order]
          order_sql = fixed_params[:order].map do |pair|
            "#{pair.keys.first} #{pair.values.first}"
          end.join(", ")
          records = records.order(order_sql)
        end

        json entries: records.map(&:as_json),
          pagination: {total_entries: records.count, total_pages: 1}
      end
    end
  end

  register ResourceJsonApi
end

