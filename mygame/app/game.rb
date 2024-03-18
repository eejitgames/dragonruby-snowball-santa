require "app/input.rb"
require "app/calc.rb"
require "app/render.rb"

def tick_game_scene
  outputs.labels << { x: 640, y: 360, text: "Game Scene (click to go to game over)", alignment_enum: 1 }

  input
  calc
  render

=begin
	DoSanta()
	DoBear()
	DoElves()
	If Snowballs.Length > -1 then DoSnowBalls()
	 	
	If SantaGifts => GiftTarget then SantaWin()
	If BearGifts => GiftTarget then BearWin()
	
    Sync()
	loop
=end

  putz "game_tick_count: #{state.game_tick_count}"

  state.next_scene = :tick_game_over_scene if inputs.mouse.click
end
