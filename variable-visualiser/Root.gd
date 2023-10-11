extends Node

var menu = null
var settings = null
var finder = null
var viewport = null
var overlay = null

# MeshLibrary instances.
var cube_library = null

func _ready() -> void:
	menu = create_instance('res://variable-visualiser/UI/Menu.tscn')
	settings = create_instance('res://variable-visualiser/UI/Settings.tscn')
	
	cube_library = load('res://variable-visualiser/MeshSource/CubeLibrary.tres')
	
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
	
func gatherConfig() -> void:
	var settings_container_parent = get_node('Settings/SettingsStackContainer/SettingsListContainer')
	GlobalSettings.visual['theme'] = settings_container_parent.get_child(1).get_item_text(settings_container_parent.get_child(1).get_selected_id()).to_lower()
	GlobalSettings.visual['shape'] = settings_container_parent.get_child(3).get_item_text(settings_container_parent.get_child(3).get_selected_id()).to_lower()
	GlobalSettings.visual['texture'] = settings_container_parent.get_child(5).get_item_text(settings_container_parent.get_child(5).get_selected_id()).to_lower()
	GlobalSettings.visual['background'] = settings_container_parent.get_child(7).get_item_text(settings_container_parent.get_child(7).get_selected_id()).to_lower()
	GlobalSettings.visual['filter'] = settings_container_parent.get_child(9).get_item_text(settings_container_parent.get_child(9).get_selected_id()).to_lower()
	
func generateAudioStream(path : String) -> void:
	var sample = load(path)
	var player = AudioStreamPlayer.new()
	player.stream = sample
	
	GlobalSettings.overlay['duration'] = int(floor(sample.get_length()))
	
	self.add_child(player)
	player.play()
	
func applyTheme() -> void:
	var environment_instance = get_node('BackgroundEnvironment')
	
	if 'ribena' == GlobalSettings.visual['theme']:
		environment_instance.environment.background_color = GlobalThemes.ribena['bg']
	elif 'tea' == GlobalSettings.visual['theme']:
		environment_instance.environment.background_color = GlobalThemes.tea['bg']
	elif 'sunrise' == GlobalSettings.visual['theme']:
		environment_instance.environment.background_color = GlobalThemes.sunrise['bg']

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
	gatherConfig()
	
	viewport = create_instance('res://variable-visualiser/Viewports/Base.tscn')
	overlay = create_instance('res://variable-visualiser/UI/Overlay.tscn')
	
	self.remove_child(settings)
	self.add_child(viewport)
	
	generateAudioStream(path)
	
	# Pad the text and timer(s) to ensure nothing is clipped from the outer edges.
	configureMargins(overlay, 64)
	# Change the colours before displaying the overlay.
	applyTheme()
	
	viewport.add_child(overlay)
	
	if 'wave' == GlobalSettings.visual['shape']:
		return
	elif 'sphere' == GlobalSettings.visual['shape']:
		return
	elif 'cube' == GlobalSettings.visual['shape']:
		var cube_import = cube_library.get_item_mesh(0)
		var cube_mesh = MeshInstance3D.new()
		cube_mesh.mesh = cube_import
		viewport.add_child(cube_mesh)
	elif 'pyramid' == GlobalSettings.visual['shape']:
		return
	elif 'cylinder' == GlobalSettings.visual['shape']:
		return
