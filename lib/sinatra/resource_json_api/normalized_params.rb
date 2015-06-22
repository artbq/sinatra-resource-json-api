class NormalizedParams

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    request.params.each do |key, value|
      request.update_param(key, array_hash_to_array(value))
    end

    @app.call(env)
  end

  private

  def array_hash_to_array(object)
    if object.is_a?(Hash) && !object.empty?
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

