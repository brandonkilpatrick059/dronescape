class_name Menu extends Control

@onready var close_button = $CenterContainer/menu_background/VBoxContainer/HBoxContainer/close_button
@onready var fullscreen_toggle : CheckButton = $CenterContainer/menu_background/VBoxContainer/fullscreen_option

var active : bool = false

func _ready() -> void:
	visible = false
	update_buttons()

func update_buttons():
	fullscreen_toggle.set_pressed_no_signal(SettingsVariables.full_screen)

func set_active():
	active = true
	visible = true

func set_inactive():
	active = false
	visible = false

func is_active():
	return active

func _on_close_button_pressed() -> void:
	if(active):
		var picker : Picker_Circle = get_tree().get_first_node_in_group("picker_circle")
		picker.close_menu()

func _on_fullscreen_option_pressed() -> void:
	var toggle = SettingsVariables.full_screen
	toggle = !toggle
	SettingsVariables.full_screen = toggle
	if(SettingsVariables.full_screen):
		get_viewport().mode = 4 #fullscreen
	else:
		get_viewport().mode = 2 #maximized 
