# CodingChallenge

Welcome to coding chalenge API! This project includes all reqired logic to run simple API as described in task. It provides 2 API endpoints for accessing it **`POST v1/import`** and **`GET v1/info/:zip`**

# POST v1/import

This API endpoint accepts 2 files, zip_to_cbsa.csv and cbsa_to_msa.zip, and imports data from them into DB.
All previously existing data will be truncated.
Please note, that not all data from CSV file gets imported into DB. Only population information for all available years gets uploaded + different LSAD types. It makes easy to update code and fetch any data not only by ZIP code, but by LSAD or YEAR too.
List of columns that will be imported for population information can be found in model as `IMPORT_FIELDS` constant. It's used everywhere except tests, so in case of adding new columns developer needs to update only DB table structure (add migration) and add new columns to this mapping.

Example:
`curl -X POST https://codechallengepeerstreet.herokuapp.com/v1/import -F 'files[zip_to_cbsa]=/data/zip_to_cbsa.csv' -F 'files[cbsa_to_msa]=/data/cbsa_to_msa.csv'`

This 2 files will be validated and after that parsed in background job to prevent long-term connections to the server.

# GET /v1/info/:zip

This API endpoint used for fetching population information from database. If no data present, it will return full schema with 'N/A' values in it. If ZIP code doesn't belong to CBSA, CBSA code will be set to 99999. Data for this API call is cached with Redis (ttl is 1 hour), and will be automatically refreshed if new data gets imported.

Example:
`curl -X GET https://codechallengepeerstreet.herokuapp.com/v1/info/501`

 => {"cbsa":35620,"name":"New York-Newark-Jersey City, NY-NJ-PA","lsad":"Metropolitan Statistical Area","pop_2010":19601147,"pop_2011":19756397,"pop_2012":19871785,"pop_2013":19994144,"pop_2014":20095119,"pop_2015":20182305,"zip":"501"}



# DDOS protection

This API also protected with some level of DDOS-protection algorythm. By default it's allowed to make 1 `POST v1/import` request per minute and 100 of any requests per 5 minutes
