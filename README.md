Twsms2 ( 台灣簡訊 TwSMS API Ruby 版套件 )
=================================================

[![Gem Version](https://badge.fury.io/rb/twsms2.svg)](https://badge.fury.io/rb/twsms2)
[![Build Status](https://travis-ci.org/guanting112/twsms2.svg?branch=master)](https://travis-ci.org/guanting112/twsms2)
[![Code Climate](https://codeclimate.com/github/guanting112/twsms2/badges/gpa.svg)](https://codeclimate.com/github/guanting112/twsms2)

![twsms](http://i.imgur.com/KVuaBIm.png)

此為針對 [台灣簡訊][twsms_homepage] TwSMS API 開發的專屬套件

您可以透過該套件來實作台灣簡訊的一般、預約簡訊發送 與 簡訊餘額查詢 的程式

適用於
--------

Ruby 2 以上的版本，也可在 Ruby On Rails 專案引入

安裝方式
--------

請在您的 Ruby 或 Rails 專案裡的 Gemfile 加入以下指令

```ruby
gem 'twsms2', '~> 1.2.0'
```

然後執行 bundle install 更新套件組

    $ bundle

或也可以直接將 twsms2 裝在系統上

    $ gem install twsms2

使用方式
--------

本 API 套件，提供幾組以下方法來方便您開發簡訊相關服務

基本執行範例如下，但要使用前，需要先[註冊台灣簡訊的會員][twsms_signup]，否則無法存取相關服務

```ruby
require 'twsms2'

# 程式將會以 SSL 的方式，走 https 連線到簡訊商的系統
sms_client = Twsms2::Client.new(username: '會員帳號', password: '會員密碼')
```

也可以加入 agent ( user-agent ) 跟 timeout ( 逾時時間/秒 ) 參數 至 client 物件

```ruby
sms_client = Twsms2::Client.new(
  username: '會員帳號',
  password: '會員密碼',
  agent: "Mozilla/5.0 ( Hello World )",
  timeout: 10
)
```

使用範例
--------

### 系統檢查

檢查帳號是否有效、是否可以發送簡訊，有效為 true、無效則為 false

```ruby
sms_client.account_is_available
```

### 發送簡訊

#### 一般使用

手機號碼格式 0911222333 ( 台灣手機 )、886911222333 ( 國碼 + 手機號碼 )

根據台灣簡訊說明，台灣門號每則扣 1 通，國際門號每則扣 3 通

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容.."
```

#### 預約發送

若要使用預約發送，可以指定 at 參數給 send_message 方法

同時程式會自動轉換時區 至 台灣簡訊 適用的時區 ( +08:00 )

```ruby
# 純 Ruby 請用加秒數的方式
sms_client.send_message to: '手機號碼', content: "預約簡訊測試: #{Time.now}", at: Time.now + 120

# 在 Ruby On Rails 專案則可以用 Rails 專用的方法
sms_client.send_message to: '手機號碼', content: "預約簡訊測試: #{Time.now}", at: Time.now + 2.days
```

#### 強制直接顯示簡訊內容

可以加入 popup 參數，讓簡訊在收訊人的手機上直接顯示，但有可能不會被手機儲存

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容..", popup: true
```

#### 關閉長簡訊支援

一般發送簡訊時，程式預設支援長簡訊發送

因此，若超 SMS 簡訊字元長度，將會以第二封起開始計算

加入 long 參數，若指定為 false 則不會使用長簡訊格式

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容..", long: false
```

詳細規則請以 台灣簡訊 公告為主

### 發送簡訊 的 回傳結果

#### 發送成功

當你執行完成後，send_message 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表發送成功

系統會另外回傳一組 message_id 用來讓你追蹤簡訊

```ruby
{:access_success=>true, :message_id=>"217620029", :error=>nil}
```

#### 發生錯誤時

若 access_success 為 false 則表示過程有出現錯誤

以下範例為帳號密碼的錯誤，error 參數則是台灣簡訊的 error code

error code 的部分，請以 台灣簡訊 API 文件的定義為主，本套件不處理相關結果

```ruby
{:access_success=>false, :message_id=>nil, :error=>"TWSMS:00010"}
```

----

### 查詢目前帳號所持有的簡訊餘額

若你需要查詢您會員帳號的簡訊餘額，可以用以下指令處理

```ruby
sms_client.get_balance
```

### 查詢目前帳號所持有的簡訊餘額 的 回傳結果

#### 得到簡訊餘額

當你執行完成後，get_balance 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表系統有成功取得資料

message_quota 則是簡訊餘額，代表你還剩幾封可以用，若為 0 就代表都沒有

```ruby
# 備註：簡訊商若發送過程中出現意外狀況，會晚點將簡訊額度補回您的會員帳號
{:access_success=>true, :message_quota=>77, :error=>nil}
```

#### 發生錯誤時

若 access_success 為 false 則表示過程有出現錯誤，同時 message_quota 會為 0

```ruby
{:access_success=>false, :message_quota=>0, :error=>"TWSMS:00010"}
```

### 查詢特定的簡訊發送狀態

若你需要查詢特定的簡訊發送狀態，您可以指定 手機號碼 跟 message id 向簡訊商查詢該封簡訊最後是否已發送成功

```ruby
sms_client.get_message_status(message_id: '在 send_message 得到的 message_id', phone_number: '手機號碼')
```

### 查詢特定的簡訊發送狀態 的 回傳結果

#### 得到發送狀況

當你執行完成後，get_message_status 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表系統有成功取得資料

is_delivered 代表是否已寄到用戶手機，true 為是、false 為有發生 delivered 以外的狀況

message_status 代表訊息狀態，可以知道是否已抵達 或是 發生通信上的錯誤 等等的相關資訊

```ruby
{:access_success=>true, :is_delivered=>true, :message_status=>"delivered", :error=>nil}
```

#### get_message_status 裡的 message_status 涵義

```ruby
'delivered'                   # 簡訊已抵達 
'expired'                     # 簡訊寄送超過有效時間 
'deleted'                     # 已被刪除 
'undelivered'                 # 無法送達 
'transmitting'                # 傳輸中，正在接收 
'unknown'                     # 未知錯誤，可能無效 
'rejected'                    # 被拒絕 
'incorrect_sms_system_syntax' # 簡訊商編碼錯誤 
'incorrect_phone_number'      # 不正確的電話號碼 
'incorrect_content'           # 不正確的內容 
'sms_system_other_error'      # 簡訊商系統錯誤 
'illegal_content'             # 不合法的簡訊內容 
'status_undefined'            # 核心 API 無法得知狀況 
```

#### 發生錯誤時

若 access_success 為 false 則表示過程有出現錯誤，同時 is_delivered 會為 false，message_status 也會是 nil

```ruby
{:access_success=>false, :is_delivered=>false, :message_status=>nil, :error=>"TWSMS:00010"})
```

----

例外狀況的處理
--------

在某些情況下，程式會擲出一些例外給 ruby 去處理，你可以先用 Twsms2 自帶的 Error 來先做 rescue

```ruby

begin
  sms_client.account_is_available
rescue Twsms2::ClientError
  'Client 物件有內部錯誤'
rescue Twsms2::ServerError => error
  "伺服器端有一些無法處理的狀況 #{error.message}"
rescue Twsms2::ClientTimeoutError
  "發生 Timeout 囉"
rescue Twsms2::Error => error
  "發生非預期的錯誤 #{error.message}"
end

```

LICENSE
--------

本專案原始碼採 MIT LICENSE 授權 ( 詳見 LICENSE 檔案 )

連結分享
--------

[註冊台灣簡訊的會員][twsms_signup]、[台灣簡訊官網 與 API 文件][twsms_homepage]

[twsms_signup]: https://www.twsms.com/accjoin.php
[twsms_homepage]: https://www.twsms.com/

