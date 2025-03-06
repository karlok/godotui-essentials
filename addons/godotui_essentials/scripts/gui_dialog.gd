@tool
extends Control
class_name GUIDialog

## Customizable dialog box with title, message, buttons, and fade animations

# Signals
signal button_pressed(button_id)
signal closed

# Dialog properties
@export var title: String = "Dialog Title":
	set(value):
		title = value
		if _title_label:
			_title_label.text = value

@export var message: String = "Dialog message text.":
	set(value):
		message = value
		if _message_label:
			_message_label.text = value

@export_enum("center", "left", "right") var message_alignment: String = "center":
	set(value):
		message_alignment = value
		_update_message_alignment()

@export var auto_hide: bool = true
@export var draggable: bool = true
@export var modal: bool = true
@export var use_close_button: bool = true
@export var close_on_click_outside: bool = false

@export var min_size: Vector2 = Vector2(300, 150)
@export var title_color: Color = Color.WHITE
@export var message_color: Color = Color.WHITE

# Responsive design properties
@export var use_responsive_sizing: bool = false
@export var title_size_category: String = "large"
@export var message_size_category: String = "normal"
@export var button_size_category: String = "normal"

# Fade animation properties
@export var use_fade_animations: bool = false
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.2
@export_enum("Linear", "Ease In", "Ease Out", "Ease In Out") var fade_easing: int = 2  # Default to Ease Out

# Private variables
var _panel: Panel
var _title_label: Label
var _message_label: Label
var _button_container: HBoxContainer
var _close_button: Button
var _buttons: Dictionary = {}
var _dragging: bool = false
var _drag_start_position: Vector2
var _original_modulate: Color
var _is_closing: bool = false

func _ready():
	# Store original modulate
	_original_modulate = modulate
	
	# Set up the dialog if not already set up
	if not _panel:
		_setup_dialog()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# If fade animations are enabled, start invisible if not in editor
	if use_fade_animations and not Engine.is_editor_hint():
		modulate.a = 0.0
		
	# Hide the dialog initially if not in editor
	if not Engine.is_editor_hint():
		visible = false

func _setup_dialog() -> void:
	# Set up the control properties
	custom_minimum_size = min_size
	size_flags_horizontal = SIZE_SHRINK_CENTER
	size_flags_vertical = SIZE_SHRINK_CENTER
	
	# Handle anchors and size/position to avoid warnings
	# Store current values
	var current_size = size
	var current_position = position
	
	# If we have non-equal opposite anchors, use set_deferred for size and position
	if anchor_right != anchor_left or anchor_bottom != anchor_top:
		set_deferred("size", current_size)
		set_deferred("position", current_position)
	
	# Create the panel background
	_panel = Panel.new()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.set_deferred("size", size)
	_panel.set_deferred("position", Vector2.ZERO)
	add_child(_panel)
	
	# Create a VBox for the content
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.set_deferred("size", _panel.size)
	vbox.set_deferred("position", Vector2.ZERO)
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)
	
	# Add margins
	var margin = 10
	vbox.add_theme_constant_override("margin_left", margin)
	vbox.add_theme_constant_override("margin_right", margin)
	vbox.add_theme_constant_override("margin_top", margin)
	vbox.add_theme_constant_override("margin_bottom", margin)
	
	# Create the title bar
	var title_bar = HBoxContainer.new()
	title_bar.size_flags_horizontal = SIZE_EXPAND_FILL
	vbox.add_child(title_bar)
	
	# Add the title label
	_title_label = Label.new()
	_title_label.text = title
	_title_label.add_theme_color_override("font_color", title_color)
	_title_label.size_flags_horizontal = SIZE_EXPAND_FILL
	title_bar.add_child(_title_label)
	
	# Add the close button if needed
	if use_close_button:
		_close_button = Button.new()
		_close_button.text = "×"
		_close_button.flat = true
		_close_button.pressed.connect(_on_close_button_pressed)
		title_bar.add_child(_close_button)
	
	# Add a separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Add the message label
	_message_label = Label.new()
	_message_label.text = message
	_message_label.add_theme_color_override("font_color", message_color)
	_message_label.size_flags_horizontal = SIZE_EXPAND_FILL
	_message_label.size_flags_vertical = SIZE_EXPAND_FILL
	_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_message_label)
	_update_message_alignment()
	
	# Add the button container
	_button_container = HBoxContainer.new()
	_button_container.size_flags_horizontal = SIZE_EXPAND_FILL
	_button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_button_container.add_theme_constant_override("separation", 10)
	vbox.add_child(_button_container)
	
	# Set up input handling for dragging
	set_process_input(draggable)
	
	# Set up modal behavior
	if modal:
		# Create a modal background
		var modal_bg = ColorRect.new()
		modal_bg.name = "ModalBackground"
		modal_bg.color = Color(0, 0, 0, 0.5)
		modal_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		modal_bg.set_deferred("size", size)
		modal_bg.set_deferred("position", Vector2.ZERO)
		modal_bg.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Add the modal background before the dialog
		add_child(modal_bg)
		move_child(modal_bg, 0)
		
		if close_on_click_outside:
			modal_bg.gui_input.connect(_on_modal_bg_input)

func _input(event: InputEvent) -> void:
	if not draggable or not visible or _is_closing:
		return
		
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				# Check if the click is within the title bar
				var title_bar_rect = Rect2(_title_label.global_position, _title_label.size)
				if title_bar_rect.has_point(mouse_event.global_position):
					_dragging = true
					_drag_start_position = mouse_event.global_position - global_position
			else:
				_dragging = false
	
	elif event is InputEventMouseMotion and _dragging:
		var mouse_event = event as InputEventMouseMotion
		global_position = mouse_event.global_position - _drag_start_position

func _on_modal_bg_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close()

func _on_close_button_pressed() -> void:
	close()

func _on_button_pressed(button_id: String) -> void:
	emit_signal("button_pressed", button_id)
	
	if auto_hide:
		close()

func _update_message_alignment() -> void:
	if not _message_label:
		return
		
	match message_alignment:
		"center":
			_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		"left":
			_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		"right":
			_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

## Add a button to the dialog
func add_button(text: String, button_id: String = "") -> void:
	if not _button_container:
		return
		
	# Use the text as the ID if no ID is provided
	if button_id.is_empty():
		button_id = text
	
	# Create the button
	var button = Button.new()
	button.text = text
	button.size_flags_horizontal = SIZE_SHRINK_CENTER
	
	# Apply responsive settings if enabled
	if use_responsive_sizing:
		button.add_theme_font_size_override("font_size", GUIResponsive.get_font_size(button_size_category))
	
	# Connect the button's pressed signal
	button.pressed.connect(func(): _on_button_pressed(button_id))
	
	# Add the button to the container and dictionary
	_button_container.add_child(button)
	_buttons[button_id] = button

## Remove a button from the dialog
func remove_button(button_id: String) -> void:
	if _buttons.has(button_id):
		var button = _buttons[button_id]
		_button_container.remove_child(button)
		button.queue_free()
		_buttons.erase(button_id)

## Remove all buttons from the dialog
func clear_buttons() -> void:
	for button_id in _buttons.keys():
		remove_button(button_id)

## Show the dialog
func show_dialog() -> void:
	if not is_inside_tree():
		await ready
	
	# Center the dialog if not already visible
	if not visible:
		# Get the viewport size
		var viewport_size = get_viewport_rect().size
		
		# Center the dialog
		position = (viewport_size - size) / 2
	
	# Show with fade if enabled
	if use_fade_animations:
		fade_in()
	else:
		visible = true

## Close the dialog
func close() -> void:
	if _is_closing:
		return
		
	_is_closing = true
	
	if use_fade_animations:
		fade_out()
		await get_tree().create_timer(fade_out_duration).timeout
	
	visible = false
	_is_closing = false
	emit_signal("closed")

## Set the style of the panel
func set_panel_style(style_name: String) -> void:
	if _panel and _panel is Panel:
		var gui_panel = _panel as Panel
		if gui_panel.has_method("set_preset_style"):
			gui_panel.call("set_preset_style", style_name)

## Get a button by its ID
func get_button(button_id: String) -> Button:
	if _buttons.has(button_id):
		return _buttons[button_id]
	return null

## Apply responsive settings based on screen size
func apply_responsive_settings() -> void:
	if not use_responsive_sizing:
		return
		
	# Apply font sizes
	if _title_label:
		_title_label.add_theme_font_size_override("font_size", GUIResponsive.get_font_size(title_size_category))
	
	if _message_label:
		_message_label.add_theme_font_size_override("font_size", GUIResponsive.get_font_size(message_size_category))
	
	# Apply button font sizes
	for button in _buttons.values():
		button.add_theme_font_size_override("font_size", GUIResponsive.get_font_size(button_size_category))
	
	# Apply dialog size
	custom_minimum_size = GUIResponsive.get_min_size("dialog")
	
	# Adjust dialog position to ensure it stays within viewport
	if visible:
		var viewport_size = get_viewport_rect().size
		
		# Center the dialog if it's too big for the viewport
		if size.x > viewport_size.x or size.y > viewport_size.y:
			position = (viewport_size - size) / 2
		else:
			# Ensure the dialog stays within the viewport
			if position.x < 0:
				position.x = 0
			elif position.x + size.x > viewport_size.x:
				position.x = viewport_size.x - size.x
				
			if position.y < 0:
				position.y = 0
			elif position.y + size.y > viewport_size.y:
				position.y = viewport_size.y - size.y

## Fade in the dialog
func fade_in(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		visible = true
		return
		
	if duration < 0:
		duration = fade_in_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_in(self, duration, easing, delay)

## Fade out the dialog
func fade_out(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		return
		
	if duration < 0:
		duration = fade_out_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_out(self, duration, easing, delay, false)  # Don't hide, we'll handle that in close()

## Create a simple confirmation dialog
static func create_confirmation(parent: Node, title: String, message: String, ok_text: String = "OK", cancel_text: String = "Cancel") -> GUIDialog:
	var dialog = preload("res://addons/godotui_essentials/components/gui_dialog.tscn").instantiate()
	dialog.title = title
	dialog.message = message
	dialog.add_button(ok_text, "ok")
	dialog.add_button(cancel_text, "cancel")
	parent.add_child(dialog)
	return dialog 