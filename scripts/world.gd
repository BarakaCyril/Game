extends Node2D

@export var enemy_scene: PackedScene
@onready var player = $player
@onready var spawn_location :PathFollow2D = $spawn_path/spawn_location
@onready var charge_bar = $CanvasLayer/Control/charge_bar

var cursor = load("res://assets/cursor.png")

func _ready() -> void:
	cursor.resize(32, 32, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(cursor)
	Input.set_custom_mouse_cursor(tex, Input.CURSOR_ARROW, Vector2(16, 16))

func spawn_enemy():
	spawn_location.progress_ratio = randf()
	var spawn_pos = spawn_location.global_position
	var enemy :Area2D = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_pos
	enemy.target = player

func _process(delta: float) -> void:
	charge_bar.value = int(player.charge_power * 100)
	

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
