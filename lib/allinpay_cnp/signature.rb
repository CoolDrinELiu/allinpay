# frozen_string_literal: true

require 'openssl'
require 'base64'

module AllinpayCnp
  # 签名模块
  # 按照 Java Demo 的 sign() 方法实现
  module Signature
    class << self
      # 生成签名
      # @param params [Hash] 待签名参数
      # @param private_key [String] 私钥 (PEM 格式)
      # @return [String] Base64 编码的签名
      def sign(params, private_key)
        sign_string = build_sign_string(params)
        rsa_sign(sign_string, private_key)
      end

      # 验证签名
      # @param params [Hash] 包含 sign 的参数
      # @param public_key [String] 公钥
      # @return [Boolean]
      def verify(params, public_key)
        params = params.transform_keys(&:to_s)
        signature = params.delete('sign')
        return false if signature.nil? || signature.empty?

        sign_string = build_sign_string(params)
        rsa_verify(sign_string, signature, public_key)
      rescue StandardError
        false
      end

      # 构建待签名字符串
      # Java Demo: TreeMap 按字典序，key=value&key=value
      def build_sign_string(params)
        params
          .transform_keys(&:to_s)
          .reject { |k, v| k == 'sign' || v.nil? || v.to_s.strip.empty? }
          .sort_by { |k, _| k }
          .map { |k, v| "#{k}=#{v.to_s.strip}" }
          .join('&')
      end

      private

      # RSA SHA256 签名
      def rsa_sign(content, private_key_pem)
        pkey = load_private_key(private_key_pem)
        signature = pkey.sign(OpenSSL::Digest.new('SHA256'), content)
        Base64.strict_encode64(signature)
      end

      # RSA SHA256 验签
      def rsa_verify(content, signature, public_key_pem)
        pkey = load_public_key(public_key_pem)
        pkey.verify(
          OpenSSL::Digest.new('SHA256'),
          Base64.decode64(signature),
          content
        )
      end

      # 加载私钥
      def load_private_key(key_content)
        if key_content.include?('-----BEGIN')
          OpenSSL::PKey::RSA.new(key_content)
        else
          pem = '-----BEGIN PRIVATE KEY-----\n#{key_content}\n-----END PRIVATE KEY-----'
          OpenSSL::PKey::RSA.new(pem)
        end
      end

      # 加载公钥
      def load_public_key(key_content)
        if key_content.include?('-----BEGIN')
          OpenSSL::PKey::RSA.new(key_content)
        else
          pem = "-----BEGIN PUBLIC KEY-----\n#{key_content}\n-----END PUBLIC KEY-----"
          OpenSSL::PKey::RSA.new(pem)
        end
      end
    end
  end
end
