require_relative "lib/rack_json_logger"
require "logger"
require "json"

logger = Logger.new(STDOUT)
STDOUT.sync = true
logger.level = :info
logger.formatter = proc do |_severity, _datetime, _progname, msg|
  "#{msg}\n"
end

app = lambda do |env|
  [
    200,
    { "Content-Type" => "application/json" },
    [JSON.generate(env.reject{|k, _| ["rack.input", "rack.errors"].include?(k) })]
  ]
end

use Rack::ContentLength
use RackJSONLogger, logger: logger, filtered_parameters: ["password"], additional_fields: { "rack.url_scheme" => "url_scheme" }
run app
