extends Area2D

export(String, FILE, "*.tscn") var next_world

onready var timer = $Timer

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			timer.start()
			

func _on_Timer_timeout():
	get_tree().change_scene(next_world)
