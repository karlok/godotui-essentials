@tool
extends Node
class_name GUIResponsive

## Utility class for responsive UI design that scales based on viewport dimensions

# Reference viewport dimensions
const REFERENCE_WIDTH = 1024.0  # Base width for scaling calculations
const REFERENCE_HEIGHT = 600.0  # Base height for scaling calculations

# Min/max constraints for scaling
const MIN_SCALE_FACTOR = 0.5
const MAX_SCALE_FACTOR = 2.0

# Font size ranges
const FONT_SIZE_RANGES = {
	"small": {"min": 12, "max": 18},
	"normal": {"min": 14, "max": 20},
	"large": {"min": 18, "max": 28},
	"title": {"min": 24, "max": 36}
}

# Spacing ranges
const MARGIN_RANGE = {"min": 8, "max": 24}
const PADDING_RANGE = {"min": 6, "max": 20}
const SPACING_RANGE = {"min": 5, "max": 16}

# Component size ranges (min width, min height, max width, max height)
const COMPONENT_SIZE_RANGES = {
	"button": {"min": Vector2(80, 30), "max": Vector2(150, 60)},
	"panel": {"min": Vector2(200, 100), "max": Vector2(500, 250)},
	"dialog": {"min": Vector2(250, 120), "max": Vector2(550, 300)},
	"tooltip": {"min": Vector2(80, 30), "max": Vector2(150, 60)}
}

# For backward compatibility - these will be deprecated in future versions
enum ScreenSize {
	SMALL,    # Mobile phones (< 600px width)
	MEDIUM,   # Tablets (600px - 1024px width)
	LARGE,    # Desktops (1024px - 1920px width)
	XLARGE    # Large displays (> 1920px width)
}

# Breakpoint values in pixels - for backward compatibility
const SMALL_BREAKPOINT = 600
const MEDIUM_BREAKPOINT = 1024
const LARGE_BREAKPOINT = 1920

## Get the viewport dimensions
static func get_viewport_dimensions() -> Vector2:
	return DisplayServer.window_get_size()

## Check if the viewport is in portrait orientation
static func is_portrait_mode() -> bool:
	var viewport_size = get_viewport_dimensions()
	return viewport_size.y > viewport_size.x

## Get the scale factor based on viewport width
static func get_scale_factor() -> float:
	var viewport_size = get_viewport_dimensions()
	var width_scale = viewport_size.x / REFERENCE_WIDTH
	return clamp(width_scale, MIN_SCALE_FACTOR, MAX_SCALE_FACTOR)

## Get the scale factor considering both width and height
static func get_balanced_scale_factor() -> float:
	var viewport_size = get_viewport_dimensions()
	var width_scale = viewport_size.x / REFERENCE_WIDTH
	var height_scale = viewport_size.y / REFERENCE_HEIGHT
	
	# Use the smaller scale to ensure content fits
	var scale = min(width_scale, height_scale)
	return clamp(scale, MIN_SCALE_FACTOR, MAX_SCALE_FACTOR)

## Get a font size that scales smoothly with the viewport
static func get_font_size(size_category: String = "normal") -> int:
	if not FONT_SIZE_RANGES.has(size_category):
		size_category = "normal"
		
	var range_data = FONT_SIZE_RANGES[size_category]
	var min_size = range_data["min"]
	var max_size = range_data["max"]
	
	var scale = get_scale_factor()
	return int(min_size + (max_size - min_size) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR))

## Get a margin size that scales with the viewport
static func get_margin() -> int:
	var scale = get_scale_factor()
	var min_margin = MARGIN_RANGE["min"]
	var max_margin = MARGIN_RANGE["max"]
	
	return int(min_margin + (max_margin - min_margin) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR))

## Get a padding size that scales with the viewport
static func get_padding() -> int:
	var scale = get_scale_factor()
	var min_padding = PADDING_RANGE["min"]
	var max_padding = PADDING_RANGE["max"]
	
	return int(min_padding + (max_padding - min_padding) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR))

## Get a spacing size that scales with the viewport
static func get_spacing() -> int:
	var scale = get_scale_factor()
	var min_spacing = SPACING_RANGE["min"]
	var max_spacing = SPACING_RANGE["max"]
	
	return int(min_spacing + (max_spacing - min_spacing) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR))

## Get a size that scales with the viewport
static func get_min_size(component_type: String) -> Vector2:
	if not COMPONENT_SIZE_RANGES.has(component_type):
		return Vector2(100, 50)  # Default fallback size
		
	var range_data = COMPONENT_SIZE_RANGES[component_type]
	var min_size = range_data["min"]
	var max_size = range_data["max"]
	var scale = get_scale_factor()
	
	var x = min_size.x + (max_size.x - min_size.x) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR)
	var y = min_size.y + (max_size.y - min_size.y) * (scale - MIN_SCALE_FACTOR) / (MAX_SCALE_FACTOR - MIN_SCALE_FACTOR)
	
	return Vector2(x, y)

## Calculate a size as a percentage of viewport width
static func get_width_percent(percent: float) -> float:
	var viewport_size = get_viewport_dimensions()
	return viewport_size.x * (percent / 100.0)

## Calculate a size as a percentage of viewport height
static func get_height_percent(percent: float) -> float:
	var viewport_size = get_viewport_dimensions()
	return viewport_size.y * (percent / 100.0)

## Apply responsive settings to a container
static func apply_container_settings(container: Container) -> void:
	# Set spacing for box containers
	if container is BoxContainer:
		container.add_theme_constant_override("separation", get_spacing())
	
	# Set margins
	var margin = get_margin()
	container.add_theme_constant_override("margin_left", margin)
	container.add_theme_constant_override("margin_right", margin)
	container.add_theme_constant_override("margin_top", margin)
	container.add_theme_constant_override("margin_bottom", margin)
	
	# Adjust orientation for box containers in portrait mode
	if is_portrait_mode():
		# For HBoxContainers in portrait mode with more than 3 children,
		# consider switching to vertical layout
		if container is HBoxContainer and container.get_child_count() > 3:
			container.vertical = true
		elif container is GridContainer:
			# Reduce columns in portrait mode
			var current_columns = container.columns
			if current_columns > 2:
				container.columns = 2

## Apply responsive font size to a label
static func apply_font_size(label: Label, size_category: String = "normal") -> void:
	label.add_theme_font_size_override("font_size", get_font_size(size_category))

## Apply responsive font size to a button
static func apply_button_font_size(button: Button, size_category: String = "normal") -> void:
	button.add_theme_font_size_override("font_size", get_font_size(size_category))

## Apply responsive settings to a dialog
static func apply_dialog_settings(dialog: Control) -> void:
	dialog.custom_minimum_size = get_min_size("dialog")
	
	# Adjust dialog position to ensure it stays within viewport
	if dialog.visible:
		var viewport_size = get_viewport_dimensions()
		var dialog_size = dialog.size
		var dialog_pos = dialog.position
		
		# Ensure dialog is fully visible
		if dialog_pos.x + dialog_size.x > viewport_size.x:
			dialog_pos.x = viewport_size.x - dialog_size.x
		if dialog_pos.y + dialog_size.y > viewport_size.y:
			dialog_pos.y = viewport_size.y - dialog_size.y
			
		dialog.position = dialog_pos

## Apply responsive settings to a panel
static func apply_panel_settings(panel: Control) -> void:
	panel.custom_minimum_size = get_min_size("panel")

## Apply responsive settings to a tooltip
static func apply_tooltip_settings(tooltip: Control) -> void:
	tooltip.custom_minimum_size = get_min_size("tooltip")

## Apply responsive settings to a button
static func apply_button_settings(button: Button) -> void:
	button.custom_minimum_size = get_min_size("button")
	apply_button_font_size(button)

## Create a responsive viewport container that adapts to screen size changes
static func create_responsive_container(parent: Node) -> Control:
	var container = Control.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Add a script to handle viewport size changes
	var script = GDScript.new()
	script.source_code = """
extends Control

func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()

func _on_viewport_size_changed():
	for child in get_children():
		if child.has_method("apply_responsive_settings"):
			child.apply_responsive_settings()
			
	# Check if we need to adjust layout based on orientation
	var is_portrait = GUIResponsive.is_portrait_mode()
	_adjust_layout_for_orientation(is_portrait)

func _adjust_layout_for_orientation(is_portrait: bool):
	# Find containers that might need layout adjustment
	for child in get_all_children(self):
		if child is BoxContainer:
			GUIResponsive.apply_container_settings(child)
		elif child is GridContainer:
			GUIResponsive.apply_container_settings(child)

func get_all_children(node):
	var children = []
	for child in node.get_children():
		children.append(child)
		children.append_array(get_all_children(child))
	return children
"""
	script.reload()
	container.set_script(script)
	
	parent.add_child(container)
	return container

## For backward compatibility - will be deprecated
static func get_screen_size_category() -> ScreenSize:
	var viewport_size = get_viewport_dimensions()
	var width = viewport_size.x
	
	if width < SMALL_BREAKPOINT:
		return ScreenSize.SMALL
	elif width < MEDIUM_BREAKPOINT:
		return ScreenSize.MEDIUM
	elif width < LARGE_BREAKPOINT:
		return ScreenSize.LARGE
	else:
		return ScreenSize.XLARGE 