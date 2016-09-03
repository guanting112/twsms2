require 'minitest/autorun'
# require 'webmock/minitest'
require 'twsms2'
require 'json'

describe 'Twsms2::Client' do
  before do
    @fake_username = 'TwSMS2 API 單元測試'
    @fake_password = Time.now.to_i

    @sms_client = Twsms2::Client.new(username: @fake_username, password: @fake_password)
  end

  describe '當 client 建立時，有指定 agent 參數，get 方法裡的 user-agent 是否會改變 ' do
    it '應該會變成使用者自訂的 user-agent 字串 ( 以 httpbin.org/get 為準 )' do
      custom_user_agnet = "agent: #{Time.now.to_i}"
      sms_client = Twsms2::Client.new(username: @fake_username, password: @fake_password, agent: custom_user_agnet)
      response = JSON.parse(sms_client.get('httpbin.org', '/get'))
      response['headers']['User-Agent'].must_equal(custom_user_agnet)
    end
  end

  describe '以不存在的帳號密碼，使用 send_message 方法' do
    it '必須回傳錯誤的結果，ERROR 的部分需要為 TWSMS:00010' do
      @sms_client.send_message.must_equal({:access_success=>false, :message_id=>nil, :error=>"TWSMS:00010"})
    end
  end

  describe '以不存在的帳號密碼，使用 get_balance 方法' do
    it '必須回傳錯誤的結果，ERROR 的部分需要為 TWSMS:00010' do
      @sms_client.get_balance.must_equal({:access_success=>false, :message_quota=>0, :error=>"TWSMS:00010"})
    end
  end
end