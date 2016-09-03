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

  describe '確認一下字串編碼是否為 UTF-8' do
    it '必須要是 UTF-8' do
      "簡訊測試 #{Time.now}".encoding.to_s.must_equal('UTF-8')
    end
  end

  describe '測試 client 的用的 轉換 time zone 方法' do
    it '應該會是 +8:00 的時區' do
      custom_time_with_leap_year   = Time.new(2008, 2, 29, 1, 2, 3, '+12:00')
      custom_time_2_with_leap_year = Time.new(2008, 2, 29, 10, 20, 30, '+12:00')
      new_time = @sms_client.to_asia_taipei_timezone(custom_time_with_leap_year)

      result = custom_time_with_leap_year == new_time && 
               custom_time_2_with_leap_year != new_time && 
               new_time.strftime('%z') == '+0800'

      result.must_equal(true)
    end
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