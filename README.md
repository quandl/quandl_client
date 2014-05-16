# Quandl::Client

## Purpose

The purpose of this gem is to interact with the [quandl api](http://www.quandl.com/help/api)


## Installation

```ruby

gem 'quandl_client'

```


## Configuration

```ruby

require 'quandl/client'

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']


```


## Usage


### Quandl::Client::Dataset


#### Dataset Search

```ruby

datasets = Quandl::Client::Dataset.query('oil').where(frequency: 'annual', source_code: 'OFDP', page: 2).all
datasets.first.data.limit(10).to_a
=> [[Tue, 22 Oct 1974, 40.45, 41.5, 40.45, 41.35, 191.0, 262.0], ... ]

```

Available parameters:

    query
    source_code
    frequency
    page
    per_page
    owner



#### Dataset Data

attributes :data, :source_code, :code, :name, :urlize_name, 
  :description, :updated_at, :frequency, :from_date, 
  :to_date, :column_names, :private, :type

```ruby

d = Quandl::Client::Dataset.find('OFDP/COBALT_51')
d.data.first
=> [Wed, 14 May 2014, 29500.0, 30500.0, 30000.0]

d = Quandl::Client::Dataset.find('OFDP/COBALT_51')
d.data.collapse('weekly').trim_start("2012-03-31").trim_end("2013-06-30").first
=> [Sun, 30 Jun 2013, 31050.0, 32550.0, 31800.0]

```

Available parameters:

    collapse
    transformation
    trim_start
    trim_end
    rows
    exclude_headers
    row
    limit


#### Create

```ruby

attributes = {
  code:         "TEST_DATASET",
  frequency:    'daily',
  data:         '2012,10,20',
}
d = Dataset.create( attributes )

```


#### Update

```ruby

d = Dataset.find("TEST_DATASET")
d.name = 'New Name'
d.data = [['2014',10,20],['2013',20,30]]
d.save

```


#### Delete

```ruby

d = Dataset.find('TEST_DATASET')
d.destroy

```


#### Delete Data

```ruby

d = Dataset.find('TEST_DATASET')
d.delete_data
d.data
=> nil

d.delete_rows( '1998-02-01','1998-03-03' )
d.data
=> # given rows are deleted

```


### Quandl::Client::Source


#### Search

```ruby

sources = Quandl::Client::Source.query('oil').all

=> [#<Quandl::Client::Source(sources/413) code="STATSCAN5" datasets_count=1>...]

```


#### Show

```ruby

s = Quandl::Client::Source.find('NSE')

```