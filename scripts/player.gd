extends CharacterBody2D

@export var projectile:PackedScene
@export var max_length := 200
@export var speed = 400
@export var power :float = 2.0

@onready var body_sprite :AnimatedSprite2D = $body
@onready var hands_sprite :AnimatedSprite2D = $hand_pivot/hands
@onready var hands_pivot :Node2D = $hand_pivot
@onready var muzzle :Node2D = $hand_pivot/muzzle
@onready var cooldown_timer:Timer = $cooldown_timer
@onready var draw_sound :AudioStreamPlayer2D = $draw
@onready var release_sound :AudioStreamPlayer2D = $release


var can_shoot = true
var arrow_spawned = false
var is_charging = false

var charge_power :float = 0.0
var current_power :float = 0.0

const MAX_CHARGE_POWER = 1
var audio_pitch
var thresh_hold = [0.8, 1.2]

func spawn_arrosw():
	var arrow = projectile.instantiate()
	get_parent().add_child(arrow)
	var direction = (get_global_mouse_position() - global_position).normalized()
	arrow.global_position = muzzle.global_position
	arrow.global_rotation = muzzle.global_rotation
	arrow.velocity = direction

func update_states():
	if velocity == Vector2.ZERO:
		body_sprite.play("idle")
	else:
		body_sprite.play("run")

func movement():
	var mouse_pos = get_global_mouse_position()
	hands_pivot.look_at(mouse_pos)
	if mouse_pos.x < global_position.x:
		body_sprite.flip_h  = true
	else:
		body_sprite.flip_h  = false
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	movement()
	move_and_slide()
	update_states()
	

	
	if Input.is_action_pressed("shoot") and can_shoot:
		is_charging = true
		charge_power += delta * power
		charge_power = min(charge_power, MAX_CHARGE_POWER)
		
		hands_sprite.play("hands_shoot", 2.0)
		#var charge_frame = int((charge_power / MAX_CHARGE_POWER) * 11)
		if hands_sprite.frame >= 11 and hands_sprite.is_playing():
			hands_sprite.frame = 11
			hands_sprite.pause()
			
		
	if Input.is_action_just_released("shoot") and is_charging:
		fire_arrow()
		reset_charge()

func fire_arrow():
	var arrow = projectile.instantiate()
	get_parent().add_child(arrow)
	var direction = (get_global_mouse_position() - global_position).normalized()
	var ratio = charge_power/MAX_CHARGE_POWER
	var arrow_speed = lerp(1000, 1900, ratio)
	release_sound.play(.36)
	if ratio >= 0.7:
		arrow.penetration_power = 3

	arrow.global_position = muzzle.global_position
	arrow.velocity = direction
	arrow.speed = arrow_speed
	arrow.global_rotation = muzzle.global_rotation
	hands_sprite.frame = 11
	hands_sprite.play()
	can_shoot = false
	cooldown_timer.start()
	
	

func reset_charge():
	is_charging = false
	charge_power = 0.0

func _on_hands_animation_finished() -> void:
	if hands_sprite.animation == "hands_shoot":
		arrow_spawned = false
		charge_power = 0.0
		hands_sprite.play("hands_idle")

func _on_hands_frame_changed() -> void:
	if hands_sprite.animation == "hands_shoot" and hands_sprite.frame == 12 and not arrow_spawned:
		arrow_spawned = true

func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
