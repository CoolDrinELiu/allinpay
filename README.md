# AllinpayCnp

通联支付 CNP 跨境信用卡收单 Ruby SDK。

## 安装

### Gemfile

```ruby
gem 'allinpay_cnp', git: 'https://github.com/your-org/allinpay_cnp'
```

### 本地安装

```bash
cd allinpay_cnp
gem build allinpay_cnp.gemspec
gem install allinpay_cnp-0.1.0.gem
```

## 配置

### Rails 项目

创建 `config/initializers/allinpay_cnp.rb`:

```ruby
AllinpayCnp.configure do |config|
  config.merchant_id = Rails.application.credentials.dig(:allinpay, :merchant_id)
  config.private_key = Rails.application.credentials.dig(:allinpay, :private_key)
  config.public_key  = Rails.application.credentials.dig(:allinpay, :public_key)
  config.environment = Rails.env.production? ? :production : :test
  config.timeout     = 30
  config.logger      = Rails.logger
end
```

### 普通 Ruby 项目

```ruby
require 'allinpay_cnp'

AllinpayCnp.configure do |config|
  config.merchant_id = '086310030670001'
  config.private_key = File.read('private_key.pem')
  config.public_key  = File.read('public_key.pem')
  config.environment = :test  # :test 或 :production
  config.timeout     = 30
  config.logger      = Logger.new($stdout)
end
```

### 配置项

| 配置项 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| `merchant_id` | String | 是 | 商户号 |
| `private_key` | String | 是 | 商户私钥 (PEM 格式) |
| `public_key` | String | 否 | CNP 公钥，用于验证回调签名 |
| `environment` | Symbol | 否 | `:test` (默认) 或 `:production` |
| `timeout` | Integer | 否 | 请求超时时间，默认 30 秒 |
| `logger` | Logger | 否 | 日志对象 |

## 使用方法

### 获取客户端

```ruby
client = AllinpayCnp.client
```

### 统一收银台支付 (Unified Pay)

跳转到通联支付页面完成支付：

```ruby
response = client.unified_pay(
  access_order_id: "ORDER_#{Time.now.to_i}",
  amount: '100.00',
  currency: 'HKD',
  urls: {
    notify_url: 'https://your-domain.com/webhooks/allinpay',
    return_url: 'https://your-domain.com/payments/complete'
  },
  email: 'customer@example.com',
  language: 'zh-hant',  # 可选: zh-hant, zh-hans, en
  shipping: {
    first_name: 'Peter',
    last_name: 'Zhang',
    address1: '123 Test Street',
    city: 'Hong Kong',
    country: 'HK',
    zip_code: '000000',
    phone: '12345678'
  },
  billing: {
    first_name: 'Peter',
    last_name: 'Zhang',
    address1: '123 Test Street',
    city: 'Hong Kong',
    country: 'HK',
    zip_code: '000000',
    phone: '12345678'
  }
)

if response.success?
  redirect_to response.payment_url
else
  puts "Error: #{response.result_desc}"
end
```

### 查询订单 (Query)

```ruby
response = client.query('ORIGINAL_ORDER_123')

if response.success?
  puts "状态: #{response.status}"          # SUCCESS, FAIL, PROCESSING
  puts "金额: #{response.amount}"
  puts "币种: #{response.currency}"
  puts "卡号: #{response.card_no}"         # 脱敏卡号
  puts "卡组织: #{response.card_orgn}"     # VISA, MASTERCARD 等
end
```

### 退款 (Refund)

```ruby
response = client.refund(
  ori_access_order_id: 'ORIGINAL_ORDER_123',
  refund_amount: '50.00'
)

if response.success?
  puts '退款成功'
else
  puts "退款失败: #{response.result_desc}"
end
```

### 验证回调签名

```ruby
# Rails Controller
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:allinpay]

  def allinpay
    client = AllinpayCnp.client

    unless client.verify_callback(params.to_unsafe_h)
      render plain: 'FAIL' and return
    end

    if params[:resultCode] == '0000'
      payment = Payment.find_by(gateway_order_id: params[:accessOrderId])
      payment&.mark_as_paid!(
        transaction_ref: params[:orderId],
        card_no: params[:cardNo],
        card_orgn: params[:cardOrgn]
      )
    end

    render plain: 'SUCCESS'  # 必须返回 SUCCESS
  end
end
```

## Response 对象

所有 API 方法都返回 `Response` 对象：

```ruby
response.success?        # 是否成功 (resultCode == '0000')
response.failure?        # 是否失败
response.result_code     # 返回码
response.result_desc     # 返回描述
response.payment_url     # 支付页面 URL (unified_pay)
response.access_order_id # 商户订单号
response.order_id        # CNP 系统订单号
response.status          # 订单状态 (query)
response.amount          # 金额
response.currency        # 币种
response.card_no         # 脱敏卡号
response.card_orgn       # 卡组织
response.body            # 原始响应 Hash
response['customField']  # 获取任意字段
```

## API 地址

| 环境 | Unified Pay | QuickPay |
|------|-------------|----------|
| 测试 | https://cnp-test.allinpay.com/gateway/cnp/unifiedPay | https://cnp-test.allinpay.com/gateway/cnp/quickpay |
| 生产 | https://cnp.allinpay.com/gateway/cnp/unifiedPay | https://cnp.allinpay.com/gateway/cnp/quickpay |

## 运行测试

```bash
bundle install
bundle exec rspec
```

## 目录结构

```
lib/
├── allinpay_cnp.rb           # 主入口
└── allinpay_cnp/
    ├── version.rb            # 版本号
    ├── config.rb             # 配置类
    ├── signature.rb          # RSA2 签名
    ├── request.rb            # HTTP 请求
    ├── response.rb           # 响应封装
    └── client.rb             # API 客户端
```

