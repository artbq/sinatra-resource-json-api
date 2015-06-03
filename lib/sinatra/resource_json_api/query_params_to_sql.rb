require "sinatra/base"

module Sinatra
  module ResourceJsonApi
    module QueryParamsToSql
      extend self

      def query_params_to_sql(params, options={})
        if params.count > 1
          "(#{params.map { |pair| query_params_to_sql(Hash[*pair]) }.join(" AND ")})"
        else
          key = params.keys.first.to_s
          val = params.values.first

          case key
          when "or"
            "(#{val.map { |q| query_params_to_sql(q) }.join(" OR ")})"
          when "<"
            attr, val = val.to_a.first.map(&:to_s)
            "(#{attr} < '#{val}')"
          when "<="
            attr, val = val.to_a.first.map(&:to_s)
            "(#{attr} <= '#{val}')"
          when ">"
            attr, val = val.to_a.first.map(&:to_s)
            "(#{attr} > '#{val}')"
          when ">="
            attr, val = val.to_a.first.map(&:to_s)
            "(#{attr} >= '#{val}')"
          when "is_null"
            "(#{val.to_s} IS NULL)"
          when "is_not_null"
            "(#{val.to_s} IS NOT NULL)"
          when "in"
            attr = val.to_a.first.first.to_s
            vals = val.to_a.first.last.map(&:to_s).map { |v| "'#{v}'" }.join(", ")
            "(#{attr} IN (#{vals}))"
          when "<>"
            attr, val = val.to_a.first.map(&:to_s)
            "(#{attr} <> '#{val}')"
          else
            "(#{key} = '#{val}')"
          end
        end
      end
    end
  end

  helpers ResourceJsonApi::QueryParamsToSql
end

