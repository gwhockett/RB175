require "sinatra"
require "sinatra/reloader"
require "tilt/erubi"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index do |line, index|
      "<p> id=paragraph#{index}>#{line}</P>"
    end.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

# Calls the block for each chapter, passing that chapter's number, name, and
# contents.

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name, :number and
# :paragraph keys. The value for :paragraphs will be a hash of paragraph indexes
# and that paragraph's text.

def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
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

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

get '/any/other/path' do
  "Hello World"
end

not_found do
  redirect "/"
end