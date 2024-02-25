extends Label

func _ready():
	label_change()

func label_change():
	if (MatchController.player_turn):
		self.text = "Players Turn"
	else:
		self.text = "Bot Turn"

func label_update(label_update):
	self.text = label_update
