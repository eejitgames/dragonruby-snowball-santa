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

  outputs.primitives << { x: 640, y: 665, text: "Snowball Santa", size_enum: 50, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 187, g: 1, b: 11, primitive_marker: :label }
  long_string = "Santa's presents are getting scattered all over the North Pole! The polar bears have come out to investigate - you and your team of elves need to help Santa collect the gifts! Santa will throw snowballs to try and keep the bears away, while the elves retrieve what they can!"
  draw_multiline_label(long_string: long_string, max_character_length: 50, label_x: 640, label_y: 537, label_color: {r: 0, g: 92, b: 0})
  draw_boxed_label(boxed_label: { x: 640, y: 126, text: "Let's help Santa!", size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 0, g: 92, b: 0, primitive_marker: :label }, box_color: {r: 187, g: 1, b: 11})

  defaults if state.defaults_set.nil?
  game_is_paused?

  if inputs.mouse.click
    state.next_scene = :tick_game_scene
    state.defaults_set = nil
  end
end

def tick_game_scene
  # outputs.primitives << { x: 640, y: 360, text: "Game Scene (click to go to game over)", alignment_enum: 1, primitive_marker: :label }

  game_is_paused?
  if state.game.paused == :no
    game_input
    game_calc
  end
  game_render

  state.next_scene = :tick_game_over_scene if inputs.mouse.click && state.player.row_mouse == 0
end

def tick_game_over_scene
  draw_background_snow
  outputs.primitives << { x: 640, y: 360, text: "Game Over Scene (click to go to title)", alignment_enum: 1, primitive_marker: :label }

  game_is_paused?

  if inputs.mouse.click
    state.next_scene = :tick_title_scene
    audio[:music] = nil
  end
end

def game_is_paused?
  if !inputs.keyboard.has_focus && state.tick_count != 0
    audio[:music].paused = true if audio[:music].paused == false
    state.game.paused = :yes
  else
    audio[:music].paused = false if audio[:music].paused == true
    state.game_tick_count += 1
    state.game.paused = :no
  end
end

def game_input
  state.mouse.x = inputs.mouse.x
  state.mouse.y = inputs.mouse.y
  state.mouse.x = state.mouse.x.cap_min_max(0, 1280).to_i
  state.mouse.y = state.mouse.y.cap_min_max(0, 720).to_i

  # the top and bottom rows are not used as part of the regular gameplay, i.e. if there are 8 rows, then 0 and 7 are not used
  # also subtract one from the max, as a row can be found in the window title
  state.player.row_mouse = ((state.mouse.y / state.player.row_height).to_i).cap_min_max(0, state.number_of_rows - 1)
  # in normal play, the top and bottom rows do not highlight. if there are 8 rows, rows 1 through 6 may highlight
  state.player.row_highlight = (state.player.row_mouse.cap_min_max(1, state.number_of_rows - 2) * state.player.row_height)

  if inputs.mouse.button_left
    state.mouse.clicked = :yes
  else
    state.mouse.clicked = :no
  end
end

def game_calc
=begin
	DoSanta()
	DoBear()
	DoElves()
	If Snowballs.Length > -1 then DoSnowBalls()

	If SantaGifts => GiftTarget then SantaWin()
	If BearGifts => GiftTarget then BearWin()

    Sync()
	loop

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

Function DoBear()
	If NextBear# <= Timer()
		AddBear()
		NextBear# = Timer() + BearCool#
	EndIf

	If Bear.Length > -1
		For x = Bear.Length to 0 Step -1
			ThisBear = Bear[x].ID
			BearX# = GetSpriteXByOffset(ThisBear)
			If Bear[x].State$ = "running"
				If BearX# <= 4*Tilesize#
					Bear[x].State$ = "returning"
					PlaySprite(ThisBear, 10,1,7,9)
				Else
					ThisX# = BearX# - (Bear[x].Speed#*GetFrameTime())
					SetSpritePositionByOffset(ThisBear, ThisX#, GetSpriteYByOffset(ThisBear) )
					For ThisGift = 0 to Gifts.Length
						If GetSpriteCollision(ThisBear, Gifts[ThisGift]) = 1
							SetSpriteGroup(Gifts[ThisGift], BearGroup)
							Bear[x].GiftID = Gifts[ThisGift]
							Gifts.Remove(ThisGift)
							Bear[x].State$ = "returning"
							Bear[x].Speed# = Bear[x].Speed# * 2.0  // Bear[y].Speed# = 200.0 // Speed# = Speed# * 1.5 and Speed# = Speed# * 2.0
							PlaySprite(ThisBear, 10,1,7,9)
							Exit
						EndIf
					Next ThisGift
				EndIf
			EndIf

			If Bear[x].State$ = "returning"
				If BearX# > 640.0
					If Bear[x].GiftID > 0
						INC BearGifts
						SetTextString(BearTXT, "Bear" + CHR(10) + STR(BearGifts) )
						PlaySound(BellBearSND)
						DeleteSprite(Bear[x].GiftID)
						AddGift()

					EndIf
					DeleteSprite(ThisBear)
					Bear.Remove(x)
					AddBear()
				Else
					ThisX# = BearX# + (Bear[x].Speed#*GetFrameTime())
					SetSpritePositionByOffset(ThisBear, ThisX#, GetSpriteYByOffset(ThisBear) )
					If Bear[x].GiftID > 0
						SetSpritePositionByOffset(Bear[x].GiftID, ThisX# + 20, GetSpriteYByOffset(ThisBear)+4)
					EndIf
				EndIf
			EndIf
		Next x

	EndIf
EndFunction

Function DoElves()
	For x = Elves.Length to 0 Step -1
		If Elves[x].State$ = "running"
			ThisElf = Elves[x].ID
			ElfX# = GetSpriteXByOffset(ThisElf)
			TargetX# = 600.0
			Move# = Elves[x].Speed#*GetFrameTime()

			For ThisGift = Gifts.Length to 0 Step -1
				If GetSpriteCollision(ThisElf, Gifts[ThisGift]) = 1
					Elves[x].GiftID = Gifts[ThisGift]
					Gifts.Remove(ThisGift)
					Elves[x].State$ = "returning"
					PlaySprite(ThisElf,20,1,4,6)
					Exit
				EndIf
			Next ThisGift

			If Bear.Length > -1
				For ThisBear = Bear.Length to 0 Step -1
					If GetSpriteExists(Bear[ThisBear].ID) = 1
						If GetSpriteCollision(ThisElf, Bear[ThisBear].ID) = 1
							Elves[x].State$ = "returning"
							Bear[ThisBear].Speed# = Bear[ThisBear].Speed# * 1.5
							PlaySprite(ThisElf,20,1,4,6)
							Exit
						EndIf
					EndIf
				Next ThisBear
			EndIf

			If ABS(ElfX#-TargetX#) <= Move#
				Elves[x].State$ = "returning"
				PlaySprite(ThisElf,20,1,4,6)
			Else
				SetSpritePositionByOffset(ThisElf, ElfX# + Move#, GetSpriteYByOffset(ThisElf))
			EndIf
		EndIf

		If Elves[x].State$ = "returning"
			ThisElf = Elves[x].ID
			ElfX# = GetSpriteXByOffset(ThisElf)
			TargetX# = Elves[x].X
			Move# = Elves[x].Speed#*GetFrameTime()

			If ABS(ElfX#-TargetX#) <= Move#
				Elves[x].State$ = "ready"
				If Elves[x].GiftID > 0
					INC SantaGifts
					SetTextString(SantaTXT, "Santa" + CHR(10) + STR(SantaGifts) )
					PlaySound(BellSND)
					`GiftIndex = Gifts.Find(Elves[x].GiftID)
					// Gifts.Remove(GiftIndex)
					DeleteSprite(Elves[x].GiftID)
					Elves[x].GiftID = 0
					AddGift()
				EndIf

				StopSprite(ThisElf)
				SetSpriteFrame(ThisElf,7)

			Else
				SetSpritePositionByOffset(ThisElf, ElfX# - Move#, GetSpriteYByOffset(ThisElf))
				If Elves[x].GiftID > 0
					GX# = GetSpriteXByOffset(ThisElf) - 10
					GY# = GetSpriteYByOffset(ThisElf)
					SetSpritePositionByOffset(Elves[x].GiftID, GX#, GY#)
				EndIf
			EndIf
		EndIf

	Next x

EndFunction

=end
end

def game_render
  draw_background_snow
  draw_game_info
  draw_snowball_shadows
  draw_presents
  draw_elves
  draw_bears
  draw_santa
  draw_snowballs
  draw_row_highlight
end

def draw_background_snow
  outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/snow.png", primitive_marker: :sprite }
end

def draw_game_info
end

def draw_snowball_shadows
end

def draw_presents
end

def draw_elves
end

def draw_bears
end

def draw_santa
end

def draw_snowballs
end

def draw_row_highlight
  outputs.primitives << { x: 200, y: state.player.row_highlight, w: 1000, h: state.player.row_height, r: 176, g: 224, b: 230, a: 30, primitive_marker: :solid } # Powder Blue
end

def draw_multiline_label(long_string:, max_character_length:, label_x:, label_y:, label_color:)
  long_strings_split = String.wrapped_lines long_string, max_character_length # no AttrGTK shortcut, can use the class method with . or String::wrapped_lines
  outputs.primitives << long_strings_split.map_with_index do |s, i|
    { x: label_x, y: label_y - (i * 60), text: s, size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf", r: label_color.r, g: label_color.g, b: label_color.b, a: 255, primitive_marker: :label }
  end
end

def draw_boxed_label(boxed_label:, box_color:)
  outputs.primitives << boxed_label

  s = (boxed_label.size_enum || 0)
  w, h = gtk.calcstringbox(boxed_label.text, s, boxed_label.font).map { |e| e + s }

  ae  = (boxed_label.alignment_enum          || 0)
  vae = (boxed_label.vertical_alignment_enum || 2)
  x = boxed_label.x - [0, w/2, w].fetch(ae)
  y = boxed_label.y - [0, h/2, h].fetch(vae) + s/2

  outputs.primitives << { x: x, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255, primitive_marker: :border }
  outputs.primitives << { x: x + 1, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255, primitive_marker: :border }
  outputs.primitives << { x: x, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255, primitive_marker: :border }
  outputs.primitives << { x: x + 1, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255, primitive_marker: :border }
end

def defaults
  audio[:music] ||= { input: "sounds/mixkit-christmas-gifts-862.ogg", x: 0.0, y: 0.0, z: 0.0, gain: 1.0, pitch: 1.0, paused: false, looping: true, }

  state.game_tick_count = state.tick_count
  state.number_of_rows = 8
  state.player.row_height = (720 / state.number_of_rows).to_i
  state.player.row_mouse = 0
  state.defaults_set = true
end

$gtk.reset
