extends Area2D

@onready var target :Node2D
@export var speed = 500


func _physics_process(delta: float) -> void:
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance > 5.0:
			var direction = global_position.direction_to(target.global_position)
			global_position += direction * speed * delta
			look_at(target.global_position)
