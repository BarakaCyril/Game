extends Area2D
class_name BaseArrow

var velocity = Vector2()
var speed = 0
var damage = 50
var penetration_power = 1
var is_active = true

func _physics_process(delta: float) -> void:
	if is_active:
		global_position += velocity * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("hurt") and is_active:
		penetration_power -=1
		area.hurt(damage)
		if penetration_power <= 0:
			is_active = false
			set_deferred("monitoring", false) 
			set_deferred("monitorable", false)
			queue_free()
		
