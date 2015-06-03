require "sinatra/base"

module Sinatra
  module ResourceJsonApi
    module Util
      extend self

      def array_hash_to_array(object)
        if object.is_a?(Hash)
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
        else
          object
        end
      end
    end
  end

  helpers ResourceJsonApi::Util
end

