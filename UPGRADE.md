## 2.13.0

* Add threadsafe_token option

## 2.12.0

* Add redirect_path attribute to Sheets

## 2.11.0

* Default URL includes www subdomain and HTTPS

## 2.10.2

## 2.10.1

## 2.10.0

* add Quandl::Client::Job

## 2.9.0

* QUGC-189 bump data

## 2.8.0

## 2.7.12

## 2.7.10

* QUGC-168 can pass request_platform

## 2.7.9

* QUGC-164 also search by code
* QUGC-164 find by id or source_code/code, or build
* QUGC-164 attributes slice needs to ensure that keys are symbols

## 2.7.8

## 2.7.7


## 2.7.6

* QUGC-140 if a source_code is given but does not exist, it should warn the user

## 2.7.5
add 'at' option for scraper scheduling

## 2.7.4
full url bug fixed when "api" has no / at the end


## 2.6.2

* QUGC-55 Add Report for filing reports



## 2.6.1

* QUGC-113 fix Dataset#data errors dont propagate to parent object
* QUGC-113 Write failing specs for Dataset#data errors dont propagate to parent object



## 2.6.0

* QUGC-104 Fixes when upload fails output is not json
* QUGC-103 Fixes quandl upload test -F json does not include metadata



## 2.5.2

* WIKI-153 Add scrapers


## 2.5.1

* QUGC-57 move data validation from Quandl::Format into Quandl::Client. Data validations only run on #valid?
* QUGC-53 numeric codes require the full code


## 2.5.0

* remove yajl


## 2.4.9

* observe ruby platform


## 2.4.7

* add middleware to track the origin of requests across quandl packages


## 2.4.6

* QUGC-43 improved message on wrong number of colums
* QUGC-41 enforce code formatting. always upcase codes
* improved example of valid code
* revise code pattern


## 2.4.5

* QUGC-40 add validation to enforce: You may not change number of columns in a dataset
* QUGC-37 Dataest.find accept backslash or forward slash interchangeably


## 2.4.4

* Dataset#data to_table assigns column_names to headers
* add skip_browse to Sheet


## 2.4.3

* hotfix for full_code pattern matching ... code can be as short as two characters


## 2.4.2

* Dataset.find will return nil unless the id is an integer, or matches the quandl pattern for full_code


## 2.4.1

* revise reference_url http prepend


## 2.4.0

* Dataset#reference_url should prepend of http:// when missing
* add Quandl::Pattern for defining regex patterns with embedded examples


# 2.3.2

* add #elapsed_request_time_ms
* refactor save_time to request_time. Add specs to #destroy for request_started_at, finished_at, elapsed_request_time
* add Client::Base#save_started_at, #save_finished_at, #elapsed_save_time. before_save :touch_save_started_at, after_save :touch_save_finished_at


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