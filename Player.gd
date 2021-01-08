extends KinematicBody2D

const UP = Vector2(0, -1)

export var move_speed = 3
export var deadzone = 25

var velocity = Vector2()
var gravity = 800
var jump_velocity = 300

var max_jumps = 2
var jumps = 2

var level_finished = false
var spawn = true

onready var anim_player = $AnimationPlayer
onready var attack_pos = $AttackPosition
onready var attack_anim = $AttackPosition/Attack
onready var hitbox = $AttackPosition/Hitbox/CollisionShape2D
onready var body = $CollisionShape2D
onready var jumpAudio = $Jump
onready var hitAudio = $Hit


func _physics_process(delta):
	if spawn:
		move_speed = 0
		anim_player.play("Spawn")
		yield(anim_player, "animation_finished")
		spawn = false
		move_speed = 3
	
	if level_finished:
		anim_player.play("Finish")
		yield(anim_player, "animation_finished")
		self.hide()
		body.set_deferred("disabled", true)
		move_speed = 0
		gravity = 0
		
	if is_on_floor():
		jumps = max_jumps
		
	move()
	animate()
	attack()
	
	velocity.y += gravity * delta
	

	if get_global_mouse_position() > self.global_position:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
	velocity = move_and_slide(velocity, UP)
	
	if Input.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	
func move():
	var move_direction = (get_global_mouse_position() - position)
	velocity.x = lerp(velocity.x, move_speed * move_direction.x, 0.9)
	
	if abs(move_direction.x) < deadzone:
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump"):
		if jumps > 0 :
			jump_at_mouse()
			jumps -= 1
			

func jump_at_mouse():
	#var direction = (get_global_mouse_position() - self.global_position).normalized()
	velocity.y -= jump_velocity
	if jumps == 1:
		velocity.y = 0
		velocity.y -= jump_velocity
	#if direction.y > -0.35:
	#	velocity.y -= 200
	jumpAudio.play()
	
	
func attack():
	if Input.is_action_just_pressed("attack"):
		attack_anim.show()
		attack_anim.frame = 0
		anim_player.play("Attack")
		hitAudio.play()
		hitbox.set_deferred("disabled", false)
		attack_anim.playing = true
		
		
func animate():
	
	if velocity.x != 0 && is_on_floor():
		anim_player.play("Run")
	elif velocity.x == 0 && is_on_floor():
		anim_player.play("Idle")
	elif velocity.y < 0:
		anim_player.play("Jump")
	else:
		anim_player.play("Fall")
	

func _on_Attack_animation_finished():
	hitbox.set_deferred("disabled", true)
	attack_anim.hide()

func _on_Hitbox_area_entered(_area):
	jumps = max_jumps

func _on_NextLevel_body_entered(body):
	if body.name == "Player":
		level_finished = true
