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
  code:         "TEST_#{Time.now.to_i}",
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

d = Dataset.find( d.full_code )
d.name = 'New Name'
d.data = Quandl::Data::Random.table.to_csv
d.save

d = Dataset.collapse(:weekly).find( d.full_code )
d.data
=> [[...],...]

```


#### Delete

```ruby

Dataset.destroy_existing('SOME_SOURCE/SOME_CODE')
Dataset.destroy_existing(52352)

Dataset.find('SOME_SOURCE/SOME_CODE')
=> nil

```


#### Error Handling

```ruby

d = Dataset.create(code: 'TEST', source_code: 'OFDP', locations: [{ type: 'http', url: 'test.com' }] )
d.error_messages
=>  {:name=>["can't be blank"]}

d = Dataset.create(name: 'asdfs', code: 'TEST', source_code: 'OFDP', locations: [{ type: 'http', url: 'test.com' }] )
d.error_messages
=>  {"code"=>["has already been taken"], "frequency"=>["is not included in the list"]}

```




## Quandl::Client::Source


#### Search

```ruby

sources = Quandl::Client::Source.query('can').all

=> [#<Quandl::Client::Source(sources/413) code="STATSCAN5" datasets_count=1>...]

```


#### Show

```ruby

s = Quandl::Client::Source.find('STATSCAN5')

```


#### Create

```ruby

s = Source.create( code: 'test' )
s.valid?
s.error_messages
=> {:code=>["is invalid"], :host=>["can't be blank"], :name=>["can't be blank"]}

s = Source.create(code: %Q{TEST_#{Time.now.to_i}}, name: 'asdf', host: "http://asdf#{Time.now}.com" )
s.saved?
=> true

```


#### Update

```ruby

s = Source.find(s.code)
s.name = "Updated Name #{Time.now.to_i}"
s.code = "DATA_#{Time.now.to_i}"
s.save

```


#### Delete

```ruby

Source.destroy_existing('SOMESOURCE')
Source.destroy_existing(52352)

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

s = Quandl::Client::Sheet.create( title: 'ocean' )
s = Quandl::Client::Sheet.create( full_url_title: 'ocean/river', title: 'River' )
s = Quandl::Client::Sheet.create( full_url_title: 'ocean/river/lake', title: 'Lake!' )

Sheet.find('ocean/river/lake').title
=> 'Lake!'

Sheet.find('ocean').children.first.title
=> River

```


#### Update

```ruby

s = Quandl::Client::Sheet.find('ocean/river')
s.title = "River #{Time.now.to_i}"
s.save

```


#### Delete

```ruby

Quandl::Client::Sheet.destroy_existing('ocean/river/lake')

Quandl::Client::Sheet.destroy_existing(15252)

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

