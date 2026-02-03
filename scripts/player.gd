extends CharacterBody2D

@export var projectile:PackedScene
@export var max_length := 200
@export var speed = 400

@onready var animated_sprite :AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown :Timer = $shoot_cooldown

var can_shoot = true

enum playerState {
	IDLE,
	RUN,
	SHOOT,
	RUN_AND_SHOOT
}

var state = playerState.IDLE

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	
	match state:
		playerState.IDLE:
			animated_sprite.play("idle")
		playerState.RUN:
			animated_sprite.play("run")
		playerState.SHOOT:
			animated_sprite.play("shoot")
			can_shoot = false
		playerState.RUN_AND_SHOOT:
			animated_sprite.play("run_and_shoot")
			can_shoot = false


func update_states():
	if state == playerState.SHOOT or state == playerState.RUN_AND_SHOOT:
		return
		
	#if velocity == Vector2.ZERO and animated_sprite.animation != "shoot":
		#change_state(playerState.IDLE)
	#
	#if velocity.length() > 0 and animated_sprite.animation != "shoot":
		#change_state(playerState.RUN)
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		if velocity.length() > 0:
			change_state(playerState.RUN_AND_SHOOT)
		else:
			change_state(playerState.SHOOT)
		return
	
	if velocity == Vector2.ZERO:
		change_state(playerState.IDLE)
	else:
		change_state(playerState.RUN)
			

func movement():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	if input_dir.x != 0:
		animated_sprite.flip_h = input_dir.x < 0


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	movement()
	move_and_slide()
	update_states()
	

func spawn_arrow(vector: Vector2):
	var p = projectile.instantiate()
	get_parent().add_child(p)
	p.global_position = $muzzle.global_position
	p.direction = Vector2.RIGHT
	p.speed = vector.length() * 8
	if vector.length() < 100:
		p.speed = vector.length() * 8
	print(p.speed)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "shoot" or animated_sprite.animation == "run_and_shoot":
		can_shoot = true
		if velocity.length() > 0:
			change_state(playerState.RUN)
		else:
			change_state(playerState.IDLE)
