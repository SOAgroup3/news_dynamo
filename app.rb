require 'sinatra/base'
require 'thenewslensapi'
require 'json'
require_relative 'model/classification'
require_relative 'model/keyword'

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

    def get_news_keyword(word)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        newsfound.select { |item| item["title"] =~ /#{word}/ }
      rescue
        halt 404
      end
    end

    def get_news_author(words)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        newsfound.select { |item| item["author"] =~ /#{words}/ }
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

    def classification_new(req)
      classification = Classification.new
      classification.number = req['number'].to_json
      classification
    end

    def keyword_new(key)
      keyword = Keyword.new
      keyword.word = key['word'].to_json
      keyword
    end

  end #helpers

  get '/' do
    'hehehehe~~~~ Thenewslens service is up and working at api/v1'
  end

  get '/api/v1/?' do
    "Thenewslens service /api/v1 is up and working, you can search the number of news or keywords"
  end

  get '/api/v1/:number.json' do
    content_type :json, 'charset' => 'utf-8'
    begin
      get_news(params[:number]).to_json
    rescue
      halt 404
    end
  end

  post '/api/v1/keywords' do
    content_type :json, 'charset' => 'utf-8'
    begin
      key = JSON.parse(request.body.read)
      logger.info key
    rescue Exception => e
      puts e.message
      halt 400
    end

    keyword = keyword_new(key)

    if keyword.save
      redirect "/api/v1/keywords/#{keyword.id}"
    end
  end

  get '/api/v1/keywords/:word.json' do
    content_type :json, 'charset' => 'utf-8'
    begin
      get_news_keyword(params[:word]).to_json
    rescue
      halt 404
    end  
  end

  get '/api/v1/originalnews' do
    content_type :json, 'charset' => 'utf-8'
    begin
      get_news_author('TNL').to_json
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

  delete '/api/v1/class/:id' do
    classification = Classification.destroy(params[:id])
  end

  post '/api/v1/class' do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    classification = classification_new(req)

    if classification.save
      status 201
      redirect "/api/v1/class/#{classification.id}"
    end
  end

  get '/api/v1/class/:id' do
    content_type :json, charset: 'utf-8'
    logger.info "GET /api/v1/class/#{params[:id]}"
    begin
      @classification = Classification.find(params[:id])
      number = JSON.parse(@classification.number)
      logger.info({ number: number }.to_json)
    rescue
      halt 400
    end
    get_news(number[0].to_s).to_json
  end

end
