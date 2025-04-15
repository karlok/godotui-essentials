extends Panel
class_name GUIPanel

@onready var content := $MarginContainer/Content

@export var background_color: Color = Color(0.1, 0.1, 0.1, 0.8) : set = set_background_color

func _ready():
	# Ensure this panel stretches to almost fill its parent
	anchor_left = 0.1
	anchor_top = 0.1
	anchor_right = 0.9
	anchor_bottom = 0.9
	set_background_color(background_color)

func set_background_color(color: Color) -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	add_theme_stylebox_override("panel", style)

func add_label(text: String) -> Label:
	var label = _GUIPaths.GUILabelScene.instantiate()
	label.text = text
	content.add_child(label)
	return label

func add_button(text: String, callback: Callable = Callable()) -> Button:
	var button = _GUIPaths.GUIButtonScene.instantiate()
	button.text = text
	if callback.is_valid():
		button.pressed.connect(callback)
	content.add_child(button)
	return button
