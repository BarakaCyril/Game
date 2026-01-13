extends Node2D

@export var enemy_scene: PackedScene
@onready var spawn_container = $spawn_points
@onready var player = $player

func get_random_pos():
	if spawn_container == null:
		push_error("Spawn container not assigned")
		return Vector2.ZERO
	var markers = spawn_container.get_children()
	if markers.size() > 0:
		var random_marker = markers.pick_random()
		if random_marker is Node2D:
			print(random_marker.global_position)
			return random_marker.global_position
	
func spawn_enemy():
	var spawn_pos = get_random_pos()
	var enemy :Area2D = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_pos
	
	enemy.target = player
	if enemy.target:
		print("Target aquired")
	

func _ready() -> void:
	spawn_enemy()
