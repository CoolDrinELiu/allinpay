# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinpayCnp::Config do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets default environment to :test' do
      expect(config.environment).to eq(:test)
    end

    it 'sets default timeout to 30' do
      expect(config.timeout).to eq(30)
    end
  end

  describe '#merchant_id' do
    it 'can be set and retrieved' do
      config.merchant_id = '086310030670001'
      expect(config.merchant_id).to eq('086310030670001')
    end
  end

  describe '#private_key' do
    it 'can be set and retrieved' do
      config.private_key = 'test_private_key'
      expect(config.private_key).to eq('test_private_key')
    end
  end

  describe '#public_key' do
    it 'can be set and retrieved' do
      config.public_key = 'test_public_key'
      expect(config.public_key).to eq('test_public_key')
    end
  end

  describe '#environment=' do
    it 'accepts :test' do
      config.environment = :test
      expect(config.environment).to eq(:test)
    end

    it 'accepts :production' do
      config.environment = :production
      expect(config.environment).to eq(:production)
    end

    it 'accepts string and converts to symbol' do
      config.environment = 'production'
      expect(config.environment).to eq(:production)
    end

    it 'raises error for invalid environment' do
      expect { config.environment = :invalid }.to raise_error(ArgumentError, /Invalid environment/)
    end
  end

  describe '#test?' do
    it 'returns true when environment is :test' do
      config.environment = :test
      expect(config.test?).to be true
    end

    it 'returns false when environment is :production' do
      config.environment = :production
      expect(config.test?).to be false
    end
  end

  describe '#production?' do
    it 'returns true when environment is :production' do
      config.environment = :production
      expect(config.production?).to be true
    end

    it 'returns false when environment is :test' do
      config.environment = :test
      expect(config.production?).to be false
    end
  end

  describe '#logger' do
    it 'can be set and retrieved' do
      logger = Logger.new($stdout)
      config.logger = logger
      expect(config.logger).to eq(logger)
    end
  end

  describe '#timeout' do
    it 'can be set and retrieved' do
      config.timeout = 60
      expect(config.timeout).to eq(60)
    end
  end
end
