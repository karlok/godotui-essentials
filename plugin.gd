@tool
extends EditorPlugin

func _enter_tree():
	print("✅ GUI Essentials plugin loaded.")
	# Optional: Add GUI components to creation menu
	add_custom_type("GUIPanel", "Panel", preload("res://addons/gui_essentials/gui_panel/gui_panel.gd"), preload("res://addons/gui_essentials/icon.svg"))
	
func _exit_tree():
	print("🛑 GUI Essentials plugin unloaded.")
	remove_custom_type("GUIPanel")
