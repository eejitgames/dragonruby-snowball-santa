def defaults
  audio[:music] ||= { input: "sounds/mixkit-christmas-gifts-862.ogg", x: 0.0, y: 0.0, z: 0.0, gain: 1.0, pitch: 1.0, paused: false, looping: true, }

  state.game_tick_count = state.tick_count
  state.defaults_set = true
  putz "setting defaults"
end
