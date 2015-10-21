require 'pry-byebug'
require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'

before do
  @db = PG.connect(dbname: 'todo', host: 'localhost')
end

after do 
  @db.close
end


get '/' do
  redirect to('/items')
end

get '/items' do
  sql = "SELECT * FROM items"
  @items = run_sql(sql)

  erb :index
end

get '/items/new' do
  erb :new
end

post '/items' do
  item = params['item']
  details = params['details']
  sql = "INSERT INTO items (item, details) VALUES ('#{item}','#{details}')"
  run_sql(sql)

  redirect to('/items') # or can you get the id of the record created by the insert, and redirect to that?
end

get '/items/:id' do # use this id to select one record from db, show that one record on screen
  erb :show
end

get '/items/:id/edit' do
  erb :edit
end

post '/items/:id' do
  redirect to("/items/#{params[:id]}")
end

post '/items/:id/delete' do
  redirect to('/')
end

def run_sql(sql)
  @db.exec(sql)
end