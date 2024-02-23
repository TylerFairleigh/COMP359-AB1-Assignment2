extends Label

func _ready():
	label_change()

func label_change():
	if (MatchController.player_turn):
		self.text = "Players Turn"
	else:
		self.text = "Bot Turn"
