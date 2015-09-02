require "resalty/version"
require 'uri'
module Resalty
  class Resalty

    def txt(number, msg, sender)
      if /^(?:[A-Za-z]+(?:\s+|$)){2,3}$/.match(msg)
        buffer = call 'sendSMS', {to: number, msg: msg, sender: sender}
      else
        buffer = call 'sendSMS', {to: number, msg: msg, sender: sender, encoding: 'utf-8'}
      end
      # json.parse(buffer)
      messageId = buffer.MessageID
      Message.create(messageID:messageID, number:number, msg:msg)
      Message.save
      CheckMessageStatus.perform_in(30.seconds, messageID)
    end

    def balance
      call('getBalance').to_i
    end

    def status(msg_id)
      call 'msgQuery', msgid: msg_id.to_s
    end

    private

    def call(api, options = {})
      userid = 'eptikar'
      password = 'H8GPX-2GH6Y'

      params = options.map{|k,v| "#{k}=#{URI.encode(v.to_s)}"}.join('&')
      params = "&" + params unless params.blank?

      open("https://www.resalty.net/api/#{api}.php?userid=#{userid}&password=#{password}#{params}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    end

  end
end
