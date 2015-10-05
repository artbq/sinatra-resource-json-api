module Sinatra
  module ResourceJsonApi
    module CrudActions

      def index(resource, opts={}, &block)
        opts = {path: "/", method: :get}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        send(method, path) do
          content_type content_type, charset: charset
          get_collection(resource, params) do |records|
            if block_given?
              instance_exec records, &block
            else
              if params[:page] || params[:per_page]
                total_entries = records.total_entries
                total_pages = records.total_pages
              else
                total_entries = records.count
                total_pages = 1
              end

              {
                entries: records,
                pagination: {total_entries: total_entries, total_pages: total_pages}
              }.to_json(opts[:to_json] || {})
            end
          end
        end
      end

      def show(resource, opts={}, &block)
        opts = {path: "/:id", method: :get}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        send(method, path) do
          content_type content_type, charset: charset
          get_record(resource, params[:id], params[:find_by] || ["id"]) do |record|
            if block_given?
              instance_exec record, &block
            else
              record.to_json(opts[:to_json] || {})
            end
          end
        end
      end

      def create(resource, opts={}, &block)
        opts = {path: "/", method: :post}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        body = Proc.new do
        end

        send(method, path) do
          content_type content_type, charset: charset

          record = resource.new(params[resource.to_s.underscore])

          if record.save
            if block_given?
              instance_exec record, &block
            else
              status 201
              record.to_json(opts[:to_json] || {})
            end
          else
            status 422
            if opts[:full_error_messages]
              {
                message: "#{resource.to_s} not created",
                errors: record.errors,
                full_error_messages: record.errors.full_messages
              }.to_json
            else
              {message: "#{resource.to_s} not created", errors: record.errors}.to_json
            end
          end
        end
      end

      def update(resource, opts={}, &block)
        opts = {path: "/:id", method: :put}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        send(method, path) do
          content_type content_type, charset: charset

          get_record(resource, params[:id], params[:find_by] || ["id"]) do |record|
            if record.update_attributes(params[resource.to_s.underscore])
              if block_given?
                instance_exec record, &block
              else
                status 200
                record.to_json(opts[:to_json] || {})
              end
            else
              status 422
              if opts[:full_error_messages]
                {
                  message: "#{resource.to_s} not created",
                  errors: record.errors,
                  full_error_messages: record.errors.full_messages
                }.to_json
              else
                {message: "#{resource.to_s} not created", errors: record.errors}.to_json
              end
            end
          end
        end
      end

      def destroy(resource, opts={})
        opts = {path: "/:id", method: :delete}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        send(method, path) do
          content_type content_type, charset: charset

          get_record(resource, params[:id], params[:find_by] || ["id"]) do |record|
            record.destroy
            status 204
          end
        end
      end

      def destroy_all(resource, opts={})
        opts = {path: "/", method: :delete}.merge(defaults).merge(opts)
        method, path, content_type, charset = opts.values_at(:method, :path, :content_type,
          :charset)

        send(method, path) do
          content_type content_type, charset: charset
          resource.destroy_all
          status 204
        end
      end

      private

      def defaults
        {
          content_type: "application/json",
          charset: "utf-8"
        }
      end
    end
  end

  register ResourceJsonApi::CrudActions
end

