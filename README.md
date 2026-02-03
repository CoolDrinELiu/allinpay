AllinpayCnp
Allinpay CNP Cross-border Credit Card Payment Ruby SDK. 通联支付 CNP 跨境信用卡收单 Ruby SDK。

1. Installation / 安装
Add to your Gemfile: 在 Gemfile 中添加：

Ruby
gem 'allinpay_cnp', git: 'https://github.com/CoolDrinELiu/allinpay'
2. Configuration / 配置
Rails Project / Rails 项目
Create config/initializers/allinpay_cnp.rb: 创建初始化文件：

Ruby
AllinpayCnp.configure do |config|
  config.merchant_id = Rails.application.credentials.dig(:allinpay, :merchant_id)
  config.private_key = Rails.application.credentials.dig(:allinpay, :private_key)
  config.public_key  = Rails.application.credentials.dig(:allinpay, :public_key)
  config.environment = Rails.env.production? ? :production : :test
  config.logger      = Rails.logger
end
3. Usage / 使用方法
Unified Pay / 统一收银台支付
Redirect users to Allinpay payment page. 跳转至通联支付页面完成支付。

Ruby
client = AllinpayCnp.client

response = client.unified_pay(
  access_order_id: "ORDER_#{Time.now.to_i}",
  amount: '100.00',
  currency: 'HKD',
  notify_url: 'https://your-domain.com/webhooks/allinpay',
  return_url: 'https://your-domain.com/payments/complete',
  email: 'customer@example.com',
  shipping: { 
    first_name: 'Peter', last_name: 'Zhang', address1: '123 Test St', 
    city: 'HK', country: 'HK', zip_code: '000000', phone: '12345678' 
  }
)

redirect_to response.payment_url if response.success?
Query & Refund / 查询与退款
Ruby
# Query Order / 查询订单
response = client.query('ORIGINAL_ORDER_123')
puts response.status if response.success? # SUCCESS, FAIL, PROCESSING

# Refund / 退款
response = client.refund(
  ori_access_order_id: 'ORIGINAL_ORDER_123',
  refund_amount: '50.00'
)
Handle Webhook / 验证异步回调
Verify the signature and handle payment results. 验证签名并处理支付结果。

Ruby
def allinpay
  client = AllinpayCnp.client
  
  # Verify Signature / 验证签名
  unless client.verify_callback(params.to_unsafe_h)
    render plain: 'FAIL' and return
  end

  if params[:resultCode] == '0000'
    # Handle business logic / 处理业务逻辑
  end

  render plain: 'SUCCESS' # Must return SUCCESS / 必须返回 SUCCESS
end
4. Response Object / 响应对象
Every API call returns a Response object. 所有 API 调用均返回 Response 对象：

response.success?: Boolean result / 是否成功

response.result_desc: Error message / 错误描述

response.payment_url: Gateway URL / 支付跳转地址

response.status: Order status for query / 订单状态

response.body: Raw response Hash / 原始响应数据
