extends ProgressBar
class_name GUIBar

@export var bar_color: Color = Color.RED
@export var background_color: Color = Color.DARK_GRAY

func _ready():
	await get_tree().process_frame

	min_value = 0
	max_value = 100
	value = 100

	var bg = StyleBoxFlat.new()
	bg.bg_color = background_color
	bg.border_color = Color.BLACK
	bg.draw_center = true
	bg.set_border_width_all(2)

	var fg = StyleBoxFlat.new()
	fg.bg_color = bar_color
	fg.draw_center = true
	fg.set_expand_margin_all(-min(2, size.y * 0.1))  # Shrinks the visual fill inside

	# ✅ Here's the trick — use `add_theme_stylebox_override`, NOT `set()`
	add_theme_stylebox_override("background", bg)
	add_theme_stylebox_override("fill", fg)  # ✅ Use `"fill"` not `"progress"` in Godot 4.x

	self.clip_contents = true

func set_fill_color(color: Color):
	if has_theme_stylebox_override("fill"):
		var stylebox = get_theme_stylebox("fill") as StyleBoxFlat
		if stylebox:
			stylebox.bg_color = color
			add_theme_stylebox_override("fill", stylebox)
