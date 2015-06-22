module Sinatra
  module ResourceJsonApi
    module Sql

      def where_sql(query)
        return "" if query.nil? || query.empty?

        if query.count > 1
          "(#{query.map { |pair| where_sql(Hash[*pair]) }.join(" AND ")})"
        else
          key = query.keys.first.to_s
          value = query.values.first

          case key
          when "or"
            "(#{value.map { |query| where_sql(query) }.join(" OR ")})"
          when "<>"
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} <> '#{value}')"
          when "<"
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} < '#{value}')"
          when "<="
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} <= '#{value}')"
          when ">"
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} > '#{value}')"
          when ">="
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} >= '#{value}')"
          when "LIKE"
            field, value = value.to_a.first.map(&:to_s)
            "(#{field} LIKE '#{value}')"
          when "iLIKE"
            field, value = value.to_a.first.map(&:to_s)
            "(LOWER(#{field}) LIKE LOWER('#{value}'))"
          when "in"
            field = value.to_a.first.first.to_s
            values = value.to_a.first.last.map(&:to_s).map { |v| "'#{v}'" }.join(", ")
            "(#{field} IN (#{values}))"
          when "is_null"
            "(#{value.to_s} IS NULL)"
          when "is_not_null"
            "(#{value.to_s} IS NOT NULL)"
          else
            "(#{key} = '#{value}')"
          end
        end
      end

      def order_sql(order)
        order.map do |pair|
          field = pair.keys.first
          dir = pair.values.first
          "#{field} #{dir}"
        end.join(", ")
      end
    end
  end

  helpers ResourceJsonApi::Sql
end

