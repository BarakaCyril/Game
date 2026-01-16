extends Area2D

var speed = 600
var damage = 50

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
