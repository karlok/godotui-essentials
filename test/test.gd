extends Node2D

func _ready():
	# Use the GUIPaths helper function to create a panel
	var panel = _GUIPaths.GUIPanelScene.instantiate()
	$CanvasLayer.add_child(panel)
