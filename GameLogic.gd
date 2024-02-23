extends Node

var pileMin = 3
var pileMax = 3 # Declare a strict maximum
var matchMin = 1
var matchMax = 8
var random = RandomNumberGenerator.new()
var gameArray # Keeps track of the current number of piles and matches per pile, stored in an array
var playerTurn # Keeps track of whose turn it is, player's true if true, opponent's turn otherwise
var ongoingGame = false

# Create a game with a set number of piles and number of matches in each pile
# The maximum values for piles and matches are declared at the top of this file
# Will return an array, where each index corresponds to a pile and its value the number of matches
func _create_game():
	var piles = []
	var numberOfPiles = random.randi_range(pileMin, pileMax)
	#print("Number of piles: " + numberOfPiles)
	#piles = [numberOfPiles]
	for pile in numberOfPiles:
		piles.append(random.randi_range(matchMin, matchMax))
	return piles

func _start_round():
	# Create the corresponding array for the pile and match sizes
	gameArray = _create_game()
	# Randomly choose who goes first
	if randi() % 2:
		playerTurn = true
	else:
		playerTurn = false
	ongoingGame = true

func _ready():
	_start_round()

func _process(_delta):
	if ongoingGame:
		# Clean up array every time a pile is emptied, remove its index from the array
		for pile in range(gameArray.size() - 1, -1, -1): # Iterates the array from end to start to avoid any index range errors
			if gameArray[pile] == 0:
				gameArray.remove_at(pile) # Remove empty piles from array
		# If the array is empty, the game should be over.
		# Whoever is supposed to make the next turn once the last match is removed is the loser.
		if gameArray.is_empty():
			if playerTurn:
				print("You win!")
			else:
				print("You lose!")
			ongoingGame = false
			return
		print("Current game space is " + str(gameArray))
		if playerTurn:
			# the player's turn to take matches))
			print("Player's turn")
			
			# Insert player control here and remove _random_move()
			_player_make_choice(gameArray)
			
			# Remove this function once player chocie is implemented
			_random_move(gameArray)
			
			playerTurn = false
			return
		else:
			# opponent's turn to take matches
			print("Opponent's turn")
			_ai_make_choice(gameArray)
			playerTurn = true
			return

# Function to get the player's choice from the UI
func _player_make_choice(array):
	var pile = -1 # initalize a value the player shouldn't be able to choose
	# Keep prompting player to choose a pile until it's a valid choice
	while pile > 0 or pile < gameArray.size():
		print("Choose a pile.")
		pile =  0 # insert function call to get player's selected pile
		return
	var toRemove = 0 # insert function call which returns number of matches player selected
	array[pile] -= toRemove

func _ai_make_choice(array):
	var nimSum = _get_nim_sum(array)
	# If only one pile is left, in order guarantee a win, the opponent needs to take all matches except the last one
	if array.size() == 1 and array[0] != 1:
		var toRemove = nimSum - 1
		array[0] -= toRemove
		print("Winning move: " + str(toRemove) + " matches removed from pile 1")
		return
	
	for pile in range(array.size()):
		# Get a possible move which will make the nim sum = 0
		var currentSum = nimSum ^ array[pile]
		# If winning move is valid, do winning move (ie. make nim sum = 0)
		if currentSum < array[pile]:
			var toRemove = array[pile] - currentSum
			if toRemove > 0: # Cannot remove 0 matches
				array[pile] -= toRemove
				print("Winning move: " + str(toRemove) + " matches removed from pile " + str(pile + 1))
				return
	# If in losing position, make a random move
	_random_move(array)
	return 

# Get the current nim sum
func _get_nim_sum(array) -> int:
	var nimSum = 0
	# Calculates the nim sum of the current game space by taking the exclusive OR of the sum of piles
	# Using XOR is essentially doing binary addition with no carry
	for pile in array:
		nimSum = pile ^ nimSum # ^ represents bitwise XOR
	return nimSum

# Simply chooses a random pile and chooses a random amount of matches to remove (Cannot remove 0 matches)
func _random_move(array):
	var index = randi() % array.size()
	var remove = randi() % array[index] + 1
	array[index] -= remove
	print(str(remove) + " matches removed from pile " + str(index + 1))
