extends PanelContainer

# Checks if the match is a valid selection and highlights it green
func _on_mouse_entered():
	var match_pile = int(self.get_parent().name.split(" ")[1]) - 1
	if (match_in_selected_pile(match_pile)):
		var hover_highlight = Color("#92ed8e")
		set_modulate(hover_highlight)

# Sets the match back to the default state
func _on_mouse_exited():
	var regular = Color(1,1,1,1)
	set_modulate(regular)

# Checks if the match pressed is valid from the selected pile
func _on_gui_input(event):
	var match_pile = int(self.get_parent().name.split(" ")[1]) - 1
	if (event.is_pressed()) and (match_in_selected_pile(match_pile)):
		MatchController.match_pressed(match_pile)
		MatchUI.toggle_finish_button(true)
		MatchUI.toggle_restart_button(true)
		self.queue_free()

# Checker function for if the match is in the selected pile
func match_in_selected_pile(match_pile_origin:int) -> bool:
	return (match_pile_origin == MatchController.selected_pile or MatchController.selected_pile == -1)
