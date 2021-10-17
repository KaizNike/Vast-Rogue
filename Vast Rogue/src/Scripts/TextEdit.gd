extends TextEdit

var is_control_held = false

func _input(event):
	if readonly and has_focus():
		if event.is_action_released("control"):
			is_control_held = false
		elif event.is_action_pressed("control"):
			is_control_held = true
		if event.is_action_pressed("zoom"):
			print("yes")
			var font_size = self.get("custom_fonts/font").get_size()
			if font_size > 128:
				font_size = 4
			else:
				font_size += 4
			self.get("custom_fonts/font").set_size(font_size)
			text += ""
		if is_control_held and event.is_action_pressed("zoom_in"):
			var font_size = self.get("custom_fonts/font").get_size()
			if font_size > 124:
				font_size = 128
			else:
				font_size += 4
			self.get("custom_fonts/font").set_size(font_size)
			text += ""
		if is_control_held and event.is_action_pressed("zoom_out"):
			var font_size = self.get("custom_fonts/font").get_size()
			if font_size < 8:
				font_size = 4
			else:
				font_size -= 4
			self.get("custom_fonts/font").set_size(font_size)
			text += ""
#		if event.is_action_pressed("zoom_in"):
#			print("GO!")
#		if event.is_action_pressed("control"):
#			print("Control!")
#		if event.is_action_pressed("control") and event.is_action_pressed("zoom_in"):
#			print("Both!")
