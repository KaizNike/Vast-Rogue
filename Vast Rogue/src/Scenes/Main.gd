extends Node

onready var textEdit = $UI/VBoxContainer/TextEdit

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

var Rooms = [
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
 
var textStore = ""
var textStoreLen = 0
var textStoreIndex = 0

var storyPrompts = [
	"""You awaken in your room. Just another day on this space station... Right?"""
]

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
	textEdit.text = ""
#	print(Rooms[1])
#	print(player.loc)
	var f = randi() % 2 - 1
	print(f)
	var text = storyPrompts[0] + "\n" + healthPrompts[f] + "\n\n" + hintPrompts[0]
	display_text_by_scrolling(text)
#	command_parse("look")

func command_parse(text : String):
	if text == "":
		return
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

func _on_Timer_timeout():
	if textStore:
		if textStoreIndex < textStoreLen:
			textEdit.text += textStore[textStoreIndex]
			textStoreIndex += 1
		else:
			textStoreIndex = 0
			$Timer.stop()
		pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	$UI/VBoxContainer/HSplitContainer/LineEdit.text = ""
	command_parse(new_text)
