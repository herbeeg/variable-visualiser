extends Node

var menu = null
var settings = null
var finder = null

func _ready():
	menu = create_instance('res://variable-visualiser/UI/Menu.tscn')
	settings = create_instance('res://variable-visualiser/UI/Settings.tscn')
	
	configureMargins(menu, 64)
	configureMargins(settings, 64)
	
	self.add_child(menu)
	
	var start_button_instance = get_node('Menu/MenuStackContainer/StartContainer/StartButton')
	start_button_instance.pressed.connect(self._startButtonPressed)
	
func create_instance(s : String) -> Node:
	var scene = load(s)
	return scene.instantiate()
	
func configureMargins(parent : Node, margin_val : int) -> void:
	parent.add_theme_constant_override("margin_top", margin_val)
	parent.add_theme_constant_override("margin_left", margin_val)
	parent.add_theme_constant_override("margin_bottom", margin_val)
	parent.add_theme_constant_override("margin_right", margin_val)
	
func _startButtonPressed() -> void:
	self.remove_child(menu)
	self.add_child(settings)
	
	var load_button_instance = get_node('Settings/SettingsStackContainer/LoadContainer/LoadButton')
	load_button_instance.pressed.connect(self._loadAudioButtonPressed)
	
func _loadAudioButtonPressed() -> void:
	finder = create_instance('res://variable-visualiser/FileHandler/Finder.tscn')
	settings.add_child(finder)
	finder.popup()
	
	finder.path_selected.connect(self._loadAudioFileSelected)
	
func _loadAudioFileSelected(path : String, ident : String) -> void:
	print(path)
