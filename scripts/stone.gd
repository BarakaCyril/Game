extends Area2D

var speed = 600
var direction := Vector2.ZERO
var damage = 50

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
