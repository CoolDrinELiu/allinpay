# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinpayCnp::Response do
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

  let(:success_body) do
    {
      'resultCode' => '0000',
      'resultDesc' => 'Success',
      'accessOrderId' => 'ORDER_123',
      'orderId' => 'SYS_ORDER_456',
      'payUrl' => 'https://cnp-test.allinpay.com/checkout/xxx',
      'status' => 'SUCCESS',
      'statusDesc' => '交易成功',
      'amount' => '100.00',
      'currency' => 'HKD',
      'refundAmount' => '0',
      'transTime' => '20241109185914',
      'cardNo' => '462419******0019',
      'cardOrgn' => 'VISA'
    }.to_json
  end

  let(:http_response) do
    instance_double(Faraday::Response, success?: true, status: 200, body: success_body)
  end

  describe '#http_success?' do
    it 'returns true for successful HTTP response' do
      response = described_class.new(http_response)
      expect(response.http_success?).to be true
    end

    it 'returns false when error is present' do
      response = described_class.new(nil, error: Faraday::TimeoutError.new('timeout'))
      expect(response.http_success?).to be false
    end

    it 'returns false when http_response is nil' do
      response = described_class.new(nil)
      expect(response.http_success?).to be false
    end

    it 'returns false for failed HTTP response' do
      failed = instance_double(Faraday::Response, success?: false, status: 500, body: 'error')
      response = described_class.new(failed)
      expect(response.http_success?).to be false
    end
  end

  describe '#success?' do
    it 'returns true when HTTP success and resultCode is 0000' do
      response = described_class.new(http_response)
      expect(response.success?).to be true
    end

    it 'returns false when HTTP success but resultCode is not 0000' do
      error_body = { 'resultCode' => '9999', 'resultDesc' => 'Failed' }.to_json
      resp = instance_double(Faraday::Response, success?: true, body: error_body)
      response = described_class.new(resp)
      expect(response.success?).to be false
    end

    it 'returns false when HTTP fails' do
      failed = instance_double(Faraday::Response, success?: false, status: 500, body: '{"resultCode":"0000"}')
      response = described_class.new(failed)
      expect(response.success?).to be false
    end

    it 'returns false on network error' do
      response = described_class.new(nil, error: Faraday::ConnectionFailed.new('connection failed'))
      expect(response.success?).to be false
    end
  end

  describe '#failure?' do
    it 'returns false when success' do
      response = described_class.new(http_response)
      expect(response.failure?).to be false
    end

    it 'returns true when not success' do
      response = described_class.new(nil, error: Faraday::TimeoutError.new('timeout'))
      expect(response.failure?).to be true
    end
  end

  describe 'response accessors' do
    let(:response) { described_class.new(http_response) }

    it 'returns result_code' do
      expect(response.result_code).to eq('0000')
    end

    it 'returns result_desc' do
      expect(response.result_desc).to eq('Success')
    end

    it 'returns access_order_id' do
      expect(response.access_order_id).to eq('ORDER_123')
    end

    it 'returns order_id' do
      expect(response.order_id).to eq('SYS_ORDER_456')
    end

    it 'returns payment_url' do
      expect(response.payment_url).to eq('https://cnp-test.allinpay.com/checkout/xxx')
    end

    it 'returns status' do
      expect(response.status).to eq('SUCCESS')
    end

    it 'returns status_desc' do
      expect(response.status_desc).to eq('交易成功')
    end

    it 'returns amount' do
      expect(response.amount).to eq('100.00')
    end

    it 'returns currency' do
      expect(response.currency).to eq('HKD')
    end

    it 'returns refund_amount' do
      expect(response.refund_amount).to eq('0')
    end

    it 'returns card_no' do
      expect(response.card_no).to eq('462419******0019')
    end

    it 'returns card_orgn' do
      expect(response.card_orgn).to eq('VISA')
    end

    it 'returns sign' do
      expect(response.sign).to be_nil
    end
  end

  describe '#trans_time' do
    it 'parses valid transTime string' do
      response = described_class.new(http_response)
      expect(response.trans_time).to be_a(Time)
      expect(response.trans_time.year).to eq(2024)
      expect(response.trans_time.month).to eq(11)
      expect(response.trans_time.day).to eq(9)
    end

    it 'returns nil when transTime is nil' do
      resp = instance_double(Faraday::Response, success?: true, body: '{"resultCode":"0000"}')
      response = described_class.new(resp)
      expect(response.trans_time).to be_nil
    end

    it 'returns nil for invalid time format' do
      resp = instance_double(Faraday::Response, success?: true, body: '{"transTime":"invalid"}')
      response = described_class.new(resp)
      expect(response.trans_time).to be_nil
    end
  end

  describe '#valid_signature?' do
    it 'returns true when signature is valid' do
      body_hash = { 'resultCode' => '0000', 'mchtId' => '086310030670001' }
      signature = AllinpayCnp::Signature.sign(body_hash, private_key)
      body_hash['sign'] = signature

      resp = instance_double(Faraday::Response, success?: true, body: body_hash.to_json)
      response = described_class.new(resp, public_key: public_key)

      expect(response.valid_signature?).to be true
    end

    it 'returns false when signature is invalid' do
      body_hash = { 'resultCode' => '0000', 'sign' => 'invalid_sig' }
      resp = instance_double(Faraday::Response, success?: true, body: body_hash.to_json)
      response = described_class.new(resp, public_key: public_key)

      expect(response.valid_signature?).to be false
    end

    it 'returns false when public_key is nil' do
      body_hash = { 'resultCode' => '0000', 'sign' => 'some_sig' }
      resp = instance_double(Faraday::Response, success?: true, body: body_hash.to_json)
      response = described_class.new(resp, public_key: nil)

      expect(response.valid_signature?).to be false
    end

    it 'returns false when sign is missing from body' do
      resp = instance_double(Faraday::Response, success?: true, body: '{"resultCode":"0000"}')
      response = described_class.new(resp, public_key: public_key)

      expect(response.valid_signature?).to be false
    end
  end

  describe '#[]' do
    it 'accesses body fields by string key' do
      response = described_class.new(http_response)
      expect(response['resultCode']).to eq('0000')
    end

    it 'accesses body fields by symbol key' do
      response = described_class.new(http_response)
      expect(response[:resultCode]).to eq('0000')
    end
  end

  describe '#to_h' do
    it 'returns hash with expected keys' do
      response = described_class.new(http_response)
      hash = response.to_h

      expect(hash[:success]).to be true
      expect(hash[:result_code]).to eq('0000')
      expect(hash[:result_desc]).to eq('Success')
      expect(hash[:access_order_id]).to eq('ORDER_123')
      expect(hash[:order_id]).to eq('SYS_ORDER_456')
      expect(hash[:payment_url]).to eq('https://cnp-test.allinpay.com/checkout/xxx')
      expect(hash[:status]).to eq('SUCCESS')
      expect(hash[:amount]).to eq('100.00')
      expect(hash[:currency]).to eq('HKD')
      expect(hash[:raw]).to be_a(Hash)
    end
  end

  describe '#raw_body' do
    it 'returns raw HTTP response body' do
      response = described_class.new(http_response)
      expect(response.raw_body).to eq(success_body)
    end

    it 'returns nil when http_response is nil' do
      response = described_class.new(nil)
      expect(response.raw_body).to be_nil
    end
  end

  describe 'error handling' do
    it 'returns NETWORK_ERROR body on Faraday error' do
      error = Faraday::TimeoutError.new('execution expired')
      response = described_class.new(nil, error: error)

      expect(response.result_code).to eq('NETWORK_ERROR')
      expect(response.result_desc).to eq('execution expired')
    end

    it 'returns PARSE_ERROR body on invalid JSON' do
      resp = instance_double(Faraday::Response, success?: true, body: 'not json at all')
      response = described_class.new(resp)

      expect(response.result_code).to eq('PARSE_ERROR')
      expect(response.result_desc).to eq('Invalid JSON')
    end

    it 'returns empty hash when http_response is nil and no error' do
      response = described_class.new(nil)
      expect(response.body).to eq({})
    end
  end
end
