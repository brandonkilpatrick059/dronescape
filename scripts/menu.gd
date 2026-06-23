class_name Menu extends Control

@onready var close_button = $CenterContainer/menu_background/VBoxContainer/HBoxContainer/close_button
@onready var fullscreen_toggle : CheckButton = $CenterContainer/menu_background/VBoxContainer/HBoxContainer2/fullscreen_option
@onready var resolution_picker : OptionButton = $CenterContainer/menu_background/VBoxContainer/HBoxContainer3/HBoxContainer2/resolution_picker
@onready var master_vol_slider : Slider = $CenterContainer/menu_background/VBoxContainer/master_vol_container/HBoxContainer2/master_vol_slider
@onready var chime_vol_slider : Slider = $CenterContainer/menu_background/VBoxContainer/chime_vol_container/HBoxContainer2/chime_vol_slider
@onready var effects_vol_slider : Slider = $CenterContainer/menu_background/VBoxContainer/effects_volume_container/HBoxContainer2/effects_vol_slider
@onready var interface_vol_slider : Slider = $CenterContainer/menu_background/VBoxContainer/interface_volume_container2/HBoxContainer2/interface_vol_slider
@onready var save_file_ui = $CenterContainer/menu_background/save_file
@onready var save_console : Label = $CenterContainer/menu_background/save_file/save_console_display
@onready var save_file_name : LineEdit = $CenterContainer/menu_background/save_file/HBoxContainer/save_file_name
@onready var load_file_ui = $CenterContainer/menu_background/load_file
@onready var preset_picker : OptionButton = $CenterContainer/menu_background/VBoxContainer/load_preset_container/HBoxContainer2/preset_picker
@onready var file_loc_button = $CenterContainer/menu_background/load_file/HBoxContainer2/HBoxContainer3/file_loc_button
@onready var main_ui = $CenterContainer/menu_background/VBoxContainer

var active : bool = false

var zero_db : float = -40.0

var vol_adjusting : bool = false

var volume_sliders : Array[Slider] = []

var preset_paths : Array[String] =[
	"res://presets/simple_island.txt"
]

func _ready() -> void:
	visible = false
	volume_sliders  = [
		master_vol_slider,
		chime_vol_slider,
		effects_vol_slider,
		interface_vol_slider
	]
	save_console.text = ""

func update_buttons():
	fullscreen_toggle.set_pressed_no_signal(SettingsVariables.full_screen)
	update_resolution_picker()
	update_volume_sliders()

func update_resolution_picker():
	if(resolution_picker.item_count == 0):
		var supported_resolutions = SettingsVariables.supported_resolutions
		for res in supported_resolutions:
			var str_res = ""
			str_res = str(str(int(res.x),"x"),int(res.y))
			resolution_picker.add_item(str_res)

func update_volume_sliders():
	var index = 0
	while(index < volume_sliders.size()):
		var bus_vol_db = AudioServer.get_bus_volume_db(index)
		var quotient = zero_db - bus_vol_db
		var fraction = (quotient / zero_db) * 100
		volume_sliders[index].set_value_no_signal(fraction)
		index = index + 1

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


func _on_vol_slider_drag_ended(value_changed: bool) -> void:
	vol_adjusting = false
	adjust_volumes()

func _on_vol_slider_drag_started() -> void:
	vol_adjusting = true

func adjust_volumes():
	var index = 0
	while(index < volume_sliders.size()):
		var fraction = volume_sliders[index].value
		var quotient = (100.0 - fraction) / 100.0
		var new_vol_db = (zero_db * quotient)
		if(new_vol_db > 0.0):
			new_vol_db = 0.0
		if(new_vol_db <= zero_db):
			new_vol_db = -60
		AudioServer.set_bus_volume_db(index, new_vol_db)
		index = index + 1

#func _process(delta: float) -> void:
	#if(vol_adjusting):
		#adjust_volumes()
	

func _on_save_button_pressed() -> void:
	save_file_ui.visible = true
	load_file_ui.visible = false
	main_ui.visible = false


func _on_load_button_pressed() -> void:
	save_file_ui.visible = false
	load_file_ui.visible = true
	main_ui.visible = false


func _on_back_button_pressed() -> void:
	save_file_ui.visible = false
	load_file_ui.visible = false
	main_ui.visible = true
	save_console.text = ""


func _on_save_file_button_pressed() -> void:
	var new_name = save_file_name.text
	if(new_name.contains(" ") ||
	new_name.contains("\\") ||
	new_name.contains("/") ||
	!new_name.is_valid_filename()):
		save_console.text = "invalid file name"
		save_console.modulate = Color(1,0,0)
	else:
		save_console.text = "saving file..."
		save_console.modulate = Color(1,1,1)
		var save_load_manager : SaveLoadManager = get_tree().get_first_node_in_group("save_load_manager")
		save_load_manager.save_aeroscape(new_name)
		save_console.text = "file saved"
		save_console.modulate = Color(0,1,0)


func _on_file_loc_button_pressed() -> void:
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://aeroscapes"))

func _on_load_preset_button_pressed() -> void:
	var preset_index = preset_picker.selected
	var path = preset_paths[preset_index]
	var save_load_manager : SaveLoadManager = get_tree().get_first_node_in_group("save_load_manager")
	save_load_manager.load_aeroscape(path)
