extends Node2D

# Look in the `fonts`directory for all your build-in font options, or add more .ttf files if needed
var font := preload("res://addons/gui_essentials/fonts/Orbitron-Medium.ttf")

# Use _GUIPaths to create a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()
var score_panel = _GUIPaths.GUIPanelScene.instantiate()
var health_panel = _GUIPaths.GUIPanelScene.instantiate()

var health_bar: GUIBar
var health := 100

func _ready():
	# setup demo health timer
	$HealthTimer.timeout.connect(_on_health_timer_timeout)
	
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
	health_bar = health_panel.add_bar(100, {
		"size": Vector2(200, 20),
		"bar_color": Color.LIME_GREEN,
		"background_color": Color.TRANSPARENT
	})
	health_panel.fade_in()

func start_game():
	print("Game starting!")
	panel.fade_out()

func _on_health_timer_timeout():
	health = max(health - 5, 0)
	health_bar.value = health
	update_health_bar_color()
	
	if health <= 0:
		$HealthTimer.stop()  # ⛔ stop timer so it doesn't go negative
		show_game_over()

func update_health_bar_color():
	var pct := health / 100.0
	var color := Color()

	if pct > 0.5:
		color = Color(1.0 - (pct - 0.5) * 2.0, 1.0, 0.0) # green → yellow
	else:
		color = Color(1.0, pct * 2.0, 0.0) # yellow → red

	health_bar.set_fill_color(color)

func show_game_over():
	var game_over_panel = _GUIPaths.GUIPanelScene.instantiate()
	game_over_panel.placement = GUIPanel.PanelPlacement.CENTER
	game_over_panel.set_background_color(Color.BLACK)
	game_over_panel.set_border_style({ "color": Color.RED, "width": 3, "corner_radius": 8 })
	game_over_panel.set_size_percentage(0.6, 0.3)

	$CanvasLayer.add_child(game_over_panel)

	game_over_panel.add_label("💀 GAME OVER 💀", {
		"font": font,
		"font_color": Color.RED,
		"size": Vector2(300, 40)
	})
	
	game_over_panel.add_button("Try Again", func():
		get_tree().reload_current_scene(),
		{
			"font": font,
			"font_color": Color.YELLOW,
			"size": Vector2(300, 50)
		})

	game_over_panel.fade_in()
