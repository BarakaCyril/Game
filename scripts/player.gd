extends CharacterBody2D

@export var projectile:PackedScene
@export var max_length := 200
@export var speed = 400

var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO
var launch_vector := Vector2.ZERO

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _draw() -> void:
	var local_start = to_local(position_start)
	draw_dashed_line(local_start, local_start + launch_vector, Color.GREEN, 2)

func _reset():
	position_start = Vector2.ZERO
	position_end = Vector2.ZERO
	launch_vector = Vector2.ZERO
	queue_redraw()

func _input(event: InputEvent) -> void:

	if touch_down and event is InputEventMouseMotion:
		
		position_end = event.global_position
		launch_vector = (position_end - position_start).limit_length(max_length)
		queue_redraw()
		$muzzle.global_position = position_start
		
		
	if event.is_action_released("touch"):
		touch_down = false
		if launch_vector.length() > 5:
			shoot(launch_vector)
		_reset()

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	if Input.is_action_pressed("touch"):
		touch_down = true
		position_start = global_position

func shoot(vector: Vector2):
	var p = projectile.instantiate()
	get_parent().add_child(p)
	p.global_position = $muzzle.global_position
	p.direction = launch_vector.normalized()
	p.speed = vector.length() * 8
	if vector.length() < 100:
		p.speed = vector.length() * 8
	print(p.speed)
