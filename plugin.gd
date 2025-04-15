extends EditorPlugin

func _enter_tree():
	# Optional: Add GUI components to creation menu
	add_custom_type("GUIPanel", "Panel", preload("res://addons/godotui_essentials/gui_panel/gui_panel.gd"), preload("res://addons/godotui_essentials/icon.svg"))

func _exit_tree():
	remove_custom_type("GUIPanel")
