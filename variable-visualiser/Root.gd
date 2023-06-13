extends Node

var menu = null

func _ready():
	menu = create_instance('res://variable-visualiser/UI/Menu.tscn')
	configureMargins(menu, 64)
	
	self.add_child(menu)
	
func create_instance(s : String) -> Node:
	var scene = load(s)
	return scene.instantiate()
	
func configureMargins(parent : Node, margin_val : int) -> void:
	parent.add_theme_constant_override("margin_top", margin_val)
	parent.add_theme_constant_override("margin_left", margin_val)
	parent.add_theme_constant_override("margin_bottom", margin_val)
	parent.add_theme_constant_override("margin_right", margin_val)
