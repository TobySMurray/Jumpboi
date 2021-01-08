extends Position2D

#func _physics_process(delta):
#	look_at(get_global_mouse_position())
	
onready var attack_pos = $Attack
	

func _on_Area2D_area_entered(area):
	print("in body")
	look_at(area.global_position)
