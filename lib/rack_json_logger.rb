require "active_support/parameter_filter"
require "json"

class RackJSONLogger
  APPLICATION_REQUEST = "application_request".freeze
  APPLICATION_RESPONSE = "application_response".freeze
  REQUEST_METHOD = "REQUEST_METHOD".freeze
  PATH_INFO = "PATH_INFO".freeze
  TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S.%L".freeze
  HTTP_X_REQUEST_ID = "HTTP_X_REQUEST_ID".freeze
  CONTENT_LENGTH = "Content-Length".freeze

  def initialize(app, logger: nil, filtered_parameters: nil, additional_fields: nil)
    @app = app
    @logger = logger
    if filtered_parameters
      @param_filter = ActiveSupport::ParameterFilter.new(filtered_parameters)
    end
    @additional_fields = additional_fields
  end

  def call(env)
    request = Rack::Request.new(env)
    log_request(request)
    began_at = Rack::Utils.clock_time
    status, headers, body = @app.call(env)
    headers = Rack::Utils::HeaderHash[headers]
    body = Rack::BodyProxy.new(body) { log_response(request, status, headers, began_at) }
    [status, headers, body]
  end

  private

  def log(env, msg)
    msg = JSON.generate(msg)
    logger = @logger || env[RACK_ERRORS]
    if logger.respond_to?(:info)
      logger.info(msg)
    elsif logger.respond_to?(:write)
      logger.write(msg)
    else
      logger << msg
    end
  end

  def log_request(request)
    data = {
      method: request.request_method,
      path: request.path,
      params: @param_filter ? @param_filter.filter(request.params) : request.params
    }

    @additional_fields&.each do |rack_env_key, log_key|
      data[log_key] = request.env[rack_env_key]
    end

    data.merge!(
      ip_address: request.ip,
      request_id: request.env[HTTP_X_REQUEST_ID],
      event: APPLICATION_REQUEST,
      timestamp: Time.now.utc.strftime(TIMESTAMP_FORMAT)
    )

    log(request.env, data)
  end

  def log_response(request, _status, headers, began_at)
    length = extract_content_length(headers)

    data = {
      method: request.request_method,
      path: request.path,
      length: length,
      ms: (Rack::Utils.clock_time - began_at).round
    }

    @additional_fields&.each do |rack_env_key, log_key|
      data[log_key] = request.env[rack_env_key]
    end

    data.merge(
      ip_address: request.ip,
      request_id: request.env[HTTP_X_REQUEST_ID],
      event: APPLICATION_RESPONSE,
      timestamp: Time.now.utc.strftime(TIMESTAMP_FORMAT)
    )

    log(request.env, data)
  end

  # Attempt to determine the content length for the response to
  # include it in the logged data.
  def extract_content_length(headers)
    value = headers[CONTENT_LENGTH]
    !value || value.to_s == "0" ? "-" : value
  end
end
