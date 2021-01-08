extends Popup


func _on_Button_pressed():
	get_tree().change_scene("res://StartMenu.tscn")

func _on_Button2_pressed():
	self.hide()
	get_tree().paused = false
