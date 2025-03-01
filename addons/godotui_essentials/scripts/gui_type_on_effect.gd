@tool
extends Node
class_name GUITypeOnEffect

## Utility class for creating typewriter/type-on effects for text elements
##
## Note: While this class is registered as an autoload singleton for convenience,
## it's designed to be instantiated multiple times - once for each text element
## that needs a typing effect. Use the create_for_label() and create_for_rich_label()
## static methods to create instances for specific text elements.

# Default typing settings
const DEFAULT_TYPING_SPEED = 0.05  # seconds per character
const DEFAULT_PUNCTUATION_PAUSE = 0.2  # additional pause for punctuation

# Sound settings
const DEFAULT_SOUND_FREQUENCY = 3  # play sound every N characters

## Signals
signal typing_started
signal typing_completed
signal character_typed(character, index)

## Properties
@export var target_node: Control  # Label or RichTextLabel
@export var typing_speed: float = DEFAULT_TYPING_SPEED
@export var punctuation_pause: float = DEFAULT_PUNCTUATION_PAUSE
@export var play_sound: bool = false
@export var typing_sound: AudioStream
@export var sound_frequency: int = DEFAULT_SOUND_FREQUENCY
@export_enum("Normal", "Random Variance", "Accelerating", "Decelerating") var typing_style: int = 0

# Private variables
var _original_text: String = ""
var _displayed_text: String = ""
var _current_index: int = 0
var _typing_timer: Timer
var _audio_player: AudioStreamPlayer
var _is_typing: bool = false
var _punctuation_chars = ['.', ',', '!', '?', ':', ';', '-']
var _random = RandomNumberGenerator.new()

func _ready():
	# Initialize the timer
	_typing_timer = Timer.new()
	_typing_timer.one_shot = true
	_typing_timer.timeout.connect(_type_next_character)
	add_child(_typing_timer)
	
	# Initialize audio player if needed
	if play_sound and typing_sound != null:
		_setup_audio_player()
	
	# Initialize random number generator
	_random.randomize()

## Start the typing effect
func start_typing(text: String = "") -> void:
	# If already typing, stop first
	if _is_typing:
		stop_typing()
	
	# If no target node, can't type
	if not target_node:
		push_error("GUITypeOnEffect: No target node set")
		return
	
	# If text is empty, use the target's current text
	if text.is_empty():
		if target_node is Label:
			_original_text = target_node.text
		elif target_node is RichTextLabel:
			_original_text = target_node.text
		else:
			push_error("GUITypeOnEffect: Target node must be Label or RichTextLabel")
			return
	else:
		_original_text = text
	
	# Reset variables
	_displayed_text = ""
	_current_index = 0
	_is_typing = true
	
	# Clear the target text
	if target_node is Label:
		target_node.text = ""
	elif target_node is RichTextLabel:
		target_node.text = ""
	
	# Start typing
	emit_signal("typing_started")
	_type_next_character()

## Stop the typing effect immediately
func stop_typing() -> void:
	if not _is_typing:
		return
	
	_is_typing = false
	_typing_timer.stop()
	
	# Show the full text
	if target_node:
		if target_node is Label:
			target_node.text = _original_text
		elif target_node is RichTextLabel:
			target_node.text = _original_text

## Skip to the end of the typing effect
func skip_to_end() -> void:
	if not _is_typing:
		return
	
	_is_typing = false
	_typing_timer.stop()
	
	# Show the full text
	if target_node:
		if target_node is Label:
			target_node.text = _original_text
		elif target_node is RichTextLabel:
			target_node.text = _original_text
	
	emit_signal("typing_completed")

## Check if currently typing
func is_typing() -> bool:
	return _is_typing

## Set the typing speed
func set_typing_speed(speed: float) -> void:
	typing_speed = max(0.01, speed)  # Ensure minimum speed

## Set the typing sound
func set_typing_sound(sound: AudioStream) -> void:
	typing_sound = sound
	play_sound = sound != null
	
	if play_sound and not _audio_player and typing_sound:
		_setup_audio_player()

# Private methods
func _setup_audio_player() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "UI" if AudioServer.get_bus_index("UI") >= 0 else "Master"
	_audio_player.stream = typing_sound
	add_child(_audio_player)

func _type_next_character() -> void:
	if not _is_typing or not target_node:
		return
	
	if _current_index >= _original_text.length():
		# Typing completed
		_is_typing = false
		emit_signal("typing_completed")
		return
	
	# Get the next character
	var next_char = _original_text[_current_index]
	_displayed_text += next_char
	
	# Update the text in the target node
	if target_node is Label:
		target_node.text = _displayed_text
	elif target_node is RichTextLabel:
		target_node.text = _displayed_text
	
	# Emit signal for the typed character
	emit_signal("character_typed", next_char, _current_index)
	
	# Play sound if enabled
	if play_sound and _audio_player and _current_index % sound_frequency == 0:
		_audio_player.pitch_scale = _random.randf_range(0.9, 1.1)  # Slight pitch variation
		_audio_player.play()
	
	# Increment index
	_current_index += 1
	
	# Calculate delay for next character
	var delay = typing_speed
	
	# Apply typing style variations
	match typing_style:
		0:  # Normal
			pass
		1:  # Random Variance
			delay = typing_speed * _random.randf_range(0.7, 1.3)
		2:  # Accelerating
			var progress = float(_current_index) / _original_text.length()
			delay = typing_speed * (1.0 - progress * 0.5)  # Speed up to 50% faster
		3:  # Decelerating
			var progress = float(_current_index) / _original_text.length()
			delay = typing_speed * (1.0 + progress * 0.5)  # Slow down to 50% slower
	
	# Add pause for punctuation
	if _current_index < _original_text.length() and next_char in _punctuation_chars:
		delay += punctuation_pause
	
	# Schedule next character
	_typing_timer.start(delay)

## Create a type-on effect for a Label
static func create_for_label(label: Label, speed: float = DEFAULT_TYPING_SPEED) -> GUITypeOnEffect:
	var effect = GUITypeOnEffect.new()
	effect.target_node = label
	effect.typing_speed = speed
	label.add_child(effect)
	return effect

## Create a type-on effect for a RichTextLabel
static func create_for_rich_label(rich_label: RichTextLabel, speed: float = DEFAULT_TYPING_SPEED) -> GUITypeOnEffect:
	var effect = GUITypeOnEffect.new()
	effect.target_node = rich_label
	effect.typing_speed = speed
	rich_label.add_child(effect)
	return effect 