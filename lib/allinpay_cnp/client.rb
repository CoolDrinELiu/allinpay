# frozen_string_literal: true

module AllinpayCnp
  class Client
    VERSION = 'V2.0.0'

    def unified_pay(access_order_id:, amount:, currency:, notify_url:, return_url:, **options)
      params = build_unified_pay_params(
        access_order_id: access_order_id,
        amount: amount,
        currency: currency,
        notify_url: notify_url,
        return_url: return_url,
        **options
      )
      request.post(:unified_pay, params)
    end

    def query(ori_access_order_id, access_order_id: nil)
      params = {
        version: VERSION,
        mchtId: config.merchant_id,
        transType: 'Query',
        accessOrderId: access_order_id || generate_order_id,
        oriAccessOrderId: ori_access_order_id
      }
      request.post(:quickpay, params)
    end

    def refund(ori_access_order_id:, refund_amount:, access_order_id: nil)
      params = {
        version: VERSION,
        mchtId: config.merchant_id,
        transType: 'Refund',
        accessOrderId: access_order_id || generate_order_id,
        oriAccessOrderId: ori_access_order_id,
        refundAmount: refund_amount.to_s
      }
      request.post(:quickpay, params)
    end

    def verify_callback(params)
      return false unless config.public_key

      Signature.verify(params, config.public_key)
    end

    private

    def config
      AllinpayCnp.config
    end

    def request
      @request ||= Request.new
    end

    def generate_order_id
      "#{Time.now.to_i}#{rand(1000..9999)}"
    end

    def build_unified_pay_params(access_order_id:, amount:, currency:, notify_url:, return_url:, **options)
      build_base_params(access_order_id, amount, currency, notify_url, return_url, options)
        .merge(build_shipping_params(options))
        .merge(build_billing_params(options))
        .compact
    end

    def build_base_params(access_order_id, amount, currency, notify_url, return_url, options)
      {
        version: VERSION,
        mchtId: config.merchant_id,
        accessOrderId: access_order_id,
        amount: amount.to_s,
        currency: currency,
        notifyUrl: notify_url,
        returnUrl: return_url,
        language: options[:language] || 'zh-hant',
        email: options[:email],
        productInfo: options[:product_info]&.to_json
      }
    end

    def build_shipping_params(options)
      {
        shippingFirstName: options.dig(:shipping, :first_name),
        shippingLastName: options.dig(:shipping, :last_name),
        shippingAddress1: options.dig(:shipping, :address1),
        shippingAddress2: options.dig(:shipping, :address2),
        shippingCity: options.dig(:shipping, :city),
        shippingState: options.dig(:shipping, :state),
        shippingCountry: options.dig(:shipping, :country),
        shippingZipCode: options.dig(:shipping, :zip_code),
        shippingPhone: options.dig(:shipping, :phone)
      }
    end

    def build_billing_params(options)
      {
        billingFirstName: options.dig(:billing, :first_name),
        billingLastName: options.dig(:billing, :last_name),
        billingAddress1: options.dig(:billing, :address1),
        billingAddress2: options.dig(:billing, :address2),
        billingCity: options.dig(:billing, :city),
        billingState: options.dig(:billing, :state),
        billingCountry: options.dig(:billing, :country),
        billingZipCode: options.dig(:billing, :zip_code),
        billingPhone: options.dig(:billing, :phone)
      }
    end
  end
end
