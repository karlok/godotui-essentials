extends Panel
class_name GUIPanel

@onready var content := $MarginContainer/Content

var _style := StyleBoxFlat.new()

func _ready():
	# Ensure this panel stretches to almost fill its parent
	anchor_left = 0.1
	anchor_top = 0.1
	anchor_right = 0.9
	anchor_bottom = 0.9
	#set_background_color(background_color)

func set_background_color(color: Color) -> void:
	_style.bg_color = color
	add_theme_stylebox_override("panel", _style)
	
func set_border_style(color: Color, width: int) -> void:
	_style.border_color = color
	_style.set_border_width_all(width)
	add_theme_stylebox_override("panel", _style)

func add_label(text: String) -> Label:
	var label = _GUIPaths.GUILabelScene.instantiate()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.custom_minimum_size.x = 300  # Keeps it from shrinking too much
	label.text = text
	content.add_child(label)
	return label

func add_button(text: String, callback: Callable = Callable()) -> Button:
	var button = _GUIPaths.GUIButtonScene.instantiate()
	button.custom_minimum_size.x = 200
	button.text = text
	if callback.is_valid():
		button.pressed.connect(callback)
	content.add_child(button)
	return button
