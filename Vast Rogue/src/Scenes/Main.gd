extends Node

onready var textEdit = $UI/VBoxContainer/TextEdit
var version = [2, 0, 1, "-alpha"]

var Things = {
	"#": {"collidable": true},
	"D": {"collidable": true},
	"K": {"interactable": true, "collidable": true}
}

var levelMeta = {
	"floor0": {
		"playerRoom": {
			"K": {
				"name": "keypad", 
				"desc": "This keypad in your room controls your door.\nIt recognizes your presence, but will not let you leave without a password."
				}
		}
	}
}

var Rooms = []

# Scen == "Starting"
var RoomsStarting = [
	[
		["#","#","#","#"],
		["#",".","@","$"],
		["#","#","#","#"]
	]
]

var storyPromptsStarting = [
	"It seems you were born not a few days ago upon this ____, place. \nYet to be determined really. \nYou are not yet cognizant of much or will you remember much."
]

# Scen == "SelfSufficient"
var RoomsSelfSufficient = [
	[
		["#","#","K","#", "#", "#"],
		["#", "@", ".", "D", ".", "#"],
		["#", "#", "#", "#", "<", "#"],
		[" ", " ", " ", "#", "#", "#"]
	],
	[
		[" ","#","#","#"," "],
		["#","#","<","#","#"],
		["#"," "," "," ","W"],
		["#","#",">","#","#"],
		[" ","#","#","#"," "]
	],
	[
		["#","#","#","#","#","#"," "," "],
		["#",">","*","D",".","D"," ","%"],
		["#","#","#","#","#","#"," "," "]	
	]
]

var storyPromptsSelfSuff = [
	"""You awaken in your room. Just another day on this space station... Right?"""
]
 
var textStore = ""
var textStoreLen = 0
var textStoreIndex = 0

var scenario = "Starting"

var storyPrompts = []

var healthPrompts = [
	"You feel in perfect health, if that means something to you.",
	"You feel slightly sickly.",
	"You are bleeding slightly."
]

var hintPrompts = [
	"Type in 'look' to have a peek at surroundings.\nSpelling is important!"	
]

var lookPrompts = [
	"You are in your room aboard station Alpha-OOZ."
]

var player = {"loc": Vector2(1,1), "floor": 0, "currentRoom": "playerRoom", "hp": 0}

func _ready():
	randomize()
	textEdit.text = ""
	match scenario:
		"Starting":
			Rooms = RoomsStarting.duplicate(true)
			storyPrompts = storyPromptsStarting.duplicate(true)
#	print(Rooms[1])
#	print(player.loc)
	var f = randi() % 2
	print(f)
	var text = storyPrompts[0] + "\n" + healthPrompts[f] + "\n\n" + hintPrompts[0]
	display_text_by_scrolling(text)
#	command_parse("look")

# Takes string from line edit text entered and tries to perform the desired command
func command_parse(text : String):
	if text == "":
		return
#	split the text to find subqueries
	var parse : PoolStringArray = text.split(" ")
	if text == "look" or text == "look around":
		var printText= ""
		var Floor = player.floor
		for y in Rooms[Floor]:
			for x in y:
				printText+= x
				pass
			printText+= "\n"
		printText+= "\n"
		printText+= lookPrompts[0]
#		print(Text)
		textEdit.text = ""
		display_text_by_scrolling(printText)
		pass
	elif text == "version":
		display_text_by_scrolling("\nV " + str(version[0]) + "." + str(version[1]) + "." + str(version[2]) + version[3])
	elif text == "quit":
		get_tree().quit(1)
	elif parse.size() == 3:
		if parse[0] == "look" and parse[1] == "at":
			if parse[2] == "keypad":
				if player.floor == 0 and player.currentRoom == "playerRoom":
					var printText = "\n"
					var get = levelMeta["floor0"]["playerRoom"]["K"]["desc"]
					printText += get
					display_text_by_scrolling(printText)
				else:
					var printText = "\nThe keypad is too far to look at."
					display_text_by_scrolling(printText)
				pass
			else:
				var printText = "\nYou couldn't find what you were looking for..."
				display_text_by_scrolling(printText)
		else:
			print("Long command not recognized.")
			display_text_by_scrolling("\nLong command not recognized.")
	else:
		print("Command not recognized.")
		display_text_by_scrolling("\nCommand not recognized.")

func display_text_by_scrolling(text):
	textStoreIndex = 0
	textStore = text
	textStoreLen = textStore.length()
	$Timer.start()
	
func move_player(dir):
	pass
	
func check_interact(dir) -> bool:
	return false

func check_collision(dir, special) -> bool:
	return false
	
func process_turn():
	pass

func switch_green(Bool: bool):
	if Bool:
		$UI/VBoxContainer/HSplitContainer/Button.modulate = ColorN("green", 1)
	else:
		$UI/VBoxContainer/HSplitContainer/Button.modulate = ColorN("white", 1)

func _on_Timer_timeout():
	if textStore:
		if textStoreIndex < textStoreLen:
			textEdit.text += textStore[textStoreIndex]
			textStoreIndex += 1
		else:
			textStoreIndex = 0
			$Timer.stop()
		pass # Replace with function body.


# Done after pressing enter or button.
func _on_LineEdit_text_entered(new_text):
	$UI/VBoxContainer/HSplitContainer/LineEdit.text = ""
	switch_green(false)
	command_parse(new_text)


# To be updated after command parse is.
# Update the screen sometimes after text is entered
func _on_LineEdit_text_changed(new_text):
	var parse : PoolStringArray = new_text.split(" ")
	var size = parse.size()
	if new_text == "look" or new_text == "look around":
		switch_green(true)
		pass
	elif new_text == "version":
		switch_green(true)
	elif new_text == "quit":
		switch_green(true)
	elif parse[0] == "look" and parse[1] == "at" and size == 3: 
		if parse[2] == "keypad":
			switch_green(true)
			pass
		else:
			switch_green(false)
	else:
		switch_green(false)


# When ==> pressed, doubles as enter
func _on_Button_pressed():
	_on_LineEdit_text_entered($UI/VBoxContainer/HSplitContainer/LineEdit.text)
#	switch_green(false)
