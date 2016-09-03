Twsms2 ( 2016 台灣簡訊 TwSMS API 套件 )
======================================

[![Gem Version](https://badge.fury.io/rb/twsms2.svg)](https://badge.fury.io/rb/twsms2) [![Build Status](https://travis-ci.org/guanting112/twsms2.svg?branch=master)](https://travis-ci.org/guanting112/twsms2)

![twsms](http://i.imgur.com/KVuaBIm.png)

此為針對 [台灣簡訊][twsms_homepage] TwSMS API 開發的專屬套件，支援 Ruby ( >= 2.1 ) 或 Ruby On Rails 

您可以透過該套件來實作台灣簡訊的基本簡訊發送 與 簡訊餘額查詢 的程式

安裝方式
--------

請在您的 Ruby 或 Rails 專案裡的 Gemfile 加入以下指令

```ruby
gem 'twsms2', '~> 1.0.0'
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
sms_client = Twsms2::Client.new(username: '台灣簡訊的會員帳號', password: '台灣簡訊的會員密碼')
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

手機號碼可以為 8869XXYYYZZZ 或 09XXYYYZZZ 的格式 ( 以簡訊系統商建議的格式為主 )

一般方式

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容 #{Time.now}"
```

你可以加入 popup 參數告訴簡訊系統，發送簡訊到收訊人的手機時要直接顯示 ( 但不會儲存在手機 )

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容 #{Time.now}", popup: true
```

本套件發送簡訊時，預設為長簡訊發送，因此若超 SMS 短信字元長度，將會以第二封起開始計算

當然您可以關閉該設計，請加入 long 參數，並指定為 false 即可

```ruby
sms_client.send_message to: '手機號碼', content: "簡訊內容 #{Time.now}", long: false
```

----

### 發送簡訊 的 回傳結果

當你執行完成後，send_message 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表發送成功，若為 false 則表示過程有出現錯誤

```ruby
{:access_success=>true, :message_id=>"217620029", :error=>nil}
```

例如：以下為帳號密碼的錯誤，error 將會記錄台灣簡訊的 error code

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

----

### 查詢簡訊餘額 的 回傳結果

當你執行完成後，get_balance 方法會回傳一組 hash 型態的結果

只要 access_success 的值為 true 就一定代表系統有成功取得資料

message_quota 則是簡訊餘額，代表你還剩幾封可以用，若為 0 就代表都沒有

```ruby
# 備註：簡訊商若發送過程中出現意外狀況，會晚點將簡訊額度補回您的會員帳號
{:access_success=>true, :message_quota=>77, :error=>nil}
```

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
