require 'sinatra/base'
require 'thenewslensapi'
require 'json'
require_relative 'model/tutorial'

class NewsDynamo < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

  configure :development do
    set :session_secret, "something"    # ignore if not using shotgun in development
  end

	helpers do
    def get_news(number)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        if /^\d+$/.match(number)         
          newsfound.first(number.to_i)
        
        else 
          raise "ouch"
        end                
      rescue
        halt 404
      end
    end

    def show_col(col_name)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        news_return=Array.new
        newsfound.each do |i|          
          if i.has_key?(col_name[0])
            news_return.push(col_name=> i[col_name[0]])
          else 
            raise "ouch col"
          end
        end
        news_return
      rescue
        halt 404
      end
    end

    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end

    def tutorial_new(req)    
      tutorial = Tutorial.new
      tutorial.number = req['number'].to_json
      tutorial
    end
  end #helpers

  get '/' do
    'hehehehe~~~~ Thenewslens Dynamo is up and working at api/v1'
  end

  get '/api/v1/?' do
    "Thenewslens Dynamo /api/v1 is up and working"
  end

  get '/api/v1/:number.json' do
    content_type :json, 'charset' => 'utf-8'
    begin
      get_news(params[:number]).to_json
    rescue
      halt 404
    end
  end

  post '/api/v1/specify.json' do
    #in tux ,type:
    #  post '/api/v1/specify.json' , "{\"col_name\": [\"title\"]}"
    #
    content_type :json, 'charset' => 'utf-8'
    begin
      #get all post parameter
      req = JSON.parse(request.body.read)
      col_name = req['col_name']
      show_col(col_name).to_json
    rescue
      halt 404
    end
  end

  delete '/api/v1/tutorials/:id' do
    tutorial = Tutorial.destroy(params[:id])
  end

  post '/api/v1/tutorials' do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    tutorial = tutorial_new(req)
    
    if tutorial.save
      status 201
      redirect "/api/v1/tutorials/#{tutorial.id}"
    end
  end

  get '/api/v1/tutorials/:id' do
    content_type :json, charset: 'utf-8'
    logger.info "GET /api/v1/tutorials/#{params[:id]}"
    begin
      @tutorial = Tutorial.find(params[:id])
      number = JSON.parse(@tutorial.number)
      logger.info({ number: number }.to_json)
    rescue
      halt 400
    end
    
    get_news(number[0].to_s).to_json
  end
end