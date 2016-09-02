module Twsms2
  module Formatter
    def match_string(rule, string)
      match_data = rule.match(string)
      match_data.nil? ? nil : match_data[1]
    end

    def format_send_message_info(original_info)
      new_info = {
        access_success: false,
        message_id: nil,
        error: nil
      }

      code_text  = match_string(/<code>(?<code>\w+)<\/code>/, original_info)
      message_id_text = match_string(/<msgid>(?<message_id>\d+)<\/msgid>/, original_info)

      new_info[:access_success] = !code_text.nil? && !message_id_text.nil? && code_text == '00000'

      if new_info[:access_success]
        new_info[:message_id] = message_id_text
      else
        new_info[:error] = "TWSMS:CODE_NOT_FOUND"
        new_info[:error] = "TWSMS:#{code_text}" unless code_text.nil?
        new_info[:error].upcase!
      end

      new_info
    end

    def format_balance_info(original_info)
      new_info = {
        access_success: false,
        message_quota: 0,
        error: nil
      }

      code_text  = match_string(/<code>(?<code>\w+)<\/code>/, original_info)
      point_text = match_string(/<point>(?<point>\d+)<\/point>/, original_info)

      new_info[:access_success] = !code_text.nil? && !point_text.nil? && code_text == '00000'

      if new_info[:access_success]
        new_info[:message_quota] = point_text.to_i
      else
        new_info[:error] = "TWSMS:CODE_NOT_FOUND"
        new_info[:error] = "TWSMS:#{code_text}" unless code_text.nil?
        new_info[:error].upcase!
      end

      new_info
    end

  end
end