extends Node

var pileMax = 3 # Declare a strict maximum
var matchMax = 10
var random = RandomNumberGenerator.new()
var gameArray # Keeps track of the current number of piles and matches per pile, stored in an array
var currentTurn # Keeps track of whose turn it is, player if 0, opponent otherwise
var ongoingGame = false

# Create a game with a set number of piles and number of matches in each pile
# The maximum values for piles and matches are declared at the top of this file
# Will return an array, where each index corresponds to a pile and its value the number of matches
func _create_game():
	var piles = []
	var numberOfPiles = random.randi_range(1, pileMax)
	#print("Number of piles: " + numberOfPiles)
	#piles = [numberOfPiles]
	for pile in numberOfPiles:
		piles.append(random.randi_range(3, matchMax))
	return piles

func _start_round():
	# Create the corresponding array for the pile and match sizes
	gameArray = _create_game()
	# Randomly choose who goes first
	currentTurn = random.randi_range(0, 1)
	ongoingGame = true

func _ready():
	_start_round()

func _process(_delta):
	if ongoingGame:
		# If the array is empty, the game should be over.
		# Whoever is supposed to make the next turn once the last match is removed is the loser.
		# Clean up array every time a pile is emptied, remove its index from the array
		
		for pile in range(gameArray.size() - 1, -1, -1):
			if gameArray[pile] == 0:
				gameArray.remove_at(pile)
		if gameArray.is_empty():
			if currentTurn == 0:
				print("You win!")
			else:
				print("You lose!")
			ongoingGame = false
			return
		print("Current game space is " + str(gameArray))
		if currentTurn == 0:
			# the player's turn to take matches))
			print("Player's turn")
			_random_move(gameArray)
			currentTurn = 1
			return
		else:
			# opponent's turn to take matches
			print("Opponent's turn")
			_ai_make_choice(gameArray)
			currentTurn = 0
			return

func _ai_make_choice(array):
	var nimSum = _get_nim_sum(array)
	
	# If only one pile is left, in order guarantee a win, the opponent needs to take all matches except the last one
	if array.size() == 1 and array[0] != 1:
		var toRemove = nimSum - 1
		array[0] -= toRemove
		print("Winning move: " + str(toRemove) + " matches removed from pile 1")
		return
	
	# If the opponent is in the losing position, make a random move
	if nimSum == 0:
		_random_move(array)
		return
	
	for pile in range(array.size()):
		# Get a possible move which will make the nim sum = 0
		var currentSum = nimSum ^ array[pile]
		# If winning move is valid, do winning move (ie. make nim sum = 0)
		if currentSum < array[pile]:
			var toRemove = array[pile] - currentSum
			if toRemove > 0:
				array[pile] -= toRemove
				print("Winning move: " + str(toRemove) + " matches removed from pile " + str(pile + 1))
				return
	# If in losing position, make a random move
	_random_move(array)
	return 

func _get_nim_sum(array) -> int:
	var nimSum = 0
	# Calculates the nim sum of the current game space
	for pile in array:
		nimSum = pile ^ nimSum # ^ represents bitwise XOR
	return nimSum

# Simply chooses a random pile and chooses a random amount of matches to remove (Cannot remove 0 matches)
func _random_move(array):
	var index = randi() % array.size()
	var remove = randi() % array[index] + 1
	array[index] -= remove
	print(str(remove) + " matches removed from pile " + str(index + 1))
