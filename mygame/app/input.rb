def input
  # player can use mouse, touch, or also up/down to choose row
  # click, keypress, or touch on a row to send elf
  # determine input now, to be acted on later

  # divide screen into 8 rows
  # leave top and bottom clear
  # 6 middle ones are elf runs

  # determine if the user tapped a row
  # also what row should be highlighted

  state.mouse.x = inputs.mouse.x
  state.mouse.y = inputs.mouse.y

  state.mouse.x = state.mouse.x.cap_min_max(0, 1280).to_i
  state.mouse.y = state.mouse.y.cap_min_max(0, 720).to_i

  # the top and bottom rows are not used as part of the regular gameplay, i.e. if there are 8 rows, then 0 and 7 are not used
  state.player.row = ((state.mouse.y / (720 / state.number_of_rows)).to_i).cap_min_max(0, state.number_of_rows - 1)

  # putz "mouse y: #{state.mouse.y}"
  # putz "playrow: #{state.player.row}"

  if inputs.mouse.button_left
    state.mouse.clicked = :yes
  else
    state.mouse.clicked = :no
  end
end
