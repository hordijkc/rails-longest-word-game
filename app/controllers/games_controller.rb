require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 'a'.upto('z').to_a.sample(9)
  end

  def score
    @letters = params[:letters].split(" ") unless params[:letters].nil?
    @name = params[:name]
    @result = valid
    @result
  end

  def valid_word
    @letters = params[:letters].split("")
    @answer_letters = @answer_letters.split("")
    @answer_letters.all? do |letter|
      @letters.include?(letter)
      if @letters.include?(letter)
        @letters.delete_at(@answer_letters.index(letter))
      end
    end
  end

  def valid
    result = {}
    @answer_letters = params[:name]
    url = "http://wagon-dictionary.herokuapp.com/#{@answer_letters}"
    api_res = JSON.parse(open(url).read)
    valid = valid_word
    if api_res["found"] == false
      result[:message] = "not an english word"
    elsif !valid
      result[:message] = 'not in the grid'
    else
      result[:score] = @answer_letters.length * 2
      result[:message] = "well done #{@answer_letters.join}, is a great word!"
    end
    result[:score] = 0 if result[:message] == "not an english word" || result[:message] == 'not in the grid'
    result
  end
end

