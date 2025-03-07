@tool
extends Button
class_name GUIButton

## Mobile-friendly button with focus handling and fade animations

# Focus properties
@export var use_custom_focus: bool = true
@export var disable_focus_visual: bool = true

# Sound properties
@export var use_sounds: bool = false
@export var click_sound: AudioStream

# Responsive design properties
@export var use_responsive_sizing: bool = false
@export var font_size_category: String = "normal"

# Fade animation properties
@export var use_fade_animations: bool = false
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.2
@export_enum("Linear", "Ease In", "Ease Out", "Ease In Out") var fade_easing: int = 2  # Default to Ease Out

# Private variables
var _original_modulate: Color
var _audio_player: AudioStreamPlayer
var _custom_stylebox: StyleBoxFlat

func _enter_tree() -> void:
	# This is crucial for proper serialization in the editor
	if Engine.is_editor_hint():
		# Make sure we're properly set as a child of our parent
		if get_parent() and not is_node_ready():
			# Ensure we're properly owned by the scene root
			if get_parent().owner and self.owner != get_parent().owner:
				self.owner = get_parent().owner

func _ready() -> void:
	# Initialize properties
	_original_modulate = modulate
	
	# Handle anchors and size/position to avoid warnings
	# Store current values
	var current_size = size
	var current_position = position
	
	# If we have non-equal opposite anchors, use set_deferred for size and position
	if anchor_right != anchor_left or anchor_bottom != anchor_top:
		set_deferred("size", current_size)
		set_deferred("position", current_position)
	
	# Set up focus handling
	if use_custom_focus:
		if disable_focus_visual:
			# Option 1: Disable focus completely
			focus_mode = Control.FOCUS_NONE
		else:
			# Option 2: Use a custom focus style
			_setup_custom_focus_style()
			
			# Connect focus signals
			focus_entered.connect(_on_focus_entered)
			focus_exited.connect(_on_focus_exited)
	
	# Connect signals
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	
	# Create audio player if sounds are enabled
	if use_sounds and click_sound != null:
		_setup_audio_player()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		if not get_tree().root.size_changed.is_connected(apply_responsive_settings):
			get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# If fade animations are enabled, start invisible if not in editor
	if use_fade_animations and not Engine.is_editor_hint():
		modulate.a = 0.0

## Set up a custom focus style
func _setup_custom_focus_style() -> void:
	# Create a custom stylebox for focus
	_custom_stylebox = StyleBoxFlat.new()
	_custom_stylebox.bg_color = Color(0, 0, 0, 0)  # Transparent background
	_custom_stylebox.border_width_left = 0
	_custom_stylebox.border_width_top = 0
	_custom_stylebox.border_width_right = 0
	_custom_stylebox.border_width_bottom = 0
	
	# Apply the custom focus style
	add_theme_stylebox_override("focus", _custom_stylebox)

## Handle focus entered
func _on_focus_entered() -> void:
	if use_custom_focus and not disable_focus_visual:
		# Apply custom focus visual here if needed
		pass

## Handle focus exited
func _on_focus_exited() -> void:
	if use_custom_focus and not disable_focus_visual:
		# Remove custom focus visual here if needed
		pass

## Set click sound
func set_click_sound(sound: AudioStream) -> void:
	click_sound = sound
	use_sounds = true
	
	if not _audio_player:
		_setup_audio_player()

## Apply responsive settings based on viewport size
func apply_responsive_settings() -> void:
	if not use_responsive_sizing:
		return
		
	# Apply font size
	add_theme_font_size_override("font_size", GUIResponsive.get_font_size(font_size_category))
	
	# Apply minimum size
	custom_minimum_size = GUIResponsive.get_min_size("button")

## Fade in the button
func fade_in(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		modulate.a = 1.0
		return
		
	if duration < 0:
		duration = fade_in_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_in(self, duration, easing, delay)

## Fade out the button
func fade_out(duration: float = -1.0, delay: float = 0.0) -> void:
	if not use_fade_animations:
		modulate.a = 0.0
		return
		
	if duration < 0:
		duration = fade_out_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_out(self, duration, easing, delay)

## Show the button with fade if enabled
func show_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_in(duration, delay)

## Hide the button with fade if enabled
func hide_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_out(duration, delay)

# Private methods
func _setup_audio_player() -> void:
	# Check if we already have an audio player
	if _audio_player:
		return
		
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "UI" if AudioServer.get_bus_index("UI") >= 0 else "Master"
	add_child(_audio_player)
	
	# This is crucial for proper serialization
	if Engine.is_editor_hint() and owner:
		_audio_player.owner = owner

func _on_pressed() -> void:
	# Play click sound if enabled
	if use_sounds and click_sound and _audio_player:
		_audio_player.stream = click_sound
		_audio_player.play()

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