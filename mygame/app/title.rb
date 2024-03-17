require 'app/defaults.rb'

def tick_title_scene
  outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: 'sprites/snow.png' }

  long_string = "Santa's presents are getting scattered all over the North Pole! The polar bears have come out to investigate - you and your team of elves need to help Santa collect the gifts! Santa will throw snowballs to try and keep the bears away, while the elves retrieve what they can!"
  max_character_length = 50
  long_strings_split = String.wrapped_lines long_string, max_character_length # no AttrGTK shortcut, can use the class method with . or String::wrapped_lines

  outputs.labels << { x: 640, y: 665, text: "Snowball Santa", size_enum: 50, alignment_enum: 1, font: 'fonts/MountainsofChristmas-Bold.ttf',  r: 240, g: 10, b: 10 }
  outputs.labels << long_strings_split.map_with_index do |s, i|
    { x: 640, y: 525 - (i * 60), text: s, size_enum: 25, alignment_enum: 1, font: 'fonts/MountainsofChristmas-Bold.ttf', r: 10, g: 230, b: 10 }
  end

  outputs.labels << { x: 640, y: 125, text: "Let's go!", size_enum: 25, alignment_enum: 1, font: 'fonts/MountainsofChristmas-Bold.ttf',  r: 10, g: 230, b: 10 }
  outputs.borders << { x: 545, y: 39, w: 190, h: 100, r: 240, g: 10, b: 10 }
  outputs.borders << { x: 544, y: 39, w: 190, h: 100, r: 240, g: 10, b: 10 }
  outputs.borders << { x: 545, y: 38, w: 190, h: 100, r: 240, g: 10, b: 10 }
  outputs.borders << { x: 544, y: 38, w: 190, h: 100, r: 240, g: 10, b: 10 }

  defaults if state.defaults_set.nil?

  if inputs.mouse.click
    state.next_scene = :tick_game_scene
    state.defaults_set = nil
  end
end
