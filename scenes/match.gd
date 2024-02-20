extends PanelContainer

func _on_mouse_entered():
	var hover_highlight = Color("#92ed8e")
	set_modulate(hover_highlight)

func _on_mouse_exited():
	var regular = Color(1,1,1,1)
	set_modulate(regular)

func _on_gui_input(event):
	if event.is_pressed():
		self.visible = false
