@tool
extends Node
class_name GUIFadeAnimation

## Utility class for fade-in/fade-out animations on UI components

# Default fade durations
const DEFAULT_FADE_IN_DURATION = 0.3
const DEFAULT_FADE_OUT_DURATION = 0.2

# Easing types
enum EasingType {
	LINEAR,
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT
}

## Fade in a control node
static func fade_in(control: Control, duration: float = DEFAULT_FADE_IN_DURATION, easing: EasingType = EasingType.EASE_OUT, delay: float = 0.0) -> void:
	if not control:
		return
		
	# Store original modulate for later use
	if not control.has_meta("original_modulate"):
		control.set_meta("original_modulate", control.modulate)
	
	var original_modulate = control.get_meta("original_modulate")
	
	# Make sure the control is visible but transparent
	control.modulate.a = 0.0
	control.visible = true
	
	# Create and configure the tween
	var tween = control.create_tween()
	tween.set_ease(_get_ease_type(easing))
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Add delay if specified
	if delay > 0:
		tween.tween_interval(delay)
	
	# Animate the alpha value
	var target_modulate = original_modulate
	tween.tween_property(control, "modulate", target_modulate, duration)

## Fade out a control node
static func fade_out(control: Control, duration: float = DEFAULT_FADE_OUT_DURATION, easing: EasingType = EasingType.EASE_IN, delay: float = 0.0, hide_when_done: bool = true) -> void:
	if not control or not control.visible:
		return
		
	# Store original modulate if not already stored
	if not control.has_meta("original_modulate"):
		control.set_meta("original_modulate", control.modulate)
	
	# Create and configure the tween
	var tween = control.create_tween()
	tween.set_ease(_get_ease_type(easing))
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Add delay if specified
	if delay > 0:
		tween.tween_interval(delay)
	
	# Animate the alpha value
	var target_modulate = control.modulate
	target_modulate.a = 0.0
	tween.tween_property(control, "modulate", target_modulate, duration)
	
	# Hide the control when the animation is done
	if hide_when_done:
		tween.tween_callback(func(): control.visible = false)

## Create a fade-in animation and return the tween (for more control)
static func create_fade_in_tween(control: Control, duration: float = DEFAULT_FADE_IN_DURATION, easing: EasingType = EasingType.EASE_OUT) -> Tween:
	if not control:
		return null
		
	# Store original modulate for later use
	if not control.has_meta("original_modulate"):
		control.set_meta("original_modulate", control.modulate)
	
	var original_modulate = control.get_meta("original_modulate")
	
	# Make sure the control is visible but transparent
	control.modulate.a = 0.0
	control.visible = true
	
	# Create and configure the tween
	var tween = control.create_tween()
	tween.set_ease(_get_ease_type(easing))
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animate the alpha value
	var target_modulate = original_modulate
	tween.tween_property(control, "modulate", target_modulate, duration)
	
	return tween

## Create a fade-out animation and return the tween (for more control)
static func create_fade_out_tween(control: Control, duration: float = DEFAULT_FADE_OUT_DURATION, easing: EasingType = EasingType.EASE_IN) -> Tween:
	if not control or not control.visible:
		return null
		
	# Store original modulate if not already stored
	if not control.has_meta("original_modulate"):
		control.set_meta("original_modulate", control.modulate)
	
	# Create and configure the tween
	var tween = control.create_tween()
	tween.set_ease(_get_ease_type(easing))
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animate the alpha value
	var target_modulate = control.modulate
	target_modulate.a = 0.0
	tween.tween_property(control, "modulate", target_modulate, duration)
	
	return tween

## Convert our easing type enum to Tween.EASE_* constants
static func _get_ease_type(easing: EasingType) -> int:
	match easing:
		EasingType.LINEAR:
			return Tween.EASE_IN_OUT  # Linear is actually EASE_IN_OUT with TRANS_LINEAR
		EasingType.EASE_IN:
			return Tween.EASE_IN
		EasingType.EASE_OUT:
			return Tween.EASE_OUT
		EasingType.EASE_IN_OUT:
			return Tween.EASE_IN_OUT
		_:
			return Tween.EASE_IN_OUT 