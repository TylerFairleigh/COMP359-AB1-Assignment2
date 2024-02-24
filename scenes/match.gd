extends PanelContainer

func _on_mouse_entered():
	var match_string = self.name
	var match_number = int(match_string.split("_")[1])
	print(MatchController.valid_match_array, match_number)
	if (match_number in MatchController.valid_match_array):
		var hover_highlight = Color("#92ed8e")
		set_modulate(hover_highlight)

func _on_mouse_exited():
	var regular = Color(1,1,1,1)
	set_modulate(regular)

func _on_gui_input(event):
	get_tree().call_group("match_group", "_on_match_pressed")
	var match_string = self.name
	var match_number = int(match_string.split("_")[1])
	if event.is_pressed() and (match_number in MatchController.valid_match_array):
		self.visible = false
		MatchController.match_pressed(match_number)
		MatchController.player_active = true
		MatchController.match_number = match_number
		MatchController.make_range()
