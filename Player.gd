extends KinematicBody2D

const UP = Vector2(0, -1)
const TILESIZE = 16

var velocity = Vector2()
var move_speed = 3
var deadzone = 20

var gravity
var fall_gravity
var attack_gravity
var max_jump_velocity
var min_jump_velocity
var max_jump_height = 3.2 * TILESIZE
var min_jump_height= 0.8 * TILESIZE
var jump_duration = 0.3
var fall_duration = 0.325
var attack_velocity = 0.01 * TILESIZE
var attack_duration = 0.1

var max_horiz_speed = 225

var max_jumps = 2
var jumps = 2

var level_finished = false
var spawn = true
var is_attacking = false
var can_attack = true

onready var anim_player = $AnimationPlayer
onready var attack_anim = $Attack
onready var hitbox = $Hitbox/CollisionShape2D
onready var body = $CollisionShape2D
onready var jumpAudio = $Jump
onready var hitAudio = $Hit
onready var attackTimer = $AttackTimer

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	fall_gravity = 2 * max_jump_height / pow(fall_duration, 2)
	attack_gravity = 2 * attack_velocity / pow(attack_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta):
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
	get_input()
	
	if is_attacking:
		velocity.y += attack_gravity * delta
	elif velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * delta
		velocity.y = lerp(velocity.y, fall_gravity * delta, 0.05)
		
	velocity = move_and_slide(velocity, UP)
	
	animate()
	
	if Input.is_action_pressed("reload"):
		get_tree().reload_current_scene()
		
	
func move():
	var move_direction = (get_global_mouse_position() - position)
	velocity.x = lerp(velocity.x, move_speed * move_direction.x, 0.5)
	if velocity.x >= 0:
		velocity.x = min(velocity.x, max_horiz_speed)
	else:
		velocity.x = max(velocity.x, -max_horiz_speed)
	
	if abs(move_direction.x) < deadzone:
		velocity.x = 0
	
	
func get_input():
	if Input.is_action_just_pressed("jump"):
		if jumps > 0 :
			jump()
			jumps -= 1
	
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
		
	if Input.is_action_just_pressed("attack"):
		if !is_on_floor() and can_attack:
			attack()

func jump():
	velocity.y = max_jump_velocity
	if !is_on_floor():
		velocity.y = 0
		velocity.y = max_jump_velocity
	jumpAudio.play()
	
	
func attack():
		is_attacking = true
		attackTimer.start()
		can_attack = false
		attack_anim.show()
		attack_anim.frame = 0
		anim_player.play("Attack")
		hitAudio.play()
		velocity.y -= attack_velocity 
		hitbox.set_deferred("disabled", false)
		attack_anim.playing = true
		
		
func animate():
	if get_global_mouse_position() > self.global_position:
		$Sprite.flip_h = false
		attack_anim.flip_h = false
	else:
		$Sprite.flip_h = true
		attack_anim.flip_h = true
	if spawn:
		anim_player.play("Spawn")
		move_speed = 0
	elif is_attacking:
		anim_player.play("Attack")
	elif velocity.x != 0 && is_on_floor():
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
	jumps += 1

func _on_NextLevel_body_entered(body):
	if body.name == "Player":
		level_finished = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		spawn = false
		move_speed = 3
	if anim_name == "Attack":
		is_attacking = false



func _on_AttackTimer_timeout():
	can_attack = true
