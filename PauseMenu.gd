extends Popup


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/StartMenu.tscn")
	get_tree().paused = false

func _on_Button2_pressed():
	self.hide()
	get_tree().paused = false
