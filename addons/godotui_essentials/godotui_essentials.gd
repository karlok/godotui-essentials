@tool
extends EditorPlugin

const GodotUIPaths = preload("res://addons/godotui_essentials/scripts/godotui_paths.gd")

func _enter_tree():
	# Register autoload singletons
	add_autoload_singleton("GodotUIPaths", GodotUIPaths.SCRIPTS_PATH + "/godotui_paths.gd")
	add_autoload_singleton("GUIResponsive", GodotUIPaths.RESPONSIVE_SCRIPT)
	add_autoload_singleton("GUIFadeAnimation", GodotUIPaths.FADE_ANIMATION_SCRIPT)
	
	# Note: GUITypeOnEffect is registered as an autoload primarily for convenience -
	# it makes the class globally accessible without having to preload it every time.
	# Unlike other singletons, it's designed to be instantiated multiple times (once per text element).
	add_autoload_singleton("GUITypeOnEffect", GodotUIPaths.TYPE_ON_EFFECT_SCRIPT)
	
	# Register custom types
	add_custom_type("GUIButton", "Button", preload(GodotUIPaths.BUTTON_SCRIPT), preload(GodotUIPaths.BUTTON_ICON))
	add_custom_type("GUIPanel", "Panel", preload(GodotUIPaths.PANEL_SCRIPT), preload(GodotUIPaths.PANEL_ICON))
	add_custom_type("GUIDialog", "Control", preload(GodotUIPaths.DIALOG_SCRIPT), preload(GodotUIPaths.DIALOG_ICON))
	add_custom_type("GUITooltip", "Control", preload(GodotUIPaths.TOOLTIP_SCRIPT), preload(GodotUIPaths.TOOLTIP_ICON))

func _exit_tree():
	# Remove autoload singletons
	remove_autoload_singleton("GodotUIPaths")
	remove_autoload_singleton("GUIResponsive")
	remove_autoload_singleton("GUIFadeAnimation")
	remove_autoload_singleton("GUITypeOnEffect")
	
	# Remove custom types
	remove_custom_type("GUIButton")
	remove_custom_type("GUIPanel")
	remove_custom_type("GUIDialog")
	remove_custom_type("GUITooltip") 