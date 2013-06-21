# Installation

```ruby

gem 'quandl_client'

```




# Configuration

```ruby

require 'quandl/client'

Quandl::Client.use 'http://localhost:3000/api/'

```




# Usage


## Quandl::Client::Dataset


#### Search

search_scope :rows, :exclude_data, :exclude_headers, :trim_start, :trim_end, :transform, :collapse

```ruby

datasets = Quandl::Client::Dataset.query('cobalt').source_code('ofdp').all
=> [#<Quandl::Client::Dataset(datasets) source_code="OFDP" code="COBALT_51">, ...]

```


#### Show

attributes :data, :source_code, :code, :name, :urlize_name, 
  :description, :updated_at, :frequency, :from_date, 
  :to_date, :column_names, :private, :type

```ruby

d = Quandl::Client::Dataset.find('OFDP/COBALT_51')
d.full_code
d.data_table


d = Quandl::Client::Dataset.collapse('weekly').trim_start("2012-03-31").trim_end("2013-06-30").find('OFDP/COBALT_51')
d.data_table


d = Quandl::Client::Dataset.exclude_data('true').find('OFDP/COBALT_51')
d.data_table

```


#### Create

```ruby

attributes = {
  code:         "TEST_12345",
  source_code:  'OFDP',
  name:         "Test Upload #{Time.now.to_i}",
  frequency:    'daily',
  locations: 
  [
    { 
      type:       'http', 
      url:        'http://test.com',
      post_data:  '[magic]', 
      cookie_url: 'http://cookies.com' 
    }
  ]
}
d = Dataset.create( attributes )

```


#### Update

```ruby

d = Dataset.find("OFDP/TEST_12345")
d.name = 'New Name'
d.data = Quandl::Data::Random.table.to_csv
d.save

d = Dataset.collapse(:weekly).find("OFDP/TEST_12345")
d.data
=> [[...],...]

```


#### Errors

```ruby

d = Dataset.create(code: 'TEST', source_code: 'OFDP', locations: [{ type: 'http', url: 'test.com' }] )
d.errors
=>  {"locations.post_data"=>["can't be blank"], "locations.cookie_url"=>["can't be blank"], "name"=>["can't be blank"], "frequency"=>["is not included in the list"]}

```




## Quandl::Client::Source


#### Search

```ruby

sources = Quandl::Client::Source.query('canada').page(2).all

=> [#<Quandl::Client::Source(sources) code="STATCAN1" title="Stat Can">,...]

```


#### Show

```ruby

sheet = Quandl::Client::Source.find('STATCAN1')

```




## Quandl::Client::Sheet


#### Search

```ruby

sheets = Quandl::Client::Sheet.query('canada').all
=> [[#<Quandl::Client::Sheet(sheets) title="La Canada Flintridge>,...]

```


#### Show

```ruby

sheet = Quandl::Client::Sheet.find('housing/hood')

```


#### Create

```ruby

include Quandl::Client

s = Sheet.create( title: 'ocean' )
s = Sheet.create( full_url_title: 'ocean/river', title: 'River' )
s = Sheet.create( full_url_title: 'ocean/river/lake', title: 'Lake!' )

Sheet.find('ocean').children.first.title
=> River

```


#### Update

```ruby

Quandl::Client.token = 'xyz'

s = Quandl::Client::Sheet.find_by_url_title('hi_there')
s.title = 'another title'
s.save

```




# Authentication

```ruby

require 'quandl/client'

Quandl::Client.use 'http://localhost:3000/api/'
Quandl::Client.token = 'xyz'


s = Quandl::Client::Sheet.find_by_url_title('testing')
s.title = 'more testing'
s.save
=> true

```

