require "sinatra"
require "sinatra/reloader"
require "tilt/erubi"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i

  @chapter = File.readlines("data/chp#{number}.txt").join
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"


  erb :chapter
end

get "/show/:name" do
  params[:name]
end
