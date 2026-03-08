extends Node2D

@export var enemy_scene: PackedScene
@onready var player = $player
@onready var spawn_location :PathFollow2D = $spawn_path/spawn_location
@onready var charge_bar = $CanvasLayer/Control/charge_bar
@onready var wave_cooldown = $wave_cooldown
@onready var wave_text = $CanvasLayer/Control/wave_info
@onready var enemy_count_text = $CanvasLayer/Control/enemy_info
@onready var wave_alert = $CanvasLayer/Control/wave_alert
@onready var spawn_timer  = $spawn_timer

@export var enemies_array :Array[PackedScene]= []
@export var random_enemies = []


var current_wave :int = 1
var wave_value :int = 0

var intermission = false

var cursor = load("res://assets/cursor.png")

func _ready() -> void:
	#CURSOR ITEMS
	cursor.resize(32, 32, Image.INTERPOLATE_LANCZOS)
	var cursor_texture := ImageTexture.create_from_image(cursor)
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(16, 16))
	
	#WAVE STUFF
	wave_alert.visible = false
	generate_wave()

func generate_wave():
	
	wave_value = current_wave * 10
	generate_enemies(wave_value)
	GameManager.entity_count = count(random_enemies)
	wave_text.text = " wave: " + str(current_wave)

func generate_enemies(budget):
	
	while (budget>0):

		
		var picked_enemy = enemies_array.pick_random()
		var enemy = picked_enemy.instantiate()
		var random_enemy_cost = enemy.cost
		
		if (budget-random_enemy_cost>=0):
			random_enemies.append(enemy)
			budget -= random_enemy_cost
		elif budget <= 0:
			break

func spawn_enemy():
	spawn_location.progress_ratio = randf()
	var spawn_pos = spawn_location.global_position
	if random_enemies.size() > 0:
		var enemy = random_enemies[0]
		add_child(enemy)
		enemy.global_position = spawn_pos
		enemy.target = player
		
		random_enemies.remove_at(0)
	elif random_enemies.size() <= 0 and GameManager.entity_count <= 0:
		
		spawn_timer.stop()
		wave_cooldown.start()
		wave_alert.visible = true
		current_wave += 1
		
		intermission = true
		
	
	

func count(array):
	var number = 0
	for i in array:
		if i != null:
			number += 1
	return number

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	charge_bar.value = int(player.charge_power * 100)
	enemy_count_text.text = "Enemies Left: " + str(GameManager.entity_count)
	
	if intermission:
		wave_alert.text = " Next wave in: " + str(int(wave_cooldown.time_left))
		


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_wave_cooldown_timeout() -> void:
	wave_alert.visible = false
	intermission = false
	generate_wave()
	spawn_timer.start()
	print( wave_value , current_wave)
