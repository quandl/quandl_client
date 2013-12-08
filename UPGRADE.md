## 2.3.1

* bump quandl_data
* add human_error_messsages


## 2.3.0

* add auth_token attribute to user
* add Quandl::Client::User, .login for authenticating
* full_url outputs the quandl link instead of the api link. Add human_status and HTTP_STATUS_CODES
* should validate display_url as a url
* add reference_url alias for display_url. reference_url will automatically add http when missing


## 2.2.1

* full_code: dont assume that source_code is present
* Dataset#data scope is cached to permit building across multiple lines. add Dataset#reload to wipe data_scope, dataset_data


## 2.2.0

* add specs for Dataset.query
* Dataset.query.all.metadata should pass


## 2.1.4

* add specs for Dataset.query(term).all; make specs pass



## 2.1.3

* add specs for data scopes
* fix failing data scope specs


## 2.1.2

* bump quandl_data, operation, logger


## 2.0.1

* fully qualified classes to avoid collisions

## 2.0.0

* update client to take advantage of new /api/v2 routes

## 0.1.17

* Dataset#source_code is optional


## 0.1.16

* add sheet description

## 0.1.15

* revise parse_json to respond with more informative error
* validation errors should return 422

## 0.1.14

* add Dataset#locations spec to test that location data is returned in the same order as it is sent.

## 0.1.12

* fix undefined error method

## 0.1.11

* add spec for Dataset#availability_delay
* add present?, exists?, blank? that check against response status.
* remove erroneous source_code and code validations.


## 0.1.10

* Add Dataset#availability_delay