extends Area2D

@onready var health_bar :ProgressBar= $health_bar

@onready var target :Node2D
@export var speed = 500
@export var health = 100

func _ready() -> void:
	health_bar.value = health
	health_bar.visible = false

func hurt(_damage):
	health_bar.visible = true
	health -= _damage
	print("hurt enemy")
	
func _physics_process(delta: float) -> void:
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance > 5.0:
			var direction = global_position.direction_to(target.global_position)
			global_position += direction * speed * delta
			look_at(target.global_position)
	if health <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		hurt(area.damage)
		area.queue_free()
