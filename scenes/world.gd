extends Node2D

@export var enemy_scene: PackedScene
@onready var player = $player
@onready var spawn_location :PathFollow2D = $spawn_path/spawn_location

func spawn_enemy():
	spawn_location.progress_ratio = randf()
	var spawn_pos = spawn_location.global_position
	var enemy :Area2D = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_pos
	enemy.target = player


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
