def is_game_paused?
  if !inputs.keyboard.has_focus && state.tick_count != 0
    audio[:music].paused = true unless audio[:music].nil?
  else
    audio[:music].paused = false unless audio[:music].nil?
    state.game_tick_count += 1
  end
end
