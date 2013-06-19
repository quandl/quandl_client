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



## Quandl::Client::Sheet


#### Search

```ruby

sheets = Quandl::Client::Sheet.url_title('housing').query('hood').page(2).all

=> [#<Quandl::Client::Sheet(sheets) title="hood" url_title="housing/hood">,...]

```


#### Show

```ruby

sheet = Quandl::Client::Sheet.find_by_url_title('housing/hood')

```



## Quandl::Client::Sheet


#### Search

```ruby

require 'quandl/client'

Quandl::Client.use 'http://localhost:3000/api/'

sources = Quandl::Client::Source.query('canada').all
=> [#<Quandl::Client::Source(sources) code="STATSCAN5" datasets_count=1>,...]

source = Quandl::Client::Source.find('STATSCAN5')
dataset = source.datasets.page(2).first
dataset.data_table

```


#### Show

```ruby

sheet = Quandl::Client::Sheet.find_by_url_title('housing/hood')

```


#### Create


```ruby

Quandl::Client.token = 'xyz'

s = Quandl::Client::Sheet.create(title: 'Hi there', content: 'magic')

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

