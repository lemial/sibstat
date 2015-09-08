require_relative 'core'

class GetInfo

  item = GetInfoCore.new
  item.connect('hashrate')
  item.connect('btc')
  item.connect('usd')
  item.connect('rur')

end

