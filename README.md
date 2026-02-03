# AllinpayCnp

通联支付 CNP 跨境信用卡收单 Ruby SDK。

## 安装

### 方式一：从本地安装

```bash
cd allinpay_cnp
gem build allinpay_cnp.gemspec
gem install allinpay_cnp-0.1.0.gem
```

### 方式二：Gemfile 引用

```ruby
# Gemfile
gem 'allinpay_cnp', path: '/path/to/allinpay_cnp'

# 或 git
gem 'allinpay_cnp', git: 'https://github.com/your-org/allinpay_cnp'
```

然后运行：

```bash
bundle install
```

## 使用方法

### 1. 创建客户端

```ruby
require 'allinpay_cnp'

client = AllinpayCnp.client(
  merchant_id: '086310030670001',
  private_key: File.read('private_key.pem'),
  public_key: File.read('public_key.pem'),  # 可选，用于验签
  environment: :test                         # :test 或 :production
)
```

### 2. 统一收银台支付

```ruby
response = client.unified_pay(
  access_order_id: 'ORDER_#{Time.now.to_i}',
  amount: '100.00',
  currency: 'HKD',
  notify_url: 'https://your-domain.com/callback',
  return_url: 'https://your-domain.com/return',
  email: 'customer@example.com',
  shipping: {
    first_name: 'Peter',
    last_name: 'Zhang',
    address1: '123 Test Street',
    city: 'Hong Kong',
    country: 'HK'
  }
)

if response.success?
  redirect_to response.payment_url
else
  puts 'Error: #{response.result_desc}'
end
```

### 3. 查询订单

```ruby
response = client.query('ORDER_123')

if response.success?
  puts '状态: #{response.status}'
  puts '金额: #{response.amount}'
end
```

### 4. 退款

```ruby
response = client.refund(
  ori_access_order_id: 'ORDER_123',
  refund_amount: '50.00'
)

puts response.success? ? '退款成功' : '退款失败: #{response.result_desc}'
```

### 5. 处理回调

```ruby
# Rails Controller
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def allinpay_callback
    unless client.verify_callback(params.to_unsafe_h)
      render plain: 'FAIL' and return
    end

    if params[:resultCode] == '0000'
      # 处理支付成功
    end

    render plain: 'SUCCESS'
  end
end
```

## API 地址

| 环境 | 地址 |
|------|------|
| 测试 | https://cnp-test.allinpay.com/gateway/cnp/unifiedPay |
| 生产 | https://cnp.allinpay.com/gateway/cnp/unifiedPay |

## 运行测试

```bash
bundle install
bundle exec rspec
```

## License

MIT
