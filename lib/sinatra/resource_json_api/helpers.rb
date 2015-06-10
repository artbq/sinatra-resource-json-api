require "sinatra/base"

module Sinatra
  module ResourceJsonApi
    module Helpers
      extend self

      def query_params_to_sql(params, options={})
        return "" if params.nil? || params.empty?

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

      def find_by(model, val, attrs)
        record = nil
        attrs.each do |attr|
          if record = model.find_by(attr => val)
            break
          end
        end
        if record
          yield(record)
        else
          status 404
          json message: "#{model.to_s} not found with #{attrs.join("|")}=#{val}"
        end
      end

      def array_hash_to_array(object)
        if object.is_a?(Hash)
          if object.keys.count.zero?
            object
          else
            if object.keys.all? { |k| k.to_s =~ /\A[0-9]+\Z/ }
              object.sort.map do |k, v|
                array_hash_to_array(v)
              end
            else
              object.keys.each do |k|
                object[k] = array_hash_to_array(object[k])
              end
              object
            end
          end
        else
          object
        end
      end
    end
  end

  helpers ResourceJsonApi::Helpers
end

