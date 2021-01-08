extends Area2D


onready var sprite = $Sprite
onready var animatedSprite = $AnimatedSprite
onready var audio = $AudioStreamPlayer2D

func _on_Coin_body_entered(body):
	sprite.hide()
	animatedSprite.show()
	animatedSprite.play("Pickup")
	audio.play()
	yield(animatedSprite, "animation_finished")
	
func _on_AnimatedSprite_animation_finished():
	queue_free()
