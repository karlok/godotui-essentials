extends Node2D

# Use _GUIPaths to create a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()

func _ready():
	$CanvasLayer.add_child(panel)
	
	#panel.set_background_color(Color(0.1, 1.0, 0.1, 1.0))
	panel.set_background_color(Color.BLUE_VIOLET)
	#panel.set_background_color(Color(1.0, 1.0, 1.0, 0.0)) # invisible panel
	panel.set_border_style(Color(0.5, 0.1, 0.1, 0.8), 4)
	
	var label = panel.add_label("")
	label.type_on("Welcome to Godot UI!", 0.05, label.TypeOnMode.CHAR)
	#panel.add_button("Start Game", func(): print("Game started!"))
	panel.add_button("Start Game", start_game)
	
	# Wait a frame so these values "stick" before animating
	await get_tree().process_frame

	# Animate in
	panel.fade_in(0.5)
	panel.slide_in_from(panel.SlideDirection.BOTTOM)

func start_game():
	print("Game starting!")
	panel.fade_out()
	
