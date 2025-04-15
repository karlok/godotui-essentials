extends Node2D

func _ready():
	# Use _GUIPaths to create a panel
	var panel = _GUIPaths.GUIPanelScene.instantiate()
	$CanvasLayer.add_child(panel)
	
	panel.set_background_color(Color(0.1, 1.0, 0.1, 1.0))
	panel.set_border_style(Color(0.5, 0.1, 0.1, 0.8), 4)
	
	var label = panel.add_label("")
	label.type_on("Welcome to Godot UI!", 0.05, label.TypeOnMode.CHAR)
	
	panel.add_button("Start Game", func(): print("Game started!"))
