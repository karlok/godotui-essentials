@tool
extends Panel
class_name GUIPanel

## Enhanced panel with customizable borders and fade animations

# Border style enum
enum BorderStyle {
	NONE,
	FLAT,
	BEVELED,
	ROUNDED
}

# Panel properties
@export var border_style: BorderStyle = BorderStyle.ROUNDED:
	set(value):
		border_style = value
		_update_panel_style()

@export var border_width: int = 2:
	set(value):
		border_width = value
		_update_panel_style()

@export var border_color: Color = Color(0.8, 0.8, 0.8, 1.0):
	set(value):
		border_color = value
		_update_panel_style()

@export var background_color: Color = Color(0.2, 0.2, 0.2, 0.9):
	set(value):
		background_color = value
		_update_panel_style()

@export var corner_radius: int = 8:
	set(value):
		corner_radius = value
		_update_panel_style()

# Responsive design properties
@export var use_responsive_sizing: bool = false

# Fade animation properties
@export var use_fade_animations: bool = false
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.2
@export_enum("Linear", "Ease In", "Ease Out", "Ease In Out") var fade_easing: int = 2  # Default to Ease Out

# Private variables
var _panel_stylebox: StyleBoxFlat
var _original_modulate: Color

func _enter_tree() -> void:
	# This is crucial for proper serialization in the editor
	if Engine.is_editor_hint():
		# Make sure all children have the proper owner
		if owner:
			for child in get_children():
				if child.owner != owner:
					child.owner = owner

func _ready() -> void:
	# Store original modulate
	_original_modulate = modulate
	
	# Handle anchors and size/position to avoid warnings
	# Store current values
	var current_size = size
	var current_position = position
	
	# If we have non-equal opposite anchors, use set_deferred for size and position
	if anchor_right != anchor_left or anchor_bottom != anchor_top:
		set_deferred("size", current_size)
		set_deferred("position", current_position)
	
	# Apply the panel style
	_update_panel_style()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		if not get_tree().root.size_changed.is_connected(apply_responsive_settings):
			get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# If fade animations are enabled, start invisible if not in editor
	if use_fade_animations and not Engine.is_editor_hint():
		modulate.a = 0.0

## Apply a preset style to the panel
func set_preset_style(preset_name: String) -> void:
	match preset_name.to_lower():
		"default":
			border_style = BorderStyle.FLAT
			border_width = 1
			border_color = Color(0.8, 0.8, 0.8, 1.0)
			background_color = Color(0.2, 0.2, 0.2, 0.9)
		"flat":
			border_style = BorderStyle.FLAT
			border_width = 2
			border_color = Color(0.7, 0.7, 0.7, 1.0)
			background_color = Color(0.15, 0.15, 0.15, 0.95)
		"beveled":
			border_style = BorderStyle.BEVELED
			border_width = 2
			border_color = Color(0.8, 0.8, 0.8, 1.0)
			background_color = Color(0.2, 0.2, 0.2, 0.9)
		"rounded_light":
			border_style = BorderStyle.ROUNDED
			border_width = 2
			border_color = Color(0.9, 0.9, 0.9, 1.0)
			background_color = Color(0.3, 0.3, 0.3, 0.9)
			corner_radius = 10
		"none":
			border_style = BorderStyle.NONE
			border_width = 0
		_:
			push_error("Unknown preset style: " + preset_name)
			return
	
	_update_panel_style()

## Apply responsive settings based on viewport size
func apply_responsive_settings() -> void:
	if not use_responsive_sizing:
		return
		
	# Apply minimum size based on screen size
	custom_minimum_size = GUIResponsive.get_min_size("panel")

## Fade in the panel
func fade_in(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		modulate.a = 1.0
		return
		
	if duration < 0:
		duration = fade_in_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_in(self, duration, easing, delay)

## Fade out the panel
func fade_out(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		modulate.a = 0.0
		return
		
	if duration < 0:
		duration = fade_out_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_out(self, duration, easing, delay)

## Show the panel with fade if enabled
func show_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_in(duration, delay)

## Hide the panel with fade if enabled
func hide_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_out(duration, delay)

# Private methods
func _update_panel_style() -> void:
	# Create stylebox if it doesn't exist
	if not _panel_stylebox:
		_panel_stylebox = StyleBoxFlat.new()
	
	# Configure the panel stylebox
	_panel_stylebox.bg_color = background_color
	_panel_stylebox.border_color = border_color
	
	# Reset all border widths and corner radii first
	_panel_stylebox.border_width_left = 0
	_panel_stylebox.border_width_top = 0
	_panel_stylebox.border_width_right = 0
	_panel_stylebox.border_width_bottom = 0
	_panel_stylebox.corner_radius_top_left = 0
	_panel_stylebox.corner_radius_top_right = 0
	_panel_stylebox.corner_radius_bottom_left = 0
	_panel_stylebox.corner_radius_bottom_right = 0
	
	# Apply style based on border_style
	match border_style:
		BorderStyle.NONE:
			# No borders
			pass
		BorderStyle.FLAT, BorderStyle.BEVELED:
			_panel_stylebox.border_width_left = border_width
			_panel_stylebox.border_width_top = border_width
			_panel_stylebox.border_width_right = border_width
			_panel_stylebox.border_width_bottom = border_width
		BorderStyle.ROUNDED:
			_panel_stylebox.border_width_left = border_width
			_panel_stylebox.border_width_top = border_width
			_panel_stylebox.border_width_right = border_width
			_panel_stylebox.border_width_bottom = border_width
			_panel_stylebox.corner_radius_top_left = corner_radius
			_panel_stylebox.corner_radius_top_right = corner_radius
			_panel_stylebox.corner_radius_bottom_left = corner_radius
			_panel_stylebox.corner_radius_bottom_right = corner_radius
	
	# Apply beveled effect if needed
	if border_style == BorderStyle.BEVELED:
		_panel_stylebox.shadow_color = border_color.lightened(0.3)
		_panel_stylebox.shadow_size = border_width
		_panel_stylebox.shadow_offset = Vector2(-border_width/2, -border_width/2)
	else:
		_panel_stylebox.shadow_size = 0
	
	# Apply the panel stylebox directly
	add_theme_stylebox_override("panel", _panel_stylebox)

# This is called when the node is about to be removed from the scene
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		# Clean up any resources
		pass
	elif what == NOTIFICATION_EXIT_TREE:
		# Disconnect signals to prevent memory leaks
		if get_tree() and get_tree().root and use_responsive_sizing:
			if get_tree().root.size_changed.is_connected(apply_responsive_settings):
				get_tree().root.size_changed.disconnect(apply_responsive_settings)
	elif what == NOTIFICATION_CHILD_ORDER_CHANGED:
		# When child order changes, make sure all children have the proper owner
		if Engine.is_editor_hint() and owner:
			for child in get_children():
				if child.owner != owner:
					child.owner = owner

# Property change handlers
func _set(property, value):
	if property in ["border_style", "border_width", "border_color", "background_color", "corner_radius"]:
		set(property, value)
		_update_panel_style()
		return true
	return false 