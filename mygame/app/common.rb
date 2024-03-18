def multiline_label(long_string:, max_character_length:, label_starting_x:, label_starting_y:)
  long_strings_split = String.wrapped_lines long_string, max_character_length # no AttrGTK shortcut, can use the class method with . or String::wrapped_lines
  outputs.labels << long_strings_split.map_with_index do |s, i|
    { x: label_starting_x, y: label_starting_y - (i * 60), text: s, size_enum: 25, alignment_enum: 1, font: "fonts/MountainsofChristmas-Bold.ttf", r: 10, g: 230, b: 10 }
  end
end

def boxed_label(boxed_label:, box_color:)
  outputs.labels << boxed_label

  s = (boxed_label.size_enum || 0)
  f = (boxed_label.font      || "font.ttf")
  w, h = gtk.calcstringbox(boxed_label.text, s, f)
  w += s
  h += s

  ae  = (boxed_label.alignment_enum          || 0)
  vae = (boxed_label.vertical_alignment_enum || 2)
  x = boxed_label.x - [0, w/2, w].fetch(ae)
  y = boxed_label.y - [0, h/2, h].fetch(vae) + s/2 # if s is 0, this gives 0.0

  outputs.borders << { x: x, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x + 1, y: y, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
  outputs.borders << { x: x + 1, y: y - 1, w: w, h: h, r: box_color.r, g: box_color.g, b: box_color.b, a: 255 }
end
