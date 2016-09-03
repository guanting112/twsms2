Twsms2 ( 2016 新版 台灣簡訊 TwSMS API Ruby 版套件 )
=================================================

[![Gem Version](https://badge.fury.io/rb/twsms2.svg)](https://badge.fury.io/rb/twsms2) [![Build Status](https://travis-ci.org/guanting112/twsms2.svg?branch=master)](https://travis-ci.org/guanting112/twsms2)

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
gem 'twsms2', '~> 1.1.0'
```

然後執行 bundle install 更新套件組

    $ bundle

或也可以直接將 twsms2 裝在系統上

    $ gem install twsms2

使用方式
--------

本 API 套件，提供幾組以下方法來方便您開發簡訊相關服務

但要使用前，需要先[註冊台灣簡訊的會員][twsms_signup]，否則您的程式無法存取台灣簡訊的 API 管道

```ruby
require 'twsms2'

# Twsms2 是走 https 的方式進行系統操作
sms_client = Twsms2::Client.new(username: '會員帳號', password: '會員密碼', agent: "Mozilla/5.0 (可自訂 user-agent)")
```

使用範例
--------

### 系統檢查

檢查帳號是否有效、是否可以發送簡訊，有效為 true、無效則為 false

```ruby
sms_client.account_is_available
```

----

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

可以加入 popup 參數，讓簡訊在收訊人的手機裝置直接顯示在上面 ( 可能不會被手機儲存 )

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容..", popup: true
```

#### 關閉長簡訊支援

一般發送簡訊時，預設為長簡訊發送

因此，若超 SMS 短信字元長度，將會以第二封起開始計算

加入 long 參數，若指定為 false 則不會使用長簡訊格式

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容..", long: false
```

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

### 查詢簡訊餘額

若你需要查詢您會員帳號的簡訊餘額，可以用以下指令處理

```ruby
sms_client.get_balance
```

### 查詢簡訊餘額 的 回傳結果

#### 得到簡訊餘額

當你執行完成後，get_balance 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表系統有成功取得資料

message_quota 則是簡訊餘額，代表你還剩幾封可以用，若為 0 就代表都沒有

```ruby
# 備註：簡訊商若發送過程中出現意外狀況，會晚點將簡訊額度補回您的會員帳號
{:access_success=>true, :message_quota=>77, :error=>nil}
```

#### 發生錯誤

若 access_success 為 false 則表示過程有出現錯誤，同時 message_quota 會為 0

```ruby
{:access_success=>false, :message_quota=>0, :error=>"TWSMS:00010"}
```


LICENSE
--------

本專案原始碼採 MIT LICENSE 授權 ( 詳見 LICENSE 檔案 )

連結分享
--------

[註冊台灣簡訊的會員][twsms_signup]、[台灣簡訊官網 與 API 文件][twsms_homepage]

[twsms_signup]: https://www.twsms.com/accjoin.php
[twsms_homepage]: https://www.twsms.com/
