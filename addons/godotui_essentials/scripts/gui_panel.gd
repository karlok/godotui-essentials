@tool
extends Panel
class_name GUIPanel

## Enhanced panel with customizable borders, shadows, and fade animations

# Border style enum
enum BorderStyle {
	NONE,
	FLAT,
	BEVELED,
	ROUNDED
}

# Panel properties
@export var border_style: BorderStyle = BorderStyle.ROUNDED
@export var border_width: int = 2
@export var border_color: Color = Color(0.8, 0.8, 0.8, 1.0)
@export var background_color: Color = Color(0.2, 0.2, 0.2, 0.9)
@export var corner_radius: int = 8

# Shadow properties
@export var use_shadow: bool = true
@export var shadow_color: Color = Color(0, 0, 0, 0.3)
@export var shadow_offset: Vector2 = Vector2(4, 4)

# Responsive design properties
@export var use_responsive_sizing: bool = false

# Fade animation properties
@export var use_fade_animations: bool = false
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.2
@export_enum("Linear", "Ease In", "Ease Out", "Ease In Out") var fade_easing: int = 2  # Default to Ease Out

# Private variables
var _shadow_stylebox: StyleBoxFlat
var _panel_stylebox: StyleBoxFlat
var _original_modulate: Color

func _enter_tree():
	# This is crucial for proper serialization in the editor
	if Engine.is_editor_hint():
		# Make sure all children have the proper owner
		if owner:
			for child in get_children():
				if child.owner != owner:
					child.owner = owner

func _ready():
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
			use_shadow = false
		"flat":
			border_style = BorderStyle.FLAT
			border_width = 2
			border_color = Color(0.7, 0.7, 0.7, 1.0)
			background_color = Color(0.15, 0.15, 0.15, 0.95)
			use_shadow = false
		"beveled":
			border_style = BorderStyle.BEVELED
			border_width = 2
			border_color = Color(0.8, 0.8, 0.8, 1.0)
			background_color = Color(0.2, 0.2, 0.2, 0.9)
			use_shadow = true
			shadow_offset = Vector2(3, 3)
		"rounded_light":
			border_style = BorderStyle.ROUNDED
			border_width = 2
			border_color = Color(0.9, 0.9, 0.9, 1.0)
			background_color = Color(0.3, 0.3, 0.3, 0.9)
			corner_radius = 10
			use_shadow = true
			shadow_offset = Vector2(4, 4)
			shadow_color = Color(0, 0, 0, 0.2)
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
	# Create styleboxes if they don't exist
	if not _panel_stylebox:
		_panel_stylebox = StyleBoxFlat.new()
	
	if not _shadow_stylebox and use_shadow:
		_shadow_stylebox = StyleBoxFlat.new()
	
	# Configure the panel stylebox
	_panel_stylebox.bg_color = background_color
	_panel_stylebox.border_color = border_color
	
	match border_style:
		BorderStyle.NONE:
			_panel_stylebox.border_width_left = 0
			_panel_stylebox.border_width_top = 0
			_panel_stylebox.border_width_right = 0
			_panel_stylebox.border_width_bottom = 0
		BorderStyle.FLAT, BorderStyle.BEVELED:
			_panel_stylebox.border_width_left = border_width
			_panel_stylebox.border_width_top = border_width
			_panel_stylebox.border_width_right = border_width
			_panel_stylebox.border_width_bottom = border_width
			_panel_stylebox.corner_radius_top_left = 0
			_panel_stylebox.corner_radius_top_right = 0
			_panel_stylebox.corner_radius_bottom_left = 0
			_panel_stylebox.corner_radius_bottom_right = 0
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
	
	# Configure the shadow stylebox if shadow is enabled
	if use_shadow:
		_shadow_stylebox.bg_color = shadow_color
		_shadow_stylebox.border_width_left = 0
		_shadow_stylebox.border_width_top = 0
		_shadow_stylebox.border_width_right = 0
		_shadow_stylebox.border_width_bottom = 0
		
		if border_style == BorderStyle.ROUNDED:
			_shadow_stylebox.corner_radius_top_left = corner_radius
			_shadow_stylebox.corner_radius_top_right = corner_radius
			_shadow_stylebox.corner_radius_bottom_left = corner_radius
			_shadow_stylebox.corner_radius_bottom_right = corner_radius
		
		# Apply the shadow stylebox
		add_theme_stylebox_override("panel", _shadow_stylebox)
		
		# Create a new panel on top of the shadow
		if not has_node("PanelContent"):
			var panel_content = Panel.new()
			panel_content.name = "PanelContent"
			panel_content.set_anchors_preset(Control.PRESET_FULL_RECT)
			panel_content.set_deferred("position", Vector2.ZERO)
			panel_content.set_deferred("size", size)
			panel_content.add_theme_stylebox_override("panel", _panel_stylebox)
			add_child(panel_content)
			
			# This is crucial for proper serialization
			if Engine.is_editor_hint() and owner:
				panel_content.owner = owner
			
			# Move all existing children to the panel content
			for i in range(get_child_count() - 1, -1, -1):
				var child = get_child(i)
				if child != panel_content:
					remove_child(child)
					panel_content.add_child(child)
					
					# This is crucial for proper serialization
					if Engine.is_editor_hint() and owner:
						child.owner = owner
			
			# Apply the shadow offset
			panel_content.set_deferred("position", -shadow_offset)
	else:
		# If we previously had a shadow but now don't
		if has_node("PanelContent"):
			var panel_content = get_node("PanelContent")
			
			# Move all children back to the main panel
			for i in range(panel_content.get_child_count() - 1, -1, -1):
				var child = panel_content.get_child(i)
				panel_content.remove_child(child)
				add_child(child)
				
				# This is crucial for proper serialization
				if Engine.is_editor_hint() and owner:
					child.owner = owner
			
			# Remove the panel content
			panel_content.queue_free()
		
		# Apply the panel stylebox directly
		add_theme_stylebox_override("panel", _panel_stylebox)

# This is called when the node is about to be removed from the scene
func _notification(what):
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
	if property in ["border_style", "border_width", "border_color", "background_color", "corner_radius", "use_shadow", "shadow_color", "shadow_offset"]:
		set(property, value)
		_update_panel_style()
		return true
	return false 