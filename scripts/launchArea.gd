extends Area2D

@export var max_length := 200
@export var player_node :Area2D

var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO
var vector := Vector2.ZERO

signal vector_created(vector)

func _draw() -> void:
	var local_start = to_local(position_start)
	var local_end = to_local(position_end)

	draw_line(local_start, local_end, Color.BLUE, 10)
	draw_line(local_start, local_start + vector, Color.GREEN, 10)

func _ready() -> void:
	connect("input_event", Callable(self, "_on_input_event"))

func _reset():
	position_start = Vector2.ZERO
	position_end = Vector2.ZERO
	vector = Vector2.ZERO
	queue_redraw()

func _input(event: InputEvent) -> void:

	if touch_down and event is InputEventMouseMotion:
		position_end = event.global_position
		vector = -(position_end - position_start).limit_length(max_length)
		queue_redraw()
		
		if player_node and vector.length() > 0:
			player_node.look_at(player_node.global_position + vector)
		
	if event.is_action_released("touch"):
		touch_down = false
		if vector.length() > 5:
			emit_signal("vector_created", vector)
		_reset()

@warning_ignore("unused_parameter")
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("touch"):
		touch_down  = true
		position_start = event.position
