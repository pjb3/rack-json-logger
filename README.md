# Rack JSON Logger

This is a Rack middleware that will log a line of JSON for each request and response of your rack app. The intended purpose of this middleware is to log data about the request and the response in a JSON format, so that you can search for specific requests and responses in a logging service like Papertrail.

The fields that are logged are:

## Request

- **method** = The HTTP method
- **path** = The HTTP path
- **params** = The params with sensitive values removed
- **ip_address** = The request IP address
- **request_id** = The X-Request-Id request header
- **event** = The string "application_request"
- **timestamp**

## Response

- **method** = The HTTP method
- **path** = The HTTP path
- **length** = The Content-Length of the response
- **ms** = The time it took to generate the response in milliseconds
- **ip_address** = The request IP address
- **request_id** = The X-Request-Id request header
- **event** = The string "application_response
- **timestamp**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-json-logger'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rack-json-logger

## Usage

Add it to your Rackup file:

    use RackJSONLogger, logger: logger

The named parameters you can pass to the middleware are:

- **logger** = The Logger you want to write to
- **filtered_parameters** = The names of the sensitive param name that should be filtered out. See [ActiveSupport::ParameterFilter](https://edgeapi.rubyonrails.org/classes/ActiveSupport/ParameterFilter.html) for more information
- **additional_fields** = This is a hash where the keys are the keys of any entries in the Rack environment and the values are the key you want the value to be logged under

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pjb3/rack-json-logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
