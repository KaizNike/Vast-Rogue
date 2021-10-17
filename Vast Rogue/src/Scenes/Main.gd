extends Node

onready var textEdit = $UI/VBoxContainer/TextEdit

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
	"Type in 'look' to have a peek at surroundings."	
]

var lookPrompts = [
	"You are in your room aboard station Alpha-OOZ."
]

var player = {"loc": Vector2(1,1), "floor": 0, "hp": 0}

func _ready():
	textEdit.text = ""
#	print(Rooms[1])
#	print(player.loc)
	var f = randi() % 2 - 1
	print(f)
	var text = storyPrompts[0] + "\n" + healthPrompts[f] + "\n\n" + hintPrompts[0]
	display_text_by_scrolling(text)
#	command_parse("look")

func command_parse(text):
	if text == "look" or text == "look around":
		var Text = ""
		var Floor = player.floor
		for y in Rooms[Floor]:
			for x in y:
				Text += x
				pass
			Text += "\n"
		Text += "\n"
		Text += lookPrompts[0]
#		print(Text)
		textEdit.text = ""
		textStoreIndex = 0
		display_text_by_scrolling(Text)
		pass
	else:
		print("Command not recognized.")

func display_text_by_scrolling(text):
	textStore = text
	textStoreLen = textStore.length()
	$Timer.start()

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
