# frozen_string_literal: true

require 'faraday'
require 'uri'

module AllinpayCnp
  class Request
    ENDPOINTS = {
      test: {
        quickpay: 'https://cnp-test.allinpay.com/gateway/cnp/quickpay',
        unified_pay: 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay'
      },
      production: {
        quickpay: 'https://cnp.allinpay.com/gateway/cnp/quickpay',
        unified_pay: 'https://cnp.allinpay.com/gateway/cnp/unifiedPay'
      }
    }.freeze

    def post(endpoint_type, params)
      sign_params(params)
      url = build_url(endpoint_type)
      log_request(url, params)
      response = send_post(url, params)
      log_response(response)
      Response.new(response, public_key: config.public_key)
    rescue Faraday::Error => e
      log_error(e.message)
      Response.new(nil, error: e)
    end

    private

    def config
      AllinpayCnp.config
    end

    def sign_params(params)
      params[:signType] = 'RSA2'
      params[:sign] = Signature.sign(params, config.private_key)
    end

    def build_url(endpoint_type)
      ENDPOINTS[config.environment][endpoint_type]
    end

    def send_post(url, params)
      connection.post(url) do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
        req.body = encode_params(params)
      end
    end

    def encode_params(params)
      params
        .reject { |_, v| v.nil? || v.to_s.empty? }
        .map { |k, v| "#{k}=#{URI.encode_www_form_component(v.to_s)}" }
        .join('&')
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.options.timeout = config.timeout
        conn.options.open_timeout = config.timeout
        conn.adapter Faraday.default_adapter
      end
    end

    def log_request(url, params)
      return unless config.logger

      config.logger.info("[AllinpayCnp] POST #{url}")
      config.logger.debug("[AllinpayCnp] Params: #{params.reject { |k, _| k == :sign }}")
    end

    def log_response(response)
      return unless config.logger

      config.logger.info("[AllinpayCnp] Response: #{response.status}")
      config.logger.debug("[AllinpayCnp] Body: #{response.body}")
    end

    def log_error(message)
      return unless config.logger

      config.logger.error("[AllinpayCnp] Error: #{message}")
    end
  end
end
