require 'app/title.rb'
require 'app/game.rb'
require 'app/game_over.rb'
require 'app/game_paused.rb'

include AttrGTK

def tick args
  self.args = args
  state.current_scene ||= :tick_title_scene
  current_scene = state.current_scene

  is_game_paused?
  send(current_scene)

  raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes." if state.current_scene != current_scene

  if state.next_scene
    state.current_scene = state.next_scene
    state.next_scene = nil
  end
end

$gtk.reset
