
[ ![Codeship Status for SOAgroup3/news_service](https://codeship.com/projects/6bdad4b0-6052-0132-bef6-0265a0814e00/status)](https://codeship.com/projects/51617)

## The-Newslens_App webservice

Authors : LinAnita, peyruchao(peggy) and ethancychen

## Heroku web service

> https://thenewslensapp2.herokuapp.com

### Introduction: Read the hot news from The News Lens ( http://www.thenewslens.com )

> This service could provide users a website to get some important information of the news.


###Usage

- GET   /
   returns the home page of our service.

- GET   /news
   returns a page could let users to input how many news that want to read.

- GET   /news/:number   
   returns JSON of <number> of the least news include : title, author, dates.

- GET   /tutorials
   returns an advanced function to catch the data from database.

- POST  /api/v1/specify.json
   takes JSON: array of column header
   returns: array of news titles on NewLens 
