extends Area2D

@export var projectile:PackedScene


func shoot(vector: Vector2):
	var p = projectile.instantiate()
	get_parent().add_child(p)

	p.global_position = $muzzle.global_position
	p.global_transform = $muzzle.global_transform
	p.speed = vector.length() * 8
	if vector.length() < 100:
		p.speed = vector.length() * 8
	print(p.speed)


func _on_launch_area_vector_created(vector: Variant) -> void:
	shoot(vector)
