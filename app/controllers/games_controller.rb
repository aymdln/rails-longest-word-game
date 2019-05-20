# frozen_string_literal: true
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ('A'..'Z').to_a.sample }
  end

  def check_word_api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_test_serialized = open(url).read
    word_test = JSON.parse(word_test_serialized)
    word_test['found']
  end

  def check_word_grid(attempt, grid)
    array_attempt = attempt.upcase.split('')
    array_attempt.all? { |letter| grid.count(letter) >= array_attempt.count(letter) }
  end

  def score
    if check_word_api(params[:word]) && check_word_grid(params[:word], params[:grid].split(' '))
      @message = "well done"
      score = params[:word].size
      # time = (end_time - start_time) < 10 ? score += 10 : score -= 2
      time = 0
    else
      !check_word_api(params[:word]) ? @message = "not an english word" : @message = "not in the grid"
      score = 0
    end
    { message: @message, score: score, time: time }
  end
end
