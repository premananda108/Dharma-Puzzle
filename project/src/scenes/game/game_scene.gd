extends Control

signal board_size_update
signal show_numbers_update

var is_started = false
var game_won = false
var start_epoch
var current_epoch

onready var board = $MarginContainer/VBoxContainer/GameView/Board

onready var overlay = $MarginContainer/VBoxContainer/GameView/StartOverlay
onready var overlay_text = $MarginContainer/VBoxContainer/GameView/StartOverlay/TextOverlay

onready var move_value = $MarginContainer/VBoxContainer/StatsView/HBoxContainer/Moves/MoveValue
onready var timer_value = $MarginContainer/VBoxContainer/StatsView/HBoxContainer/Time/TimeValue

# Узлы кнопок
onready var button_1 = $MarginContainer/VBoxContainer/GridContainer/Button_1
onready var button_2 = $MarginContainer/VBoxContainer/GridContainer/Button_2
onready var button_3 = $MarginContainer/VBoxContainer/GridContainer/Button_3

onready var anim_player = $AnimationPlayer

func _ready():
	# Подключаем сигналы кнопок к функции on_button_pressed
	button_1.connect("pressed", self, "_on_button_pressed", [button_1])
	button_2.connect("pressed", self, "_on_button_pressed", [button_2])
	button_3.connect("pressed", self, "_on_button_pressed", [button_3])

	if Global.number_of_tiles == 4:
		button_1.pressed = true
	else:
		if Global.number_of_tiles == 5:
			button_2.pressed = true
		else:
			button_3.pressed = true	
	
	overlay.visible = true

# Функция для обработки нажатия на кнопку
func _on_button_pressed(selected_button: Button):
	# Проходимся по всем кнопкам и отключаем их
	for button in [button_1, button_2, button_3]:
		button.pressed = false
	if selected_button == button_1:
		Global.number_of_tiles = 4
	else: 
		if selected_button == button_2:
			Global.number_of_tiles = 5
		else:
			Global.number_of_tiles = 6
	
	# Включаем только нажатую кнопку
	selected_button.pressed = true
	
	emit_signal("board_size_update", Global.number_of_tiles)

func _process(_delta):
	if is_started:
		current_epoch = OS.get_ticks_msec()
		var time_since_game_start = current_epoch - start_epoch
		timer_value.text = str(floor(time_since_game_start/1000)) + 's'
	else:
		if not game_won:
			timer_value.text = '0s'

func _on_Board_game_started():
	start_epoch = OS.get_ticks_msec()
	overlay.visible = false
	is_started = true
	game_won = false


func _on_Board_game_won():
	overlay_text.text = 'Nice Work!\n Click to play again'
	overlay.visible = true
	is_started = false
	game_won = true


func _on_RestartButton_pressed():
	if not is_started:
		return
	board.reset_move_count()
	board.scramble_board()
	board.game_state = board.GAME_STATES.STARTED
	start_epoch = OS.get_ticks_msec()
	is_started = true


func _on_Board_moves_updated(move_count):
	move_value.text = str(move_count)


func _on_GameScene_board_size_update(new_size):
	board.update_size(new_size)
	overlay_text.text = 'Click to start'
	overlay.visible = true
	is_started = false


func _on_GameScene_show_numbers_update(state):
	board.set_tile_numbers(state)


func _on_SettingsButton_pressed():
	anim_player.play("show_settings")


func _on_GameScene_hide_settings():
	anim_player.play_backwards("show_settings")


func _on_GameScene_background_update(texture: ImageTexture):
	print('updating background texture now')
	board.update_background_texture(texture)

func _on_CheckButton_toggled(button_pressed):
	emit_signal("show_numbers_update", button_pressed)


func _on_BackButton_pressed():
	var _error = get_tree().change_scene("res://src/scenes/menu_screen/menu_screen.tscn")
