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

s = Quandl::Client::Sheet.create( title: 'ocean' )
s = Quandl::Client::Sheet.create( full_url_title: 'ocean/river', title: 'River' )
s = Quandl::Client::Sheet.create( full_url_title: 'ocean/river/lake', title: 'Lake!' )

s = Quandl::Client::Sheet.find('ocean')

s = Quandl::Client::Sheet.create(url_title: 'housing/city/hi_there', title: 'Hi there', content: 'magic')

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

