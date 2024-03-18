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
  if inputs.mouse.button_left
    state.mouse.clicked = :yes
  else
    state.mouse.clicked = :no
  end
end
