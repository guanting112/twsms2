require 'minitest/autorun'
# require 'webmock/minitest'
require 'twsms2'

describe 'Twsms2::Client' do
  before do
    @fake_username = 'TwSMS2 API 單元測試'
    @fake_password = Time.now

    @sms_client = Twsms2::Client.new(username: @fake_username, password: @fake_password)
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