class_name Menu extends Control

@onready var close_button = $CenterContainer/menu_background/VBoxContainer/HBoxContainer/close_button
@onready var fullscreen_toggle : CheckButton = $CenterContainer/menu_background/VBoxContainer/HBoxContainer2/fullscreen_option
@onready var resolution_picker : OptionButton = $CenterContainer/menu_background/VBoxContainer/HBoxContainer3/HBoxContainer2/resolution_picker

var active : bool = false

func _ready() -> void:
	visible = false

func update_buttons():
	fullscreen_toggle.set_pressed_no_signal(SettingsVariables.full_screen)
	update_resolution_picker()

func update_resolution_picker():
	if(resolution_picker.item_count == 0):
		var supported_resolutions = SettingsVariables.supported_resolutions
		for res in supported_resolutions:
			var str_res = ""
			str_res = str(str(int(res.x),"x"),int(res.y))
			resolution_picker.add_item(str_res)

func set_active():
	active = true
	visible = true
	update_buttons()

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

func _on_resolution_picker_item_selected(index: int) -> void:
	SettingsVariables.resolution_index = index
	var selected_resolution = SettingsVariables.supported_resolutions[SettingsVariables.resolution_index]
	get_viewport().content_scale_size = selected_resolution
