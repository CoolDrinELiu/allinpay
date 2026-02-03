# frozen_string_literal: true

require 'json'

module AllinpayCnp
  class Response
    SUCCESS_CODE = '0000'

    attr_reader :http_response, :error, :public_key

    def initialize(http_response, error: nil, public_key: nil)
      @http_response = http_response
      @error = error
      @public_key = public_key
      @body = nil
    end

    def http_success?
      return false if @error

      @http_response&.success?
    end

    def success?
      http_success? && result_code == SUCCESS_CODE
    end

    def failure?
      !success?
    end

    def body
      @body ||= parse_body
    end

    def raw_body
      @http_response&.body
    end

    def result_code
      body['resultCode']
    end

    def result_desc
      body['resultDesc']
    end

    def access_order_id
      body['accessOrderId']
    end

    def order_id
      body['orderId']
    end

    def payment_url
      body['paymentUrl'] || body['counterUrl'] || body['url']
    end

    def status
      body['status']
    end

    def status_desc
      body['statusDesc']
    end

    def amount
      body['amount']
    end

    def currency
      body['currency']
    end

    def refund_amount
      body['refundAmount']
    end

    def trans_time
      time_str = body['transTime']
      return nil unless time_str

      Time.strptime(time_str, '%Y%m%d%H%M%S')
    rescue ArgumentError
      nil
    end

    def card_no
      body['cardNo']
    end

    def card_orgn
      body['cardOrgn']
    end

    def sign
      body['sign']
    end

    def valid_signature?
      return false unless @public_key && sign

      Signature.verify(body, @public_key)
    end

    def [](key)
      body[key.to_s]
    end

    def to_h
      {
        success: success?,
        result_code: result_code,
        result_desc: result_desc,
        access_order_id: access_order_id,
        order_id: order_id,
        payment_url: payment_url,
        status: status,
        amount: amount,
        currency: currency,
        raw: body
      }
    end

    private

    def parse_body
      return { 'resultCode' => 'NETWORK_ERROR', 'resultDesc' => @error.message } if @error
      return {} if @http_response.nil?

      JSON.parse(@http_response.body)
    rescue JSON::ParserError
      { 'resultCode' => 'PARSE_ERROR', 'resultDesc' => 'Invalid JSON', 'raw' => @http_response.body }
    end
  end
end
