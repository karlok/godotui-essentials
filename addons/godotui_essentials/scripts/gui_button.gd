@tool
extends Button
class_name GUIButton

## Enhanced button with hover effects, sound support, and fade animations

# Signals
signal hover_started
signal hover_ended

# Hover effect properties
@export var use_hover_effect: bool = true
@export var hover_tint: Color = Color(1.2, 1.2, 1.2, 1.0)
@export var hover_scale: float = 1.05
@export var transition_duration: float = 0.15

# Sound properties
@export var use_sounds: bool = false
@export var hover_sound: AudioStream
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
var _original_scale: Vector2
var _original_modulate: Color
var _hover_tween: Tween
var _audio_player: AudioStreamPlayer

func _ready():
	# Initialize properties
	_original_scale = scale
	_original_modulate = modulate
	
	# Handle anchors and size/position to avoid warnings
	# Store current values
	var current_size = size
	var current_position = position
	
	# If we have non-equal opposite anchors, use set_deferred for size and position
	if anchor_right != anchor_left or anchor_bottom != anchor_top:
		set_deferred("size", current_size)
		set_deferred("position", current_position)
	
	# Connect signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	
	# Create audio player if sounds are enabled
	if use_sounds and (hover_sound != null or click_sound != null):
		_setup_audio_player()
	
	# Apply responsive settings if enabled
	if use_responsive_sizing and not Engine.is_editor_hint():
		apply_responsive_settings()
		get_tree().root.size_changed.connect(apply_responsive_settings)
	
	# If fade animations are enabled, start invisible if not in editor
	if use_fade_animations and not Engine.is_editor_hint():
		modulate.a = 0.0

## Set both hover and click sounds at once
func set_sounds(hover: AudioStream, click: AudioStream) -> void:
	hover_sound = hover
	click_sound = click
	use_sounds = true
	
	if not _audio_player:
		_setup_audio_player()

## Disable all visual and sound effects
func disable_effects() -> void:
	use_hover_effect = false
	use_sounds = false

## Apply responsive settings based on screen size
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
		visible = true
		return
		
	if duration < 0:
		duration = fade_in_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_in(self, duration, easing, delay)

## Fade out the button
func fade_out(duration: float = -1.0, delay: float = 0.0, hide_when_done: bool = true) -> void:
	if not use_fade_animations:
		if hide_when_done:
			visible = false
		return
		
	if duration < 0:
		duration = fade_out_duration
		
	var easing = GUIFadeAnimation.EasingType.values()[fade_easing]
	GUIFadeAnimation.fade_out(self, duration, easing, delay, hide_when_done)

## Show the button with fade if enabled
func show_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_in(duration, delay)

## Hide the button with fade if enabled
func hide_with_fade(duration: float = -1.0, delay: float = 0.0) -> void:
	fade_out(duration, delay)

# Private methods
func _setup_audio_player() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "UI" if AudioServer.get_bus_index("UI") >= 0 else "Master"
	add_child(_audio_player)

func _on_mouse_entered() -> void:
	if not use_hover_effect:
		return
		
	# Cancel any existing tween
	if _hover_tween and _hover_tween.is_valid():
		_hover_tween.kill()
		
	# Create a new tween for hover effect
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	_hover_tween.set_ease(Tween.EASE_OUT)
	_hover_tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animate scale and color
	_hover_tween.tween_property(self, "scale", _original_scale * hover_scale, transition_duration)
	_hover_tween.tween_property(self, "modulate", _original_modulate * hover_tint, transition_duration)
	
	# Play hover sound if enabled
	if use_sounds and hover_sound and _audio_player:
		_audio_player.stream = hover_sound
		_audio_player.play()
		
	emit_signal("hover_started")

func _on_mouse_exited() -> void:
	if not use_hover_effect:
		return
		
	# Cancel any existing tween
	if _hover_tween and _hover_tween.is_valid():
		_hover_tween.kill()
		
	# Create a new tween for hover effect
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	_hover_tween.set_ease(Tween.EASE_OUT)
	_hover_tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animate back to original scale and color
	_hover_tween.tween_property(self, "scale", _original_scale, transition_duration)
	_hover_tween.tween_property(self, "modulate", _original_modulate, transition_duration)
	
	emit_signal("hover_ended")

func _on_pressed() -> void:
	# Play click sound if enabled
	if use_sounds and click_sound and _audio_player:
		_audio_player.stream = click_sound
		_audio_player.play() 