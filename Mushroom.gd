extends KinematicBody2D

onready var area = $Area2D
onready var animation = $AnimatedSprite

func _on_Area2D_body_entered(body):
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			animation.frame = 0
			animation.play("bounce")
			body.velocity.y = -700


func _on_AnimatedSprite_animation_finished():
	animation.stop()
