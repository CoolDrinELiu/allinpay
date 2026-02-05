# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinpayCnp::Request do
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

  describe '#post' do
    context 'with test environment' do
      it 'sends request to test quickpay URL' do
        stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
               .to_return(status: 200, body: '{"resultCode":"0000"}')

        described_class.new.post(:quickpay, { mchtId: merchant_id })

        expect(stub).to have_been_requested
      end

      it 'sends request to test unified_pay URL' do
        stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/unifiedPay')
               .to_return(status: 200, body: '{"resultCode":"0000"}')

        described_class.new.post(:unified_pay, { mchtId: merchant_id })

        expect(stub).to have_been_requested
      end
    end

    context 'with production environment' do
      before do
        AllinpayCnp.configure.environment = :production
      end

      it 'sends request to production quickpay URL' do
        stub = stub_request(:post, 'https://cnp.allinpay.com/gateway/cnp/quickpay')
               .to_return(status: 200, body: '{"resultCode":"0000"}')

        described_class.new.post(:quickpay, { mchtId: merchant_id })

        expect(stub).to have_been_requested
      end

      it 'sends request to production unified_pay URL' do
        stub = stub_request(:post, 'https://cnp.allinpay.com/gateway/cnp/unifiedPay')
               .to_return(status: 200, body: '{"resultCode":"0000"}')

        described_class.new.post(:unified_pay, { mchtId: merchant_id })

        expect(stub).to have_been_requested
      end
    end

    it 'sends correct Content-Type header' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
             .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' })
             .to_return(status: 200, body: '{"resultCode":"0000"}')

      described_class.new.post(:quickpay, { mchtId: merchant_id })

      expect(stub).to have_been_requested
    end

    it 'adds signType and sign to params' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
             .with { |req| req.body.include?('signType=RSA2') && req.body.include?('sign=') }
             .to_return(status: 200, body: '{"resultCode":"0000"}')

      described_class.new.post(:quickpay, { mchtId: merchant_id })

      expect(stub).to have_been_requested
    end

    it 'URL encodes parameter values' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
             .with { |req| req.body.include?('email=test%40example.com') }
             .to_return(status: 200, body: '{"resultCode":"0000"}')

      described_class.new.post(:quickpay, { mchtId: merchant_id, email: 'test@example.com' })

      expect(stub).to have_been_requested
    end

    it 'excludes nil and empty values from request body' do
      stub = stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
             .with { |req| !req.body.include?('emptyField') && !req.body.include?('nilField') }
             .to_return(status: 200, body: '{"resultCode":"0000"}')

      described_class.new.post(:quickpay, { mchtId: merchant_id, emptyField: '', nilField: nil })

      expect(stub).to have_been_requested
    end

    it 'returns Response object on success' do
      stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .to_return(status: 200, body: '{"resultCode":"0000","amount":"100"}')

      response = described_class.new.post(:quickpay, { mchtId: merchant_id })

      expect(response).to be_a(AllinpayCnp::Response)
      expect(response.success?).to be true
      expect(response.amount).to eq('100')
    end

    it 'returns Response object on HTTP error' do
      stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .to_return(status: 500, body: 'Internal Server Error')

      response = described_class.new.post(:quickpay, { mchtId: merchant_id })

      expect(response).to be_a(AllinpayCnp::Response)
      expect(response.success?).to be false
    end

    it 'returns Response object on network error' do
      stub_request(:post, 'https://cnp-test.allinpay.com/gateway/cnp/quickpay')
        .to_timeout

      response = described_class.new.post(:quickpay, { mchtId: merchant_id })

      expect(response).to be_a(AllinpayCnp::Response)
      expect(response.success?).to be false
      expect(response.send(:error)).to be_a(Faraday::Error)
    end
  end
end
