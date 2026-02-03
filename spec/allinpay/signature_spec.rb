# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinpayCnp::Signature do
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
  let(:doc_private_key) do
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

  # 文档中的待签名字符串
  let(:doc_sign_string) do
    'accessOrderId=1604919554438&accessTime=20201109185914&acctCvv=212&acctNo=4012001037141112&amount=160&billingAddress1=广东省广州市测试&billingCity=shagnhai&billingCountry=CN&billingFirstName=杰伦&billingLastName=周&billingPhone=1231230080&billingState=shanghai&billingZipCode=440000&cardHolder=Peter&currency=CNY&dmInf={"3DSFlag":"YES","OrderChannel":"WEBSITE","MerchantType":"RETAILS","BuyerName":"Peter","AccountAge":"5"}&email=961836760@qq.com&expiryMonth=12&expiryYear=2027&ipAddress=120.0.0.1&language=zh-hant&mchtId=086310058120024&panIsPaste=0&productInfo=[{"sku":"123121","productName":"test测试", "price":"113.9989", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123122","productName":"test测试1", "price":"114.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123123","productName":"test测试2", "price":"115.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123124","productName":"test测试3", "price":"116.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"}]&shippingAddress1=广东省广州市测试 测试 测试测试 测试 测试*&shippingAddress2=广东省广州市测试Another&shippingCity=shagnhai&shippingCountry=CN&shippingFirstName=Peter三&shippingLastName=zh张&shippingPhone=1231230080&shippingState=shagnhai&shippingZipCode=440000&signType=RSA2&transType=QuickPay&userAgent=360Brower&version=V2.0.0'
  end

  # 文档中的签名结果
  let(:doc_signature) do
    'AudUXILqRROOkve6gNFVAv4g/XCEvUpA9knjQzkY8c0mgSa1TWaO03MZWKMjQ2tm+cENd6bGMbOj4Z0GLNCygAR+Pko7m4Do21PUnF1r4Karcn1u0ePFB7KiWSaVpWIRRRUIxSpSpHgRIG86IR3VFwl9oa0ssESN6fnfPDWUBm9zYzCvLhAPQ20ZSIbKlJWsR9M3zAsaTUhCX7JzxxrL+rgqG/II4nD5F3CjotSmiVbgQCSvEXrpShKcafw05ff7+5g0IhtlOAyRXAkY1ZgLM/3HPIlT/aQXHkg312nVfs3qDXp1MKlp5WWh4+NwbSrGKwrSv11n7ND+LaBleMb77w=='
  end

  # 文档中的原始参数 (用于测试 build_sign_string)
  let(:doc_params) do
    {
      accessOrderId: '1604919554438',
      accessTime: '20201109185914',
      acctCvv: '212',
      acctNo: '4012001037141112',
      amount: '160',
      billingAddress1: '广东省广州市测试',
      billingCity: 'shagnhai',
      billingCountry: 'CN',
      billingFirstName: '杰伦',
      billingLastName: '周',
      billingPhone: '1231230080',
      billingState: 'shanghai',
      billingZipCode: '440000',
      cardHolder: 'Peter',
      currency: 'CNY',
      dmInf: '{"3DSFlag":"YES","OrderChannel":"WEBSITE","MerchantType":"RETAILS","BuyerName":"Peter","AccountAge":"5"}',
      email: '961836760@qq.com',
      expiryMonth: '12',
      expiryYear: '2027',
      ipAddress: '120.0.0.1',
      language: 'zh-hant',
      mchtId: '086310058120024',
      panIsPaste: '0',
      productInfo: '[{"sku":"123121","productName":"test测试", "price":"113.9989", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123122","productName":"test测试1", "price":"114.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123123","productName":"test测试2", "price":"115.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"},{"sku":"123124","productName":"test测试3", "price":"116.99", "quantity":"800", "productImage":"imageUrl","productUrl":"goodsUrl"}]',
      shippingAddress1: '广东省广州市测试 测试 测试测试 测试 测试*',
      shippingAddress2: '广东省广州市测试Another',
      shippingCity: 'shagnhai',
      shippingCountry: 'CN',
      shippingFirstName: 'Peter三',
      shippingLastName: 'zh张',
      shippingPhone: '1231230080',
      shippingState: 'shagnhai',
      shippingZipCode: '440000',
      signType: 'RSA2',
      transType: 'QuickPay',
      userAgent: '360Brower',
      version: 'V2.0.0'
    }
  end
  # 文档提供的真实测试数据
  describe 'with official test data' do
    describe '.build_sign_string' do
      it 'builds exact sign string matching official documentation' do
        result = described_class.build_sign_string(doc_params)

        expect(result).to eq(doc_sign_string)
      end
    end

    describe '.sign' do
      it 'generates exact signature matching official documentation' do
        signature = described_class.sign(doc_params, doc_private_key)

        expect(signature).to eq(doc_signature)
      end
    end
  end

  # 基本功能测试
  describe '.build_sign_string' do
    it 'sorts keys alphabetically (TreeMap order)' do
      params = {
        version: 'V2.0.0',
        mchtId: '086310030670001',
        transType: 'Query',
        accessOrderId: '1234567890'
      }

      result = described_class.build_sign_string(params)

      expect(result).to eq('accessOrderId=1234567890&mchtId=086310030670001&transType=Query&version=V2.0.0')
    end

    it 'excludes sign field' do
      params = {
        mchtId: '086310030670001',
        sign: 'should_be_excluded',
        version: 'V2.0.0'
      }

      result = described_class.build_sign_string(params)

      expect(result).not_to include('sign')
      expect(result).to eq('mchtId=086310030670001&version=V2.0.0')
    end

    it 'excludes nil values' do
      params = {
        mchtId: '086310030670001',
        email: nil,
        version: 'V2.0.0'
      }

      result = described_class.build_sign_string(params)

      expect(result).not_to include('email')
    end

    it 'excludes empty string values' do
      params = {
        mchtId: '086310030670001',
        email: '',
        version: 'V2.0.0'
      }

      result = described_class.build_sign_string(params)

      expect(result).not_to include('email')
    end

    it 'trims whitespace from values' do
      params = {
        mchtId: '  086310030670001  ',
        version: ' V2.0.0 '
      }

      result = described_class.build_sign_string(params)

      expect(result).to eq('mchtId=086310030670001&version=V2.0.0')
    end

    it 'handles both string and symbol keys' do
      params = {
        'mchtId' => '086310030670001',
        version: 'V2.0.0'
      }

      result = described_class.build_sign_string(params)

      expect(result).to eq('mchtId=086310030670001&version=V2.0.0')
    end
  end

  describe '.sign' do
    it 'generates a non-empty signature' do
      params = { version: 'V2.0.0', mchtId: '086310030670001' }

      signature = described_class.sign(params, doc_private_key)

      expect(signature).to be_a(String)
      expect(signature.length).to be > 100
    end

    it 'generates consistent signatures for same input' do
      params = { version: 'V2.0.0', mchtId: '086310030670001' }

      sig1 = described_class.sign(params, doc_private_key)
      sig2 = described_class.sign(params, doc_private_key)

      expect(sig1).to eq(sig2)
    end

    it 'generates different signatures for different input' do
      params1 = { mchtId: '086310030670001', amount: '100' }
      params2 = { mchtId: '086310030670001', amount: '200' }

      sig1 = described_class.sign(params1, doc_private_key)
      sig2 = described_class.sign(params2, doc_private_key)

      expect(sig1).not_to eq(sig2)
    end

    it 'generates Base64 encoded signature' do
      params = { mchtId: '086310030670001' }

      signature = described_class.sign(params, doc_private_key)

      expect(signature).to match(/\A[A-Za-z0-9+\/]+=*\z/)
    end
  end

  describe '.verify' do
    it 'returns true for valid signature' do
      params = { version: 'V2.0.0', mchtId: '086310030670001' }
      signature = described_class.sign(params, doc_private_key)
      params_with_sign = params.merge(sign: signature)

      result = described_class.verify(params_with_sign, public_key)

      expect(result).to be true
    end

    it 'returns false for tampered data' do
      params = { version: 'V2.0.0', mchtId: '086310030670001', amount: '100' }
      signature = described_class.sign(params, doc_private_key)
      tampered_params = params.merge(amount: '200', sign: signature)

      result = described_class.verify(tampered_params, public_key)

      expect(result).to be false
    end

    it 'returns false for invalid signature' do
      params = { mchtId: '086310030670001', sign: 'invalid_signature' }

      result = described_class.verify(params, public_key)

      expect(result).to be false
    end

    it 'returns false when sign is missing' do
      params = { mchtId: '086310030670001' }

      result = described_class.verify(params, public_key)

      expect(result).to be false
    end
  end
end
