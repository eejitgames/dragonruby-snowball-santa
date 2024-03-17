def tick_game_over_scene
  outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: 'sprites/snow.png' }
  outputs.labels << { x: 640, y: 360, text: "Game Over Scene (click to go to title)", alignment_enum: 1 }

  if inputs.mouse.click
    state.next_scene = :tick_title_scene
    audio[:music] = nil
  end
end
