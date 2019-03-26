# README

This README would normally document whatever steps are necessary to get the
application up and running.
# Open API Album Search for Spotify by year
##### A Ruby on Rails Open API Search that allows an authenticated user to enter a valid year and get a response of Albums released in that year, pulling from Spotifys Web API
#

###### Ruby version 2.5
###### Rails version 5
#

##### Development 
http://localhost:3000/

##### Production
https://hotel-engine-open-api-search.herokuapp.com


A Ruby on Rails client and API with the following features:
  - Authentication using JSON Web Tokens
  - Consumes Spotify Web Api
  - RESTful endpoints to create, save and delete searches/search results
  - Sorting Search Results by Album name
  - Filtering Search Results by Artist name
  - Sorting all of a Users Search Results by release date 
  - Response pagination
  - Response caching for database records
  - Performant database queries/design
 
    
  ### 

## Authentication
In order to use the search, you first need to be an authenticated user. First signup for an account, then login (grab the access token returned in the headers), and then provide that auth token in your header for your subsequent requests. Follow the steps below.
- Visit `/signup` and provide `email`, `password`, and `password_confirmation` in headers
- Visit `login` and provide `email` and `password` in headers
- Visit `/searches` or `/user_searches` and provide the `auth token` returned from the `login` response in your header

 ( Example `key: Authorization` `value: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0Iiwic2NwIjoidXNl`)
 
 ### Auth Endpoints

| Method | Endpoint | Action  |
| ----- | ------ | ----- |
| POST | /signup | registration#create|
| POST | /login | sessions#create|
| DELETE| /logout |sessions#destroy|


### Search

In order to create a search and get a response with albums that were released in that year, provide a year in `YYYY` format from the `/searches` endpoint. 
If you would like to view the results from every search you have performed, visit `/user_searches`.
If you would like to delete the results from a specific year, visit `/searches/{YYYY}` and provide the year you want to delete the results from.

Filtering and sorting are availale for both the `/user_searches` and `searches`. See sort and filer options in sections below.


### Search Endpoints

| Method | Endpoint | Action  | Description |
| ----- | ------ | ----- | ----------  | 
| GET | /searches{?year=YYYY}| searches#index |  find or create a search result by year
| GET | /user_searches | searches#user_searches| view all of the users search results
| DELETE | /searches/{YYYY} | searches#delete| delete all searches and search results for provided year

#
### Search Response

##### Example response for: /searches?search=2017
 ````
 {
    "search_results": [
        {
            "release_date": "2017-08-25",
            "album_name": "17",
            "album_url": "https://open.spotify.com/album/5VdyJkLe3yvOs0l4xXbWp0"
        },
        {
            "release_date": "2017-06-16",
            "album_name": "Pretty Girls Like Trap Music",
            "album_url": "https://open.spotify.com/album/5vvvo79z68vWj9yimoygfS"
        },
        {
            "release_date": "2017-10-20",
            "album_name": "Flicker (Deluxe)",
            "album_url": "https://open.spotify.com/album/7ahctQBwcSxDdP0fRAPo2p"
        },
        {
            "release_date": "2017-02-03",
            "album_name": "I Decided.",
            "album_url": "https://open.spotify.com/album/0XAIjjN5qxViVS0Y5fYkar"
        }
    ]
}
````
#

### Sorting
##### To sort a Users Searches or Search Results

OPTIONS
- ###### `/searches?sort=album_name`    ( Sort the most recent search results by album name)
- ###### `/user_searches?sort=album_name`  ( Sort all of the search results a user has made by album made)

### Filtering
#### 

OPTIONS
- ###### `/searches?album=Hello`  ( Filter all of the users saved search results  by album name)
- ###### `/user_searches?year=2015`   ( Filter all of the users saved search results by year provided in query)
- ###### `/user_searches?album=Hello`  ( Filter all of the users saved search results  by album name)

### Pagination

Each response has a max limit of 50 and will return 10 at a time using pagination. 

### Caching
Using Redis, database responses are cached for 10 min

### Testing

Request specs for authentication, how unsucessful reuqests are and invalid queries are handled 
```sh
$ rspec/requests
```

###  Errors
###### Example Invalid search query response
#
{
    "error": "Please enter a valid year (1950-2019)"
}

### Database Relationships

| Model | Relaitionship | Associated Model|
| ----- | ------ | ----- |
| User | has_many| searches |
| User | has_many | search_results|
| Search | belongs_to| user |
| SearchResult | belongs_to | User|
