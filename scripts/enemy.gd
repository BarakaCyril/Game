extends Area2D

@onready var health_bar :ProgressBar= $health_bar
@onready var hurt_sound = $hurt_sound

@onready var target :Node2D
@export var speed = 400
@export var health = 100
@export var cost = 1

func _ready() -> void:
	health_bar.value = health

func hurt(_damage):
	health_bar.value = health
	health -= _damage
	hurt_sound.play()
	
func _physics_process(delta: float) -> void:
	health_bar.value = health
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance > 10.0:
			var direction = global_position.direction_to(target.global_position)
			global_position += direction * speed * delta
			look_at(target.global_position)
	if health <= 0:
		queue_free()
		GameManager.entity_count -= 1

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		pass
