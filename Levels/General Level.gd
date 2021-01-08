extends Node


onready var pauseMenu = $PauseMenu
onready var playerCamera = $Player/Camera2D

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().paused = true
		pauseMenu.set_global_position(playerCamera.get_camera_position())
		pauseMenu.show()
