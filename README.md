
## The-Newslens_App webservice

Authors : LinAnita, peyruchao(peggy) and ethancychen

## Heroku web service

> https://newsdynamo.herokuapp.com

### Introduction: Read the hot news from The News Lens ( http://www.thenewslens.com )

> This service could provide users a website to get some important information of the news.


###Usage

- GET   /
   returns everything is ok at api/v1.

- GET   /api/v1/?
   returns everything is ok.

- GET   /api/v1/:number.json   
   returns JSON of <number> of the least news include : title, author, dates and summary.
   or  returns 404 for user not found

- GET   /api/v1/tutorials/:id
   takes: id # (1,2,3, etc.) of query
   returns an advanced function to catch the data from database.
    or  returns 404 for user not found

- POST  /api/v1/specify.json
   takes JSON: array of column header
   returns: array of news titles on NewLens 
   or  returns 404 for user not found

- POST /api/v1/tutorials
  record tutorial request to DB
  or  returns 404 for user not found

- DELETE /api/v1/tutorials/:id
  takes: id # (1,2,3, etc.) of query