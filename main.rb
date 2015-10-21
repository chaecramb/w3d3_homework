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
  
  sql = "SELECT id FROM items WHERE item = '#{item}' AND details = '#{details}'"
  id = run_sql(sql).first['id'].to_i

  redirect to("/items/#{id}") 
end

get '/items/:id' do 
  sql = "SELECT * FROM items WHERE id = #{params[:id].to_i}"
  @item = run_sql(sql).first
  erb :show
end

get '/items/:id/edit' do
  sql = "SELECT * FROM items WHERE id = #{params['id'].to_i}"
  @item = run_sql(sql).first
  erb :edit
end

post '/items/:id' do
  id = params['id'].to_i  
  item = params['item']
  details = params['details']
  sql = "UPDATE items SET item='#{item}', details='#{details}' WHERE id='#{id}'"
  run_sql(sql)
  redirect to("/items/#{id}")
end

post '/items/:id/delete' do
  id = params['id'].to_i 
  sql = "DELETE FROM items WHERE id = #{id}"
  run_sql(sql)
  redirect to('/')
end

def run_sql(sql)
  @db.exec(sql)
end