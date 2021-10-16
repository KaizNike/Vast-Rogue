extends TextEdit

func _input(event):
	if event.is_action_pressed("zoom") and readonly and has_focus():
		print("yes")
		var font_size = self.get("custom_fonts/font").get_size()
		if font_size > 128:
			font_size = 4
		else:
			font_size += 4
		self.get("custom_fonts/font").set_size(font_size)
		text += ""
