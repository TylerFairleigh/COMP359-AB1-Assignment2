extends PanelContainer

func _on_mouse_entered():
	var match_pile = int(self.get_parent().name.split(" ")[1]) - 1
	if (match_in_selected_pile(match_pile)):
		var hover_highlight = Color("#92ed8e")
		set_modulate(hover_highlight)

func _on_mouse_exited():
	var regular = Color(1,1,1,1)
	set_modulate(regular)

func _on_gui_input(event):
	var match_pile = int(self.get_parent().name.split(" ")[1]) - 1
	if (event.is_pressed()) and (match_in_selected_pile(match_pile)):
		self.visible = false
		MatchController.match_pressed(match_pile)

func match_in_selected_pile(match_pile_origin:int) -> bool:
	return (match_pile_origin == MatchController.selected_pile or MatchController.selected_pile == -1)
