@tool
extends EditorPlugin

# Preload the GUIPaths script to access paths
var GUIPaths = preload("res://addons/godotui_essentials/scripts/gui_paths.gd")

func _enter_tree() -> void:
	# Register autoload singletons with different names to avoid conflicts with class_name
	add_autoload_singleton("GUIPathsSingleton", "res://addons/godotui_essentials/scripts/gui_paths.gd")
	add_autoload_singleton("GUIResponsiveSingleton", "res://addons/godotui_essentials/scripts/gui_responsive.gd")
	add_autoload_singleton("GUIFadeAnimationSingleton", "res://addons/godotui_essentials/scripts/gui_fade_animation.gd")
	add_autoload_singleton("GUITypeOnEffectSingleton", "res://addons/godotui_essentials/scripts/gui_type_on_effect.gd")
	
	# Register custom types
	add_custom_type("GUIButton", "Button", preload("res://addons/godotui_essentials/scripts/gui_button.gd"), preload("res://addons/godotui_essentials/art/button_icon.svg"))
	add_custom_type("GUIPanel", "Panel", preload("res://addons/godotui_essentials/scripts/gui_panel.gd"), preload("res://addons/godotui_essentials/art/panel_icon.svg"))
	add_custom_type("GUIDialog", "Control", preload("res://addons/godotui_essentials/scripts/gui_dialog.gd"), preload("res://addons/godotui_essentials/art/dialog_icon.svg"))

func _exit_tree() -> void:
	# Remove autoload singletons
	remove_autoload_singleton("GUIPathsSingleton")
	remove_autoload_singleton("GUIResponsiveSingleton")
	remove_autoload_singleton("GUIFadeAnimationSingleton")
	remove_autoload_singleton("GUITypeOnEffectSingleton")
	
	# Remove custom types
	remove_custom_type("GUIButton")
	remove_custom_type("GUIPanel")
	remove_custom_type("GUIDialog") 