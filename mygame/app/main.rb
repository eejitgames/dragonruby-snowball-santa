include AttrGTK

def tick args
  self.args = args
  state.current_scene ||= :tick_title_scene
  current_scene = state.current_scene

  send(current_scene)

  raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes." if state.current_scene != current_scene

  if state.next_scene
    state.current_scene = state.next_scene
    state.next_scene = nil
  end
end

def tick_title_scene
  draw_background_snow

  outputs.labels << { x: 640, y: 665, text: "Snowball Santa", size_enum: 50, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 187, g: 1, b: 11 }
  long_string = "Santa's presents are getting scattered all over the North Pole! The polar bears have come out to investigate - you and your team of elves need to help Santa collect the gifts! Santa will throw snowballs to try and keep the bears away, while the elves retrieve what they can!"
  draw_multiline_label(long_string: long_string, max_character_length: 50, label_starting_x: 640, label_starting_y: 537, label_color: {r: 0, g: 92, b: 0})
  draw_boxed_label(boxed_label: { x: 640, y: 126, text: "Let's help Santa!", size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 0, g: 92, b: 0 }, box_color: {r: 187, g: 1, b: 11})

  defaults if state.defaults_set.nil?
  game_is_paused?

  if inputs.mouse.click
    state.next_scene = :tick_game_scene
    state.defaults_set = nil
  end
end

def tick_game_scene
  outputs.labels << { x: 640, y: 360, text: "Game Scene (click to go to game over)", alignment_enum: 1 }

  game_is_paused?
  game_input
  game_calc
  game_render

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

  state.next_scene = :tick_game_over_scene if inputs.mouse.click && state.player.row == 0
end

def tick_game_over_scene
  draw_background_snow
  outputs.labels << { x: 640, y: 360, text: "Game Over Scene (click to go to title)", alignment_enum: 1 }

  game_is_paused?

  if inputs.mouse.click
    state.next_scene = :tick_title_scene
    audio[:music] = nil
  end
end

def game_is_paused?
  if !inputs.keyboard.has_focus && state.tick_count != 0
    audio[:music].paused = true unless audio[:music].nil?
  else
    audio[:music].paused = false unless audio[:music].nil?
    state.game_tick_count += 1
  end
end

def game_input
  state.mouse.x = inputs.mouse.x
  state.mouse.y = inputs.mouse.y
  state.mouse.x = state.mouse.x.cap_min_max(0, 1280).to_i
  state.mouse.y = state.mouse.y.cap_min_max(0, 720).to_i

  # the top and bottom rows are not used as part of the regular gameplay, i.e. if there are 8 rows, then 0 and 7 are not used
  state.player.row = ((state.mouse.y / (720 / state.number_of_rows)).to_i).cap_min_max(0, state.number_of_rows - 1)

  if inputs.mouse.button_left
    state.mouse.clicked = :yes
  else
    state.mouse.clicked = :no
  end
end

def game_calc
=begin
Function DoSanta()
	State$ = SantaSPR.State$

	RowY = FLOOR ((MY#-(TileSize#/2))/TileSize#) + 1
	If RowY < 1 then RowY = 1	:	If RowY > 6 then RowY = 6
	SetSpriteY(RowSPR, (RowY*TileSize#)-22)
	If LMBPressed and Elves[RowY].State$ = "ready" then MoveElf(RowY)

	If State$ = "ready"
		If SantaSPR.NextAction# <= Timer()
			SantaBot()
		EndIf
	EndIf

	If State$ = "running"
		SantaY# = GetSpriteYByOffset(SantaSPR.ID)
		TargetY# = SantaSPR.Y*TileSize#
		Move# = SantaSPR.Speed#*GetFrameTime()
		If ABS(SantaY#-TargetY#) > 10.0
			If TargetY# < SantaY# then DIR = -1 Else DIR = 1
			ThisY# = DIR * Move# // ThisY# = DIR*(SantaSPR.Speed#*GetFrameTime())
			SetSpritePositionByOffset(SantaSPR.ID, GetSpriteXByOffset(SantaSPR.ID), SantaY# + ThisY#)
		Else
			SetSpritePositionByOffset(SantaSPR.ID, GetSpriteXByOffset(SantaSPR.ID), TargetY# )
			StopSprite(SantaSPR.ID)
			SetSpriteFrame(SantaSPR.ID,1)
			SantaSPR.State$ = "ready"
		EndIf
	EndIf

	If State$ = "shooting"
		If GetSpritePlaying(SantaSPR.ID) = 0
			AddSnowBall()
			SetSpriteFrame(SantaSPR.ID,1)
			SantaSPR.State$ = "ready"
		EndIf
	EndIf
EndFunction
=end
end

def game_render
  draw_background_snow
end

def draw_multiline_label(long_string:, max_character_length:, label_starting_x:, label_starting_y:, label_color:)
  long_strings_split = String.wrapped_lines long_string, max_character_length # no AttrGTK shortcut, can use the class method with . or String::wrapped_lines
  outputs.labels << long_strings_split.map_with_index do |s, i|
    { x: label_starting_x, y: label_starting_y - (i * 60), text: s, size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf", r: label_color.r, g: label_color.g, b: label_color.b, a: 255 }
  end
end

def draw_boxed_label(boxed_label:, box_color:)
  outputs.labels << boxed_label

  s = (boxed_label.size_enum || 0)
  w, h = gtk.calcstringbox(boxed_label.text, s, boxed_label.font).map { |e| e + s }

  ae  = (boxed_label.alignment_enum          || 0)
  vae = (boxed_label.vertical_alignment_enum || 2)
  x = boxed_label.x - [0, w/2, w].fetch(ae)
  y = boxed_label.y - [0, h/2, h].fetch(vae) + s/2

  outputs.borders << { x: x, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x + 1, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x + 1, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
end

def draw_background_snow
  outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/snow.png" }
end

def defaults
  audio[:music] ||= { input: "sounds/mixkit-christmas-gifts-862.ogg", x: 0.0, y: 0.0, z: 0.0, gain: 1.0, pitch: 1.0, paused: false, looping: true, }

  state.game_tick_count = state.tick_count
  state.number_of_rows = 8
  state.player.row = 0
  state.defaults_set = true
end

$gtk.reset
