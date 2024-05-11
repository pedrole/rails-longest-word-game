require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
   @letters = generate_grid(10)

  end

  def score
    letters = params[:letters].split
    word = params[:word]

    if !grid? params[:word], letters
      @result = "Sorry but <b>#{word.upcase}</b> can't be built out of #{letters.join(', ')}".html_safe
    elsif !JSON.parse(URI.open("https://dictionary.lewagon.com/#{word}").read)['found']
      @result = "Sorry but <b>#{word.upcase}</b> does not seem to be a valid English word...".html_safe
    else
      @result = "<b>Congratualation</b> #{word.upcase} is a valid English word!".html_safe
    end
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    # [*'a'..'z'].sample(grid_size)
    letters = [*'A'..'Z']
    grid = []
    grid_size.times do
      grid.push(letters.sample)
    end
    grid
  end

  def grid?(attempt, grid)
    included = true
    attempt.upcase.each_char do |e|
      if grid.include?(e)
        grid.delete_at(grid.index(e))
      else
        included = false
        break
      end
    end
    included
  end
end
