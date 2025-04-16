extends Node2D

# Use _GUIPaths to create a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()
var hud_panel = _GUIPaths.GUIPanelScene.instantiate()

func _ready():
	panel.placement = GUIPanel.PanelPlacement.CENTER
	panel.set_background_color(Color.BLUE_VIOLET) # or define custom color `Color(0.1, 1.0, 0.1, 1.0)`
	panel.set_border_style(Color(0.5, 0.1, 0.1, 0.8), 4)
	$CanvasLayer.add_child(panel)

	var label = panel.add_label("")
	
	panel.add_button("Start Game", start_game) # can also define anonymous func in call: `func(): print("Game started!")`
	
	# Animate in
	panel.fade_in(0.5)
	panel.slide_in_from(panel.SlideDirection.BOTTOM)
	
	# show label with effect
	label.start_type_on_after_ready("Welcome to Godot UI!", 0.05, label.TypeOnMode.CHAR)
	
	# create HUD panel
	hud_panel.placement = GUIPanel.PanelPlacement.TOP_RIGHT
	hud_panel.set_background_color(Color.TRANSPARENT)
	$CanvasLayer.add_child(hud_panel)
	hud_panel.add_label("Score: 0")

func start_game():
	print("Game starting!")
	panel.fade_out()
	
