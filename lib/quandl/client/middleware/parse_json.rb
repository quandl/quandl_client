require 'json'

module Quandl
  module Client
    module Middleware
      class ParseJSON < Faraday::Response::Middleware

        def on_complete(env)
          env[:body] = case env[:status]
          when 204
            parse('{}', env)
          else
            parse(env[:body], env)
          end
        end

        def parse(body, env)
          json = parse_json(body, env)
          json.has_key?(:docs) ? format_collection( json, env ) : format_record( json, env )
        end

        def format_record(json, env)
          errors = json.delete(:errors) || {}
          metadata = json.delete(:metadata) || {}
          # collect some response data
          metadata.merge!({
            status:                 env[:status],
            headers:                env[:response_headers],
            method:                 env[:method],
            })
          # return object
          object = {
            :data => json,
            :errors => errors,
            :metadata => metadata
          }
          env[:status] = 200
          object
        end

        def format_collection(json, env)
          errors = json.delete(:errors) || {}
          metadata = json.delete(:metadata) || {}
          docs = json.delete(:docs)
          # collect some response data
          metadata.merge!(json).merge!({
            status:                 env[:status],
            headers:                env[:response_headers],
            method:                 env[:method],
            })
          # each doc metadata references metadata
          docs.each{|d| d[:metadata] = metadata }
          # return object
          object = {
            :data => docs,
            :errors => errors,
            :metadata => metadata
          }
          env[:status] = 200
          object
        end

        def parse_json(body = nil, env)
          body ||= '{}'
          json = begin
            JSON.parse(body).symbolize_keys!
          rescue JSON::ParserError
            nil
          end
          # invalid json body?
          if json.blank?
            # fallback to error message
            json = {
              id: 1,
              errors: {
                parse_errors:  [ "Quandl::Client::ParseJSON error. status: #{env[:status]}, body: #{body.inspect}" ]
              }
            }
          end
          json
        end

      end
    end
  end
end
