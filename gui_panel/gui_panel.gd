extends Panel
class_name GUIPanel

@onready var content := $MarginContainer/Content

var _style := StyleBoxFlat.new()

enum SlideDirection { LEFT, RIGHT, TOP, BOTTOM }

func _ready():
	if !has_node("Content"):
		push_warning("GUIPanel is missing a 'Content' node. Add a VBoxContainer named 'Content' in the scene.")
		
	# Ensure this panel stretches to almost fill its parent
	anchor_left = 0.1
	anchor_top = 0.1
	anchor_right = 0.9
	anchor_bottom = 0.9

func set_background_color(color: Color) -> void:
	_style.bg_color = color
	add_theme_stylebox_override("panel", _style)
	
func set_border_style(color: Color, width: int) -> void:
	_style.border_color = color
	_style.set_border_width_all(width)
	add_theme_stylebox_override("panel", _style)

func show_panel():
	show()
	modulate.a = 1.0

func hide_panel():
	hide()

func fade_in(duration := 0.5):
	modulate.a = 0
	show()
	create_tween().tween_property(self, "modulate:a", 1.0, duration)

func fade_out(duration := 0.5):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(hide)

func slide_in_from(direction: SlideDirection, distance := 100, duration := 0.5):
	var offset = _get_slide_vector(direction, distance)
	position += offset
	show()
	create_tween().tween_property(self, "position", position - offset, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func slide_out_to(direction: SlideDirection, distance := 100, duration := 0.5):
	var offset = _get_slide_vector(direction, distance)
	var tween = create_tween()
	tween.tween_property(self, "position", position + offset, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(hide)

func _get_slide_vector(direction: SlideDirection, distance: float) -> Vector2:
	match direction:
		SlideDirection.LEFT: return Vector2(-distance, 0)
		SlideDirection.RIGHT: return Vector2(distance, 0)
		SlideDirection.TOP: return Vector2(0, -distance)
		SlideDirection.BOTTOM: return Vector2(0, distance)
	return Vector2.ZERO
	
### --- add ui elements
func add_label(text: String) -> Label:
	if !is_instance_valid(content):
		push_warning("GUIPanel: Missing 'Content' node. Make sure your panel scene has a VBoxContainer named 'Content'.")
		return Label.new()
		
	var label = _GUIPaths.GUILabelScene.instantiate()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.custom_minimum_size.x = 300  # Keeps it from shrinking too much
	label.text = text
	content.add_child(label)
	return label

func add_button(text: String, callback: Callable = Callable()) -> Button:
	if !is_instance_valid(content):
		push_warning("GUIPanel: Missing 'Content' node. Make sure your panel scene has a VBoxContainer named 'Content'.")
		return Button.new()
		
	var button = _GUIPaths.GUIButtonScene.instantiate()
	button.custom_minimum_size.x = 200
	button.text = text
	if callback.is_valid():
		button.pressed.connect(callback)
	content.add_child(button)
	return button
