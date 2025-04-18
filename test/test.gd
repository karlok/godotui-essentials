extends Node2D

# Look in the `fonts`directory for all your build-in font options, or add more .ttf files if needed
var font := preload("res://addons/gui_essentials/fonts/Orbitron-Medium.ttf")

# Use _GUIPaths to create a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()
var score_panel = _GUIPaths.GUIPanelScene.instantiate()
var health_panel = _GUIPaths.GUIPanelScene.instantiate()

func _ready():
	panel.set_background_color(Color.BLUE_VIOLET) # or define custom color `Color(0.1, 1.0, 0.1, 1.0)`
	panel.set_size_percentage(0.8, 0.7) # 80% of viewport width, 70% of viewport height
	panel.set_border_style({
		"color": Color.BLACK,
		"width": 4,
		"corner_radius": 12
	})
	
	$CanvasLayer.add_child(panel)

	var label = panel.add_label("", { # set up label for type on animation
		"font": font,
		"font_color": Color.SKY_BLUE,
		"size": Vector2(300, 40)
	})
	
	panel.add_button("Start", start_game, { # can also define anonymous func in call: `func(): print("Game started!")`
		"font": font,
		"font_color": Color.GREEN_YELLOW,
		"size": Vector2(300, 60)
	})
	
	panel.fade_in()
	
	# show label with effect
	label.start_type_on_after_ready("Welcome to Godot UI!", 0.05, label.TypeOnMode.CHAR)
	
	# create HUD panels
	score_panel.placement = GUIPanel.PanelPlacement.TOP_RIGHT
	score_panel.set_background_color(Color.TRANSPARENT)
	score_panel.panel_size = Vector2(300, 50)
	$CanvasLayer.add_child(score_panel)
	score_panel.add_label("Score: 0000", {
		"font": font,
		"font_color": Color.BLACK,
		"size": Vector2(300, 44)
	})
	score_panel.fade_in()
	
	health_panel.placement = GUIPanel.PanelPlacement.TOP_LEFT
	health_panel.set_background_color(Color.TRANSPARENT)
	health_panel.panel_size = Vector2(300, 50)
	$CanvasLayer.add_child(health_panel)
	health_panel.add_bar(100, {
		"size": Vector2(200, 20),
		"bar_color": Color.LIME_GREEN,
		"background_color": Color.DARK_GRAY
	})
	health_panel.fade_in()

func start_game():
	print("Game starting!")
	panel.fade_out()
	
