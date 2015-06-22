require "sinatra/resource_json_api/sql"

module Sinatra
  module ResourceJsonApi
    module GetterMethods

      include Sinatra::ResourceJsonApi::Sql

      def get_collection(relation, params)
        query, order, page, per_page = params.values_at(:query, :order, :page, :per_page)

        result = query ? relation.where(where_sql(query)) : relation.all
        result = relation.order(order_sql(order)) if order
        result = relation.paginate(page: page || 1, per_page: per_page || 10) if page || per_page

        yield result
      end

      def get_record(relation, id, find_by)
        record = nil
        find_by.each do |field|
          if record = relation.find_by(field => id)
            break
          end
        end

        if record
          yield record
        else
          status 404
          json message: "#{relation.to_s} not found with #{find_by.join("|")}=#{id}"
        end
      end
    end
  end

  helpers ResourceJsonApi::GetterMethods
end

