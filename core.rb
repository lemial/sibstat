require 'net/http'
require 'uri'
require 'openssl'
require 'json'

class GetInfoCore

  PRICE_BTC_JSON_URL = 'https://bitex.club/api/v2/trades?market=sibbtc'
  PRICE_USD_JSON_URL = 'https://btc-e.com/api/2/btc_usd/trades'
  PRICE_RUR_JSON_URL = 'https://btc-e.com/api/2/btc_rur/trades'
  HASHRATE_JSON_URL = 'https://digger.pw/api/stats'

  def initialize
  end

  def connect(method)

    if method == 'btc'
      uri = URI.parse(PRICE_BTC_JSON_URL)
    elsif method == 'usd'
      uri = URI.parse(PRICE_USD_JSON_URL)
    elsif method == 'rur'
      uri = URI.parse(PRICE_RUR_JSON_URL)
    elsif method == 'hashrate'
      uri = URI.parse(HASHRATE_JSON_URL)
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    parsed = JSON.parse(response.body)

    if method == 'btc'

      result = parsed[0]['price']
      result = '%.8f' % result

      puts('Write price BTC to file is OK!') if File.write('price_btc.txt', result)
      @btc = result

    elsif method == 'usd'

      firstelement = parsed.first(1)
      result = firstelement[0]['price'].to_f * @btc.to_f
      result = '%.8f' % result

      puts('Write price USD to file is OK!') if File.write('price_usd.txt', result)
      @usd = result

    elsif method == 'rur'

      firstelement = parsed.first(1)
      result = firstelement[0]['price'].to_f * @btc.to_f
      result = '%.8f' % result

      puts('Write price RUR to file is OK!') if File.write('price_rur.txt', result)
      @rur = result

    elsif method == 'hashrate'

      temparrayfirst = Array[]
      temparraysecond = Array[]

      parsed['algos']['x11'].each do |element|
        temparrayfirst.push(element)
      end

      temparrayfirst.each do |element|
        temparraysecond.push(element[1])
      end

      result = temparraysecond[1]
      result = '%.8f' % result

      puts('Write Hashrate to file is OK!') if File.write('hashrate.txt', result.to_i)
      @hashrate = result

    end
  end

end