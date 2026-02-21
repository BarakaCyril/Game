extends Node2D

@export var enemy_scene: PackedScene
@onready var player = $player
@onready var spawn_location :PathFollow2D = $spawn_path/spawn_location
@onready var charge_bar = $CanvasLayer/Control/charge_bar
@onready var wave_cooldown = $wave_cooldown
@onready var wave_text = $CanvasLayer/Control/wave_info
@onready var enemy_count_text = $CanvasLayer/Control/enemy_info
@onready var wave_alert = $CanvasLayer/Control/wave_alert

@export var can_spawn = false

var entity_count :int = 0
var max_entity_per_wave :int = 2
var wave: int = 0

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
	GameManager.entity_count += 1
	enemy.global_position = spawn_pos
	enemy.target = player

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	charge_bar.value = int(player.charge_power * 100)
	

func _on_spawn_timer_timeout() -> void:
	if can_spawn:
		spawn_enemy()
		if GameManager.entity_count >= max_entity_per_wave:
			can_spawn = false
			wave_cooldown.start()
			wave_alert.visible = true
			wave_alert.text = "Next wave in: " + str(wave_cooldown.wait_time)

func _on_wave_cooldown_timeout() -> void:
	print("next wave started")
	wave_alert.visible = false
	can_spawn = true
	wave += 1
	wave_text.text = "Wave: " + str(wave)
	max_entity_per_wave += 10
