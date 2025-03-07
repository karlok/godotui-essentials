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

# Button properties
@export var buttons: Array[String] = ["OK"]
@export var button_ids: Array[int] = [0]
@export var default_button: int = 0
@export var cancel_button: int = -1

# Private variables
var _panel: Panel
var _title_label: Label
var _message_label: Label
var _close_button: Button
var _button_container: HBoxContainer
var _buttons: Array[Button] = []
var _drag_position: Vector2
var _dragging: bool = false
var _original_modulate: Color
var _is_closing: bool = false

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
	
	# Set up the dialog
	_setup_dialog()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		if not get_tree().root.size_changed.is_connected(apply_responsive_settings):
			get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# If fade animations are enabled, start invisible if not in editor
	if use_fade_animations and not Engine.is_editor_hint():
		modulate.a = 0.0
	
	# Set up modal behavior
	if modal:
		# Create a modal background if needed
		if not get_parent() or not get_parent().has_node("ModalBackground"):
			var modal_bg = ColorRect.new()
			modal_bg.name = "ModalBackground"
			modal_bg.color = Color(0, 0, 0, 0.5)
			modal_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
			
			if get_parent():
				get_parent().add_child(modal_bg)
				get_parent().move_child(modal_bg, get_index())
				
				# This is crucial for proper serialization
				if Engine.is_editor_hint() and get_parent().owner:
					modal_bg.owner = get_parent().owner
			else:
				add_sibling(modal_bg)
				
				# This is crucial for proper serialization
				if Engine.is_editor_hint() and owner:
					modal_bg.owner = owner
			
			# Connect click outside if needed
			if close_on_click_outside:
				modal_bg.gui_input.connect(_on_modal_bg_gui_input)

func _setup_dialog():
	# Set minimum size
	custom_minimum_size = min_size
	
	# Create the panel background
	_panel = Panel.new()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.set_deferred("size", size)
	_panel.set_deferred("position", Vector2.ZERO)
	add_child(_panel)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		_panel.owner = owner
	
	# Create a VBox for the content
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.set_deferred("size", _panel.size)
	vbox.set_deferred("position", Vector2.ZERO)
	vbox.add_theme_constant_override("separation", 10)
	_panel.add_child(vbox)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		vbox.owner = owner
	
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
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		title_bar.owner = owner
	
	# Add the title label
	_title_label = Label.new()
	_title_label.text = title
	_title_label.add_theme_color_override("font_color", title_color)
	_title_label.size_flags_horizontal = SIZE_EXPAND_FILL
	title_bar.add_child(_title_label)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		_title_label.owner = owner
	
	# Add the close button if needed
	if use_close_button:
		_close_button = Button.new()
		_close_button.text = "×"
		_close_button.flat = true
		_close_button.pressed.connect(_on_close_button_pressed)
		title_bar.add_child(_close_button)
		
		# This is crucial for proper serialization
		if Engine.is_editor_hint() and owner:
			_close_button.owner = owner
	
	# Add a separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		separator.owner = owner
	
	# Add the message label
	_message_label = Label.new()
	_message_label.text = message
	_message_label.add_theme_color_override("font_color", message_color)
	_message_label.size_flags_horizontal = SIZE_EXPAND_FILL
	_message_label.size_flags_vertical = SIZE_EXPAND_FILL
	_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_message_label)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		_message_label.owner = owner
	
	# Update message alignment
	_update_message_alignment()
	
	# Add button container
	_button_container = HBoxContainer.new()
	_button_container.size_flags_horizontal = SIZE_EXPAND_FILL
	_button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_button_container.add_theme_constant_override("separation", 10)
	vbox.add_child(_button_container)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		_button_container.owner = owner
	
	# Add buttons
	_create_buttons()
	
	# Set up dragging if enabled
	if draggable:
		title_bar.mouse_entered.connect(_on_title_bar_mouse_entered)
		title_bar.mouse_exited.connect(_on_title_bar_mouse_exited)
		title_bar.gui_input.connect(_on_title_bar_gui_input)

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
					_drag_position = mouse_event.global_position - global_position
			else:
				_dragging = false
	
	elif event is InputEventMouseMotion and _dragging:
		var mouse_event = event as InputEventMouseMotion
		global_position = mouse_event.global_position - _drag_position

func _on_modal_bg_gui_input(event: InputEvent) -> void:
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

func _create_buttons():
	# Clear existing buttons
	for button in _buttons:
		button.queue_free()
	_buttons.clear()
	
	# Create new buttons
	for i in range(buttons.size()):
		var button = Button.new()
		button.text = buttons[i]
		button.pressed.connect(_on_button_pressed.bind(button_ids[i]))
		_button_container.add_child(button)
		_buttons.append(button)
		
		# This is crucial for proper serialization
		if Engine.is_editor_hint() and owner:
			button.owner = owner
		
		# Set default button
		if button_ids[i] == default_button:
			button.grab_focus()

func apply_responsive_settings():
	if not use_responsive_sizing:
		return
		
	# Apply font sizes
	if _title_label:
		_title_label.add_theme_font_size_override("font_size", GUIResponsiveSingleton.get_font_size(title_size_category))
	
	if _message_label:
		_message_label.add_theme_font_size_override("font_size", GUIResponsiveSingleton.get_font_size(message_size_category))
	
	# Apply to buttons
	for button in _buttons:
		button.add_theme_font_size_override("font_size", GUIResponsiveSingleton.get_font_size(button_size_category))

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