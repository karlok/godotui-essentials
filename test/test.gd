extends Node2D

var font := preload("res://addons/gui_essentials/fonts/Orbitron-Medium.ttf")

# Use _GUIPaths to create a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()
var hud_panel = _GUIPaths.GUIPanelScene.instantiate()

func _ready():
	panel.set_background_color(Color.BLUE_VIOLET) # or define custom color `Color(0.1, 1.0, 0.1, 1.0)`
	panel.set_border_style(Color.BLACK, 3)
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
	
	# create HUD panel
	hud_panel.placement = GUIPanel.PanelPlacement.TOP_RIGHT
	hud_panel.set_background_color(Color.TRANSPARENT)
	hud_panel.panel_size = Vector2(200, 44)
	$CanvasLayer.add_child(hud_panel)
	hud_panel.add_label("Score: 0000", {
		"font": font,
		"font_color": Color.BLACK,
		"size": Vector2(300, 40)
	})
	hud_panel.fade_in()

func start_game():
	print("Game starting!")
	panel.fade_out()
	
