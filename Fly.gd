extends KinematicBody2D

export var health = 1

onready var hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("Idle")

func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox":
		health -= 1
	if health <= 0:
		animationPlayer.play("Die")
		yield(animationPlayer, "animation_finished")
		_on_AnimationPlayer_animation_finished("Die")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
