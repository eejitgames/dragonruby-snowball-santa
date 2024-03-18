require "app/defaults.rb"
require "app/common.rb"

def tick_title_scene
  outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/snow.png" }

  outputs.labels << { x: 640, y: 665, text: "Snowball Santa", size_enum: 50, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 240, g: 10, b: 10 }
  long_string = "Santa's presents are getting scattered all over the North Pole! The polar bears have come out to investigate - you and your team of elves need to help Santa collect the gifts! Santa will throw snowballs to try and keep the bears away, while the elves retrieve what they can!"
  multiline_label(long_string: long_string, max_character_length: 50, label_starting_x: 640, label_starting_y: 534)
  boxed_label(boxed_label: { x: 640, y: 126, text: "Let's help Santa!", size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf",  r: 10, g: 230, b: 10 }, box_color: {r: 240, g: 10, b: 10})

  defaults if state.defaults_set.nil?

  if inputs.mouse.click
    state.next_scene = :tick_game_scene
    state.defaults_set = nil
  end
end
