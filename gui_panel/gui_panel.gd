extends Panel
class_name GUIPanel

@onready var content := $MarginContainer/Content
@export var placement: PanelPlacement = PanelPlacement.CENTER
@export var panel_size: Vector2 = Vector2.ZERO

var _style := StyleBoxFlat.new()

# store user set percentage size to apply after viewport is available
var _percent_width := -1.0
var _percent_height := -1.0

enum PanelPlacement {
	CENTER,
	TOP,
	BOTTOM,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

func _ready():
	if !has_node("MarginContainer/Content"):
		push_warning("GUIPanel is missing a 'Content' node. Add a VBoxContainer named 'Content' in the scene.")
		
	# place the panel
	match placement:
		PanelPlacement.CENTER:
			anchor_left = 0.25
			anchor_right = 0.75
			anchor_top = 0.35
			anchor_bottom = 0.65
			offset_left = 0
			offset_top = 0
			offset_right = 0
			offset_bottom = 0
			custom_minimum_size = Vector2.ZERO
	
		PanelPlacement.TOP:
			anchor_left = 0.25
			anchor_right = 0.75
			anchor_top = 0
			anchor_bottom = 0.2

		PanelPlacement.BOTTOM:
			anchor_left = 0.25
			anchor_right = 0.75
			anchor_top = 0.8
			anchor_bottom = 1.0

		PanelPlacement.TOP_LEFT:
			anchor_left = 0
			anchor_right = 0.3
			anchor_top = 0
			anchor_bottom = 0.2

		PanelPlacement.TOP_RIGHT:
			anchor_left = 0.7
			anchor_right = 1.0
			anchor_top = 0
			anchor_bottom = 0.2

		PanelPlacement.BOTTOM_LEFT:
			anchor_left = 0
			anchor_right = 0.3
			anchor_top = 0.8
			anchor_bottom = 1.0

		PanelPlacement.BOTTOM_RIGHT:
			anchor_left = 0.7
			anchor_right = 1.0
			anchor_top = 0.8
			anchor_bottom = 1.0

	# Common offset reset
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0
	
	if panel_size != Vector2.ZERO:
		custom_minimum_size = panel_size
	elif _percent_width > 0 and _percent_height > 0:
		_update_size_from_percent()
	
func set_background_color(color: Color) -> void:
	_style.bg_color = color
	add_theme_stylebox_override("panel", _style)
	
func set_border_style(options: Dictionary) -> void:
	if options.has("color"):
		_style.border_color = options["color"]
	if options.has("width"):
		_style.set_border_width_all(options["width"])
	if options.has("corner_radius"):
		_style.corner_radius_top_left = options["corner_radius"]
		_style.corner_radius_top_right = options["corner_radius"]
		_style.corner_radius_bottom_left = options["corner_radius"]
		_style.corner_radius_bottom_right = options["corner_radius"]
	
	add_theme_stylebox_override("panel", _style)

func set_size_percentage(width_percent: float, height_percent: float) -> void:
	_percent_width = clamp(width_percent, 0.0, 1.0)
	_percent_height = clamp(height_percent, 0.0, 1.0)

func _update_size_from_percent():
	var viewport_size = get_viewport().get_visible_rect().size
	custom_minimum_size = Vector2(
		viewport_size.x * _percent_width,
		viewport_size.y * _percent_height)
			
#func set_size_percentage(width_percent: float, height_percent: float) -> void:
	#var viewport_size = get_viewport().get_visible_rect().size
	#custom_minimum_size = Vector2(
		#viewport_size.x * clamp(width_percent, 0.0, 1.0),
		#viewport_size.y * clamp(height_percent, 0.0, 1.0))

func set_corner_radius(radius: int):
	_style.corner_radius_top_left = radius
	_style.corner_radius_top_right = radius
	_style.corner_radius_bottom_left = radius
	_style.corner_radius_bottom_right = radius
	add_theme_stylebox_override("panel", _style)

func show_panel():
	show()
	modulate.a = 1.0

func hide_panel():
	hide()

func fade_in(duration := 0.5):
	modulate.a = 0
	show()
	create_tween().tween_property(self, "modulate:a", 1.0, duration)

func fade_out(duration := 0.5):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(hide)
	
### --- add ui elements

func add_bar(initial_value := 100, options: Dictionary = {}) -> GUIBar:
	var bar = _GUIPaths.GUIBarScene.instantiate()
	bar.value = initial_value
	bar.min_value = 0
	bar.max_value = 100
	
	if options.has("size"):
		bar.custom_minimum_size = options["size"]
	else:
		bar.custom_minimum_size = Vector2(200, 20)

	if options.has("bar_color"):
		bar.bar_color = options["bar_color"]
	if options.has("background_color"):
		bar.background_color = options["background_color"]

	call_deferred("_add_bar_to_content", bar)
	return bar

func _add_bar_to_content(bar: GUIBar):
	if !is_instance_valid(content):
		push_warning("GUIPanel: Content node not found!")
		return
	content.add_child(bar)
	
func add_label(text: String, options: Dictionary = {}) -> Label:
	var label = _GUIPaths.GUILabelScene.instantiate()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.custom_minimum_size = Vector2(200, 44)
	label.text = text
	
	# Optional overrides
	if options.has("font"):
		label.add_theme_font_override("font", options["font"])
	if options.has("font_color"):
		label.add_theme_color_override("font_color", options["font_color"])

	# Defer to next frame to ensure layout is ready
	call_deferred("_add_label_to_content", label)
	return label

func _add_label_to_content(label: Label):
	if !is_instance_valid(content):
		push_warning("GUIPanel: Content node not found.")
		return
	content.add_child(label)

func add_button(text: String, callback: Callable = Callable(), options: Dictionary = {}) -> Button:
	var button = _GUIPaths.GUIButtonScene.instantiate()
	button.text = text
	
	# Font, color, size options...
	if options.has("font"):
		button.add_theme_font_override("font", options["font"])
	if options.has("font_color"):
		button.add_theme_color_override("font_color", options["font_color"])
	if options.has("size"):
		button.custom_minimum_size = options["size"]
	else:
		button.custom_minimum_size = Vector2(200, 44)  # default fallback
	
	call_deferred("_add_button_to_content", button, callback)
	return button

func _add_button_to_content(button: Button, callback: Callable):
	if !is_instance_valid(content):
		push_warning("GUIPanel: Content node not found.")
		return
		
	content.add_child(button)
	
	# ✅ Use one signal handler for both sound + user callback
	button.pressed.connect(func():
		# Play sound only if it's in tree and valid
		if button.is_inside_tree() and is_instance_valid(button.sound):
			await get_tree().process_frame
			button.sound.play()

		# Then call user's logic
		if callback.is_valid():
			await get_tree().create_timer(0.1).timeout  # allow sound to start
			callback.call()
	)
