extends Node2D

func _ready():
	# Use _GUIPaths to create a panel
	var panel = _GUIPaths.GUIPanelScene.instantiate()
	$CanvasLayer.add_child(panel)
	
	panel.add_label("Welcome to Godot UI")
	panel.add_button("Start Game", func(): print("Game started!"))
