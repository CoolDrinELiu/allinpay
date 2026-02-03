# frozen_string_literal: true

module AllinpayCnp
  class Config
    ENVIRONMENTS = %i[test production].freeze

    attr_accessor :merchant_id, :private_key, :public_key, :logger, :timeout
    attr_reader :environment

    def initialize
      @environment = :test
      @timeout = 30
    end

    def environment=(value)
      value = value.to_sym
      raise ArgumentError, "Invalid environment: #{value}" unless ENVIRONMENTS.include?(value)

      @environment = value
    end

    def test?
      @environment == :test
    end

    def production?
      @environment == :production
    end
  end
end
