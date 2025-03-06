@tool
extends EditorPlugin

const GUIPaths = preload("res://addons/godotui_essentials/scripts/gui_paths.gd")

func _enter_tree():
	# Register autoload singletons
	add_autoload_singleton("GUIPaths", GUIPaths.SCRIPTS_PATH + "/gui_paths.gd")
	add_autoload_singleton("GUIResponsive", GUIPaths.RESPONSIVE_SCRIPT)
	add_autoload_singleton("GUIFadeAnimation", GUIPaths.FADE_ANIMATION_SCRIPT)
	
	# Note: GUITypeOnEffect is registered as an autoload primarily for convenience -
	# it makes the class globally accessible without having to preload it every time.
	# Unlike other singletons, it's designed to be instantiated multiple times (once per text element).
	add_autoload_singleton("GUITypeOnEffect", GUIPaths.TYPE_ON_EFFECT_SCRIPT)
	
	# Register custom types
	add_custom_type("GUIButton", "Button", preload(GUIPaths.BUTTON_SCRIPT), preload(GUIPaths.BUTTON_ICON))
	add_custom_type("GUIPanel", "Panel", preload(GUIPaths.PANEL_SCRIPT), preload(GUIPaths.PANEL_ICON))
	add_custom_type("GUIDialog", "Control", preload(GUIPaths.DIALOG_SCRIPT), preload(GUIPaths.DIALOG_ICON))
	add_custom_type("GUITooltip", "Control", preload(GUIPaths.TOOLTIP_SCRIPT), preload(GUIPaths.TOOLTIP_ICON))

func _exit_tree():
	# Remove autoload singletons
	remove_autoload_singleton("GUIPaths")
	remove_autoload_singleton("GUIResponsive")
	remove_autoload_singleton("GUIFadeAnimation")
	remove_autoload_singleton("GUITypeOnEffect")
	
	# Remove custom types
	remove_custom_type("GUIButton")
	remove_custom_type("GUIPanel")
	remove_custom_type("GUIDialog")
	remove_custom_type("GUITooltip") 