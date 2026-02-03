# frozen_string_literal: true

require_relative 'allinpay_cnp/version'
require_relative 'allinpay_cnp/config'
require_relative 'allinpay_cnp/signature'
require_relative 'allinpay_cnp/response'
require_relative 'allinpay_cnp/request'
require_relative 'allinpay_cnp/client'

module AllinpayCnp
  class Error < StandardError; end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      if block_given?
        yield(config)
      end
      config
    end

    def client
      Client.new
    end
  end
end
