@tool
extends Node
class_name GodotUIPaths

## Global singleton for accessing paths to GodotUI Essentials components

# Base paths
const BASE_PATH = "res://addons/godotui_essentials"
const COMPONENTS_PATH = BASE_PATH + "/components"
const SCRIPTS_PATH = BASE_PATH + "/scripts"
const ART_PATH = BASE_PATH + "/art"
const EXAMPLES_PATH = BASE_PATH + "/examples"

# Component scenes
const BUTTON_SCENE = COMPONENTS_PATH + "/gui_button.tscn"
const PANEL_SCENE = COMPONENTS_PATH + "/gui_panel.tscn"
const DIALOG_SCENE = COMPONENTS_PATH + "/gui_dialog.tscn"
const TOOLTIP_SCENE = COMPONENTS_PATH + "/gui_tooltip.tscn"

# Component scripts
const BUTTON_SCRIPT = SCRIPTS_PATH + "/gui_button.gd"
const PANEL_SCRIPT = SCRIPTS_PATH + "/gui_panel.gd"
const DIALOG_SCRIPT = SCRIPTS_PATH + "/gui_dialog.gd"
const TOOLTIP_SCRIPT = SCRIPTS_PATH + "/gui_tooltip.gd"
const RESPONSIVE_SCRIPT = SCRIPTS_PATH + "/gui_responsive.gd"
const FADE_ANIMATION_SCRIPT = SCRIPTS_PATH + "/gui_fade_animation.gd"
const TYPE_ON_EFFECT_SCRIPT = SCRIPTS_PATH + "/gui_type_on_effect.gd"

# Art assets
const BUTTON_ICON = ART_PATH + "/button_icon.svg"
const PANEL_ICON = ART_PATH + "/panel_icon.svg"
const DIALOG_ICON = ART_PATH + "/dialog_icon.svg"
const TOOLTIP_ICON = ART_PATH + "/tooltip_icon.svg"
const PANEL_BACKGROUND = ART_PATH + "/panel_background.svg"
const CHARACTER_SILHOUETTE = ART_PATH + "/character_silhouette.svg"
const GAME_ICONS = ART_PATH + "/game_icons.svg"

## Get the path to a component scene
static func get_component_scene(component_name: String) -> String:
	component_name = component_name.to_lower()
	
	match component_name:
		"button":
			return BUTTON_SCENE
		"panel":
			return PANEL_SCENE
		"dialog":
			return DIALOG_SCENE
		"tooltip":
			return TOOLTIP_SCENE
		_:
			push_error("Unknown component: " + component_name)
			return ""

## Get the path to a component script
static func get_component_script(component_name: String) -> String:
	component_name = component_name.to_lower()
	
	match component_name:
		"button":
			return BUTTON_SCRIPT
		"panel":
			return PANEL_SCRIPT
		"dialog":
			return DIALOG_SCRIPT
		"tooltip":
			return TOOLTIP_SCRIPT
		"responsive":
			return RESPONSIVE_SCRIPT
		"fade_animation":
			return FADE_ANIMATION_SCRIPT
		"type_on_effect":
			return TYPE_ON_EFFECT_SCRIPT
		_:
			push_error("Unknown component script: " + component_name)
			return ""

## Get the path to a component icon
static func get_component_icon(component_name: String) -> String:
	component_name = component_name.to_lower()
	
	match component_name:
		"button":
			return BUTTON_ICON
		"panel":
			return PANEL_ICON
		"dialog":
			return DIALOG_ICON
		"tooltip":
			return TOOLTIP_ICON
		_:
			push_error("Unknown component icon: " + component_name)
			return "" 
