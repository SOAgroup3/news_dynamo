# The News Lens Grabber web service

###Authors : Anita Lin, Peggy Chao
In this service platform, we grab data from [The News Lens].
[The News Lens]:http://www.thenewslens.com/
##Techs
### Heroku Base
  - UI : https://newslensui.herokuapp.com/
  - Service : https://newsdynamo.herokuapp.com/  

### Amazon 
  - Dynamo DB : https://us-west-2.console.aws.amazon.com/dynamodb/home?region=us-west-2#  
 
### Description 
This service could provide some functions to read some information of the news from the homepage of "The News Lens website". The service provide the information "title, author, date and abstract" of the news. Users can read the amount or keyword of the news that he wanted or to read the news that TNL website editted.

  - **GET   / **  
  returns the status to indicate service is alive
  - **GET   /api/v1/?**  
   returns " Thenewslens service /api/v1 is up and working, you can search the number of news or more functions."

###Usage

There are several APIs you can use:

  - The amount of the news (GET /api/v1/:number.json)  
  https://newsdynamo.herokuapp.com/api/v1/:number.json  
Users can type the number to show the same amount of the news
  example: ```:number = 4``` shows the four news.

  - The keyword search (GET /api/v1/keywords/:word.json)  
  https://newsdynamo.herokuapp.com/api/v1/keywords/:word.json  
Users can type the keyword to search if there are the keyword in the titles of the news on the homepage.
  example: ```：word = 台灣``` 

  - The News Lens website editted (GET api/v1/newest_original)  
  https://newsdynamo.herokuapp.com/api/v1/newest_original  
  It will show the author of "NTL編輯" of the news that refreshed today  to users. (It get the data from the dynamo database)

  - Database refresh(GET /api/v1/originalnews)  
  It uses the IRON.worker to get the data to database everyday

  - The number of classification of "title, author or date"  
  1. **POST /api/v1/class**  
  Use the post method to create the database to save the query
  2. **GET /api/v1/class/:id**  
  Get the query from database to classify the column
  3. **DELETE /api/v1/class/:id**  
  Clear the database

