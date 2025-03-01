@tool
extends Control
class_name GUITooltip

## Customizable tooltip with text, rich text support, and fade animations

# Tooltip properties
@export_enum("text", "rich_text") var tooltip_mode: String = "text"
@export var text: String = "Tooltip text":
	set(value):
		text = value
		if _label and tooltip_mode == "text":
			_label.text = value

@export var rich_text: String = "[b]Rich[/b] tooltip text":
	set(value):
		rich_text = value
		if _rich_label and tooltip_mode == "rich_text":
			_rich_label.text = value

@export var show_delay: float = 0.2
@export var hide_delay: float = 0.1
@export var follow_mouse: bool = true
@export var offset: Vector2 = Vector2(10, 10)
@export var auto_size: bool = true
@export var min_width: int = 100
@export var max_width: int = 300

# Appearance properties
@export var background_color: Color = Color(0.1, 0.1, 0.1, 0.9)
@export var border_color: Color = Color(0.3, 0.3, 0.3, 1.0)
@export var text_color: Color = Color.WHITE

# Responsive design properties
@export var use_responsive_sizing: bool = false
@export var font_size_category: String = "normal"

# Fade animation properties
@export var use_fade_animations: bool = true
@export var fade_in_duration: float = 0.15
@export var fade_out_duration: float = 0.1
@export_enum("Linear", "Ease In", "Ease Out", "Ease In Out") var fade_easing: int = 2  # Default to Ease Out

# Private variables
var _panel: Panel
var _label: Label
var _rich_label: RichTextLabel
var _target: Control
var _show_timer: Timer
var _hide_timer: Timer
var _mouse_inside: bool = false
var _original_modulate: Color

func _ready():
	# Store original modulate
	_original_modulate = modulate
	
	# Set up the tooltip if not already set up
	if not _panel:
		_setup_tooltip()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# Hide the tooltip initially
	visible = false
	
	# If fade animations are enabled, set alpha to 0
	if use_fade_animations:
		modulate.a = 0.0

func _setup_tooltip() -> void:
	# Set up the control properties
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Create the panel background
	_panel = Panel.new()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_panel)
	
	# Create a stylebox for the panel
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = background_color
	style_box.border_width_left = 1
	style_box.border_width_top = 1
	style_box.border_width_right = 1
	style_box.border_width_bottom = 1
	style_box.border_color = border_color
	style_box.corner_radius_top_left = 3
	style_box.corner_radius_top_right = 3
	style_box.corner_radius_bottom_left = 3
	style_box.corner_radius_bottom_right = 3
	_panel.add_theme_stylebox_override("panel", style_box)
	
	# Create a margin container
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	_panel.add_child(margin)
	
	# Create the label for regular text
	_label = Label.new()
	_label.text = text
	_label.add_theme_color_override("font_color", text_color)
	_label.visible = tooltip_mode == "text"
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	margin.add_child(_label)
	
	# Create the rich text label
	_rich_label = RichTextLabel.new()
	_rich_label.bbcode_enabled = true
	_rich_label.text = rich_text
	_rich_label.add_theme_color_override("default_color", text_color)
	_rich_label.visible = tooltip_mode == "rich_text"
	_rich_label.fit_content = true
	_rich_label.scroll_active = false
	_rich_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	margin.add_child(_rich_label)
	
	# Set up timers
	_show_timer = Timer.new()
	_show_timer.one_shot = true
	_show_timer.timeout.connect(_on_show_timer_timeout)
	add_child(_show_timer)
	
	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(_hide_timer)
	
	# Set initial size
	_update_size()

func _process(_delta: float) -> void:
	if visible and follow_mouse and _target:
		_update_position()

func _update_size() -> void:
	if auto_size:
		# Reset size to allow content to determine it
		custom_minimum_size = Vector2.ZERO
		size = Vector2.ZERO
		
		# Wait for the next frame to get the correct content size
		await get_tree().process_frame
		
		# Get the content size
		var content_size = Vector2.ZERO
		if tooltip_mode == "text" and _label:
			content_size = _label.size
		elif tooltip_mode == "rich_text" and _rich_label:
			content_size = _rich_label.size
		
		# Apply min/max width constraints
		var width = content_size.x
		if min_width > 0 and width < min_width:
			width = min_width
		if max_width > 0 and width > max_width:
			width = max_width
		
		# Set the final size
		custom_minimum_size = Vector2(width, content_size.y)
		size = custom_minimum_size
	else:
		# Use the specified min_width
		custom_minimum_size = Vector2(min_width, 0)
		size = custom_minimum_size

func _update_position() -> void:
	if not _target or not is_instance_valid(_target):
		return
		
	var mouse_pos = _target.get_viewport().get_mouse_position()
	var viewport_size = _target.get_viewport_rect().size
	
	# Calculate position based on mouse position and offset
	var pos = mouse_pos + offset
	
	# Ensure the tooltip stays within the viewport
	if pos.x + size.x > viewport_size.x:
		pos.x = mouse_pos.x - size.x - offset.x
	
	if pos.y + size.y > viewport_size.y:
		pos.y = mouse_pos.y - size.y - offset.y
	
	# Apply the position
	global_position = pos

func _on_target_mouse_entered() -> void:
	_mouse_inside = true
	_hide_timer.stop()
	_show_timer.start(show_delay)

func _on_target_mouse_exited() -> void:
	_mouse_inside = false
	_show_timer.stop()
	if visible:
		_hide_timer.start(hide_delay)

func _on_target_visibility_changed() -> void:
	if _target and not _target.visible:
		hide_tooltip()

func _on_show_timer_timeout() -> void:
	if _mouse_inside and _target and _target.visible:
		show_tooltip()

func _on_hide_timer_timeout() -> void:
	if not _mouse_inside:
		hide_tooltip()

## Attach the tooltip to a control
func attach_to(target: Control) -> void:
	# Detach from previous target if any
	detach()
	
	# Set the new target
	_target = target
	
	# Connect signals
	if _target:
		_target.mouse_entered.connect(_on_target_mouse_entered)
		_target.mouse_exited.connect(_on_target_mouse_exited)
		_target.visibility_changed.connect(_on_target_visibility_changed)

## Detach the tooltip from its target
func detach() -> void:
	if _target:
		if _target.is_connected("mouse_entered", _on_target_mouse_entered):
			_target.mouse_entered.disconnect(_on_target_mouse_entered)
		
		if _target.is_connected("mouse_exited", _on_target_mouse_exited):
			_target.mouse_exited.disconnect(_on_target_mouse_exited)
		
		if _target.is_connected("visibility_changed", _on_target_visibility_changed):
			_target.visibility_changed.disconnect(_on_target_visibility_changed)
		
		_target = null

## Show the tooltip immediately
func show_tooltip() -> void:
	if not is_inside_tree():
		await ready
	
	_update_size()
	_update_position()
	
	if use_fade_animations:
		fade_in()
	else:
		visible = true

## Hide the tooltip immediately
func hide_tooltip() -> void:
	if use_fade_animations and visible:
		fade_out()
	else:
		visible = false

## Set the tooltip style
func set_style(bg_color: Color, border_col: Color, txt_color: Color) -> void:
	background_color = bg_color
	border_color = border_col
	text_color = txt_color
	
	# Update the panel style
	if _panel:
		var style_box = _panel.get_theme_stylebox("panel") as StyleBoxFlat
		if style_box:
			style_box.bg_color = bg_color
			style_box.border_color = border_col
	
	# Update the text color
	if _label:
		_label.add_theme_color_override("font_color", txt_color)
	
	if _rich_label:
		_rich_label.add_theme_color_override("default_color", txt_color)

## Apply responsive settings based on screen size
func apply_responsive_settings() -> void:
	if not use_responsive_sizing:
		return
		
	# Apply font sizes
	if _label:
		_label.add_theme_font_size_override("font_size", GUIResponsive.get_font_size(font_size_category))
	
	if _rich_label:
		_rich_label.add_theme_font_size_override("normal_font_size", GUIResponsive.get_font_size(font_size_category))
	
	# Scale min/max width based on screen size
	var scale_factor = GUIResponsive.get_scale_factor()
	var scaled_min_width = int(min_width * scale_factor)
	var scaled_max_width = int(max_width * scale_factor)
	
	# Apply scaled values
	if auto_size:
		if min_width > 0:
			min_width = scaled_min_width
		if max_width > 0:
			max_width = scaled_max_width
	else:
		custom_minimum_size.x = scaled_min_width
	
	# Update size and position
	if visible:
		_update_size()
		_update_position()

## Fade in the tooltip
func fade_in(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		visible = true
		return
		
	if duration < 0:
		duration = fade_in_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_in(self, duration, easing, delay)

## Fade out the tooltip
func fade_out(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		visible = false
		return
		
	if duration < 0:
		duration = fade_out_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_out(self, duration, easing, delay)

## Create a tooltip and attach it to a control
static func create_for_control(parent: Node, target: Control, tooltip_text: String) -> GUITooltip:
	var tooltip = preload("res://addons/godotui_essentials/components/gui_tooltip.tscn").instantiate()
	tooltip.text = tooltip_text
	parent.add_child(tooltip)
	tooltip.attach_to(target)
	return tooltip 