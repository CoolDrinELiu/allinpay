# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinpayCnp::Client do
  let(:merchant_id) { '086310030670001' }

  let(:private_key) do
    <<~PEM
      -----BEGIN PRIVATE KEY-----
      MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDFt99S9adbC84l
      LExEF4vjFHiurFNRmBVEMmVVeJQfzQbQ/6fY0s+2Vx0lHVcD5ZVdDRwbTl2LG+8S
      lWH6aXmvOk5j5DI9wGJEwPo2L8GH9RHbHMQu0jr9+UO97kBCjKNZKmWkbNsPrfUb
      HxWuKKFILaZcv4LYNsjBNvVkvRU674lJVQ+TZ8ZsPLvc5+I3anJGLbu5Bt1igqbn
      vpMV1seYsUnNbuDBSoYHl09CPvGRc5krmRyouwwLlXiwcJDNDudl5Uohwj2LCuiC
      TWfkd/Me1ty1YrAZR9a/zh+vM7dLc9aCBnic2/7JYBtPwcKKC0Zix9ODbNehLahE
      Nqvxm9KtAgMBAAECggEAE3lb1rj5Zd9Qy5qEXISRM6mVhWbVwgift5rbHkMFG+i+
      ziEQMCv7Z3NHHJu6MVkQkBy1cv8R+ZyjvInYH6j54kd05yPXyvtC8pCrVGD5x+Fc
      g99ed1ofk1pU0MVBsQxXHnYtkrdiEDZLGQPDx+aalBhi9Wmrgo5K0bUPEIALMkWv
      RIBTkRbA/SB4WatB7zmKJxkqA+YIRzAmLDgUE1qjyhE/1VG/d/aetkwGkMo+HSDU
      x87ERKSbgLCri80UQ9RnMtV/wp9nh0VD3b6+MVFKacfKLHBrAwT3E/8Lv4S0I/Sr
      I94IoxOP4gCxytps+BslNuSCd3mMp8OuxCkqg2PBhQKBgQDmC+SpWH4WU/1XO/w9
      C0HnV7b0mpLt4+BqN/1eHdKK29L4R0iOqRjnO9bCkWGnV8nGU0kzNk9jueK2QBdR
      eOnmwqFCvEaIksyG/sUcHkzCxgtUvHxhy3e9IvjKv/5y47P9w/YgIZn62X+tWsnv
      EzPKPfw2+ALxllkVWZsBqB3hrwKBgQDcBkoL1JRWlrPaaSzcUbyJKUQWwIm9trHj
      XAYzwwsNjhGuV/aefVI7priLOxWR9Djq5IuOabNQ290ve6Bu2BBrEtbIsL/0UXwq
      HAmWXuCFc9/MfocQ+TiE0BuUDKgsYqQU2DE+JLaxvaUv1DNw2bUgm9z3zQyJJed4
      ZAHrYqo0YwKBgE9GGe4hiJG5L7w395wxnOxT1cBE5A0GUfdIhA9Cx6MCTZkxN1ex
      /drxS/iQkM5R+j5VxQvY01LSY8XaIC77M99Jgri0mLnHnKOId/RQnLMh/BWfPl2U
      +BY9Tu7Paqe8v/Ha7Z309lLzUIQ0nRG91EMFSTzICnumC9zHnBreDC4RAoGBAMWl
      JKjh6eqqb594MSMsjVcM6awigtkXn05kYPHoeCpR/5IEVHZkjxUkm8v+ZE76+pIO
      gUqJqtms11ELFb/ceUsl3ijjlVssQ4Q0MWyRh9B5mYVB96SIq3uq0cs5X2yXo1tS
      JVH0euTJPfTsAtWRy4IiYOl8mZEtqnNcKtk+hTSPAoGAKSF7NCZU0hQwu/rf8v7v
      go/qdS/oYDUohs5HVLG074Eerb1Q4w/xUfSz8zIJvTg04PLWwiBO3P5hCoXUXEaR
      V3Dl1g4i/pGrurOQQHhH9gdPINGBb7okthIwl02QT1UxX3Ibq1OjuH27qoCRQtWJ
      7oJx+aHeFOuOHjULBy+6/CU=
      -----END PRIVATE KEY-----
    PEM
  end

  let(:public_key) do
    <<~PEM
      -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxbffUvWnWwvOJSxMRBeL
      4xR4rqxTUZgVRDJlVXiUH80G0P+n2NLPtlcdJR1XA+WVXQ0cG05dixvvEpVh+ml5
      rzpOY+QyPcBiRMD6Ni/Bh/UR2xzELtI6/flDve5AQoyjWSplpGzbD631Gx8Vriih
      SC2mXL+C2DbIwTb1ZL0VOu+JSVUPk2fGbDy73OfiN2pyRi27uQbdYoKm576TFdbH
      mLFJzW7gwUqGB5dPQj7xkXOZK5kcqLsMC5V4sHCQzQ7nZeVKIcI9iwrogk1n5Hfz
      HtbctWKwGUfWv84frzO3S3PWggZ4nNv+yWAbT8HCigtGYsfTg2zXoS2oRDar8ZvS
      rQIDAQAB
      -----END PUBLIC KEY-----
    PEM
  end

  before do
    AllinpayCnp.configure do |config|
      config.merchant_id = merchant_id
      config.private_key = private_key
      config.public_key = public_key
      config.environment = :test
    end
  end

  let(:client) { described_class.new }

  describe '#unified_pay' do
    it 'sends request to unified_pay endpoint' do
      stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .to_return(
          status: 200,
          body: '{"resultCode":"0000","resultDesc":"Success","paymentUrl":"https://cnp-test.allinpay.com/checkout/xxx"}'
        )

      response = client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'HKD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' }
      )

      expect(response.success?).to be true
      expect(response.payment_url).to eq('https://cnp-test.allinpay.com/checkout/xxx')
    end

    it 'includes required parameters' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .with { |req|
          body = req.body
          body.include?('version=V2.0.0') &&
          body.include?("mchtId=#{merchant_id}") &&
          body.include?('accessOrderId=ORDER_123') &&
          body.include?('amount=100.00') &&
          body.include?('currency=HKD')
        }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'HKD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' }
      )

      expect(stub).to have_been_requested
    end

    it 'includes shipping address when provided' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .with { |req|
          body = req.body
          body.include?('shippingFirstName=Peter') &&
          body.include?('shippingLastName=Zhang') &&
          body.include?('shippingCountry=HK')
        }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'HKD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' },
        shipping: {
          first_name: 'Peter',
          last_name: 'Zhang',
          address1: '123 Test Street',
          city: 'Hong Kong',
          country: 'HK',
          zip_code: '000000',
          phone: '12345678'
        }
      )

      expect(stub).to have_been_requested
    end

    it 'includes billing address when provided' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .with { |req|
          body = req.body
          body.include?('billingFirstName=John') &&
          body.include?('billingLastName=Doe') &&
          body.include?('billingCountry=US')
        }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'USD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' },
        billing: {
          first_name: 'John',
          last_name: 'Doe',
          address1: '456 Main Street',
          city: 'New York',
          state: 'NY',
          country: 'US',
          zip_code: '10001',
          phone: '1234567890'
        }
      )

      expect(stub).to have_been_requested
    end

    it 'includes email when provided' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .with { |req| req.body.include?('email=test%40example.com') }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'HKD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' },
        email: 'test@example.com'
      )

      expect(stub).to have_been_requested
    end

    it 'uses default language zh-hant' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
        .with { |req| req.body.include?('language=zh-hant') }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.unified_pay(
        access_order_id: 'ORDER_123',
        amount: '100.00',
        currency: 'HKD',
        urls: { notify_url: 'https://example.com/callback', return_url: 'https://example.com/return' }
      )

      expect(stub).to have_been_requested
    end
  end

  describe '#query' do
    it 'sends query request with correct parameters' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .with { |req|
          body = req.body
          body.include?('transType=Query') &&
          body.include?('oriAccessOrderId=ORDER_ORIGINAL') &&
          body.include?("mchtId=#{merchant_id}") &&
          body.include?('version=V2.0.0')
        }
        .to_return(
          status: 200,
          body: '{"resultCode":"0000","status":"SUCCESS","amount":"100.00","currency":"HKD"}'
        )

      response = client.query('ORDER_ORIGINAL')

      expect(stub).to have_been_requested
      expect(response.success?).to be true
      expect(response.status).to eq('SUCCESS')
    end

    it 'returns order status information' do
      stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .to_return(
          status: 200,
          body: '{"resultCode":"0000","status":"SUCCESS","statusDesc":"交易成功","amount":"100.00","currency":"HKD","cardNo":"462419******0019","cardOrgn":"VISA"}'
        )

      response = client.query('ORDER_123')

      expect(response.status).to eq('SUCCESS')
      expect(response.status_desc).to eq('交易成功')
      expect(response.card_no).to eq('462419******0019')
      expect(response.card_orgn).to eq('VISA')
    end
  end

  describe '#refund' do
    it 'sends refund request with correct parameters' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .with { |req|
          body = req.body
          body.include?('transType=Refund') &&
          body.include?('oriAccessOrderId=ORDER_ORIGINAL') &&
          body.include?('refundAmount=50.00') &&
          body.include?("mchtId=#{merchant_id}") &&
          body.include?('version=V2.0.0')
        }
        .to_return(
          status: 200,
          body: '{"resultCode":"0000","resultDesc":"Success"}'
        )

      response = client.refund(
        ori_access_order_id: 'ORDER_ORIGINAL',
        refund_amount: '50.00'
      )

      expect(stub).to have_been_requested
      expect(response.success?).to be true
    end

    it 'uses provided accessOrderId' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .with { |req| req.body.include?('accessOrderId=REFUND_ORDER_123') }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.refund(
        ori_access_order_id: 'ORDER_123',
        refund_amount: '50.00',
        access_order_id: 'REFUND_ORDER_123'
      )

      expect(stub).to have_been_requested
    end

    it 'converts refund_amount to string' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .with { |req| req.body.include?('refundAmount=50.5') }
        .to_return(status: 200, body: '{"resultCode":"0000"}')

      client.refund(ori_access_order_id: 'ORDER_123', refund_amount: 50.5)

      expect(stub).to have_been_requested
    end
  end

  describe '#verify_callback' do
    it 'returns true for valid callback signature' do
      callback_params = {
        'resultCode' => '0000',
        'mchtId' => merchant_id,
        'accessOrderId' => 'ORDER_123',
        'amount' => '100.00'
      }
      signature = AllinpayCnp::Signature.sign(callback_params, private_key)
      callback_params['sign'] = signature

      result = client.verify_callback(callback_params)

      expect(result).to be true
    end

    it 'returns false for invalid callback signature' do
      callback_params = {
        'resultCode' => '0000',
        'mchtId' => merchant_id,
        'sign' => 'invalid_signature'
      }

      result = client.verify_callback(callback_params)

      expect(result).to be false
    end

    it 'returns false when public_key is not configured' do
      AllinpayCnp.config.public_key = nil

      callback_params = {
        'resultCode' => '0000',
        'sign' => 'any_signature'
      }

      result = client.verify_callback(callback_params)

      expect(result).to be false
    end
  end
end

RSpec.describe AllinpayCnp do
  describe '.configure' do
    it 'yields configuration object' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(AllinpayCnp::Config)
    end

    it 'persists configuration' do
      described_class.configure do |config|
        config.merchant_id = 'TEST_MERCHANT'
        config.environment = :production
      end

      expect(described_class.config.merchant_id).to eq('TEST_MERCHANT')
      expect(described_class.config.environment).to eq(:production)
    end
  end

  describe '.client' do
    it 'returns a Client instance' do
      client = described_class.client

      expect(client).to be_a(AllinpayCnp::Client)
    end
  end
end
