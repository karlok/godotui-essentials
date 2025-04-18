extends ProgressBar
class_name GUIBar

@export var bar_color: Color = Color.RED
@export var background_color: Color = Color.DARK_GRAY

func _ready():
	await get_tree().process_frame

	min_value = 0
	max_value = 100
	value = 75  # Use less than 100 so we actually *see* the progress fill

	var bg = StyleBoxFlat.new()
	bg.bg_color = background_color
	bg.border_color = Color.BLACK
	bg.draw_center = true
	bg.set_border_width_all(2)
	bg.set_content_margin_all(4)

	var fg = StyleBoxFlat.new()
	fg.bg_color = bar_color
	fg.draw_center = true
	fg.set_content_margin_all(2)

	# ✅ Here's the trick — use `add_theme_stylebox_override`, NOT `set()`
	add_theme_stylebox_override("background", bg)
	add_theme_stylebox_override("fill", fg)  # ✅ Use `"fill"` not `"progress"` in Godot 4.x

	print("✅ GUIBar style applied | fill:", fg.bg_color, ", bg:", bg.bg_color)
