require 'pry'
require 'quandl/client'

Quandl::Client.use 'http://www.quandl.com:80/api/'
Quandl::Client.token = 'admin'
include Quandl::Client

code = 'DMDRN_XCR_STDEV'
# string = `quandl download OFDP/#{code}`
d = Dataset.find('OFDP/'+code)
d.source_code = 'DMDRN'
d.code = d.code.gsub('DMDRN_','')
d.save