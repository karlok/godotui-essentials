# Godot GUI Essentials

A lightweight and beginner-friendly UI helper addon for Godot 4, designed to quickly scaffold placeholder game UI without needing to dive into the full complexity of Godot's UI system.

## ✨ Features

- ✅ Drag-and-drop GUIPanel scene
- ✅ Easy `add_label()` and `add_button()` API in GDScript
- ✅ Type-on text Label effect with optional typing sound
- ✅ Button click sound built-in
- ✅ Optional fade and slide-in animations
- ✅ Customizable background and border styles
- ✅ Health bars with color transitions
- ✅ Minimal setup — works in code or directly in the editor

## 📦 Installation

1. Copy the `addons/gui_essentials` folder into your project.
2. In Godot, go to **Project > Project Settings > Plugins** and enable **gui_essentials**.
3. Add `_GUIPaths.gd` as an autoload singleton for convenient code access.

## 📚 API Documentation

### GUIPanel

The main container component for organizing UI elements.

#### Properties
- `placement`: PanelPlacement enum (TOP_LEFT, TOP_RIGHT, CENTER, etc.)
- `panel_size`: Vector2 - Fixed size for the panel
- `background_color`: Color - Panel background color
- `border_style`: Dictionary - Border configuration
- `size_percentage` - Size relative to viewport (0.0 to 1.0 for width and height)

#### Methods
```gdscript
# Create and setup a panel
var panel = _GUIPaths.GUIPanelScene.instantiate()
panel.set_background_color(Color.BLUE_VIOLET)
panel.set_size_percentage(0.8, 0.7)  # 80% width, 70% height
panel.set_border_style({
    "color": Color.BLACK,
    "width": 4,
    "corner_radius": 12
})

# Add UI elements
var label = panel.add_label("Hello World", {
    "font": custom_font,
    "font_color": Color.SKY_BLUE,
    "size": Vector2(300, 40)
})

panel.add_button("Click Me", callback_function, {
    "font": custom_font,
    "font_color": Color.GREEN_YELLOW,
    "size": Vector2(300, 60)
})

# Animations
panel.fade_in()
panel.fade_out()
panel.slide_in_from_bottom()
```

### GUILabel

Text display component with type-on animation support.

#### Methods
```gdscript
# Basic label
var label = panel.add_label("Static Text", {
    "font": custom_font,
    "font_color": Color.WHITE,
    "size": Vector2(300, 40)
})

# Type-on animation
label.start_type_on_after_ready("Animated Text", 0.05, label.TypeOnMode.CHAR)
label.start_type_on_after_ready("Word by Word", 0.15, label.TypeOnMode.WORD)
```

### GUIButton

Interactive button component with built-in sound effects.

#### Methods
```gdscript
# Basic button
panel.add_button("Click Me", func(): print("Clicked!"))

# Button with custom styling
panel.add_button("Styled Button", callback_function, {
    "font": custom_font,
    "font_color": Color.YELLOW,
    "size": Vector2(300, 50)
})
```

### GUIBar

Progress bar component with color transition support.

#### Methods
```gdscript
# Create health bar
var health_bar = panel.add_bar(100, {
    "size": Vector2(200, 20),
    "bar_color": Color.LIME_GREEN,
    "background_color": Color.TRANSPARENT
})

# Update value
health_bar.value = 75

# Change color
health_bar.set_fill_color(Color.RED)
```

## 🎮 Common Use Cases

### 1. Game Menu
```gdscript
var menu_panel = _GUIPaths.GUIPanelScene.instantiate()
menu_panel.set_background_color(Color(0.1, 0.1, 0.1, 0.8))
menu_panel.set_size_percentage(0.8, 0.7)

var title = menu_panel.add_label("My Game", {
    "font": game_font,
    "font_color": Color.GOLD,
    "size": Vector2(400, 60)
})
title.start_type_on_after_ready("Welcome to My Game!", 0.05)

menu_panel.add_button("Start Game", start_game)
menu_panel.add_button("Options", show_options)
menu_panel.add_button("Quit", quit_game)
```

### 2. HUD with Health Bar
```gdscript
var hud_panel = _GUIPaths.GUIPanelScene.instantiate()
hud_panel.placement = GUIPanel.PanelPlacement.TOP_LEFT
hud_panel.set_background_color(Color.TRANSPARENT)
hud_panel.panel_size = Vector2(300, 50)

var health_bar = hud_panel.add_bar(100, {
    "size": Vector2(200, 20),
    "bar_color": Color.LIME_GREEN
})

# Update health
func update_health(value: float):
    health_bar.value = value
    var pct = value / 100.0
    if pct > 0.5:
        health_bar.set_fill_color(Color(1.0 - (pct - 0.5) * 2.0, 1.0, 0.0))
    else:
        health_bar.set_fill_color(Color(1.0, pct * 2.0, 0.0))
```

### 3. Dialog Box
```gdscript
var dialog = _GUIPaths.GUIPanelScene.instantiate()
dialog.placement = GUIPanel.PanelPlacement.CENTER
dialog.set_background_color(Color.BLACK)
dialog.set_border_style({ "color": Color.RED, "width": 3 })
dialog.set_size_percentage(0.6, 0.3)

var message = dialog.add_label("", {
    "font": dialog_font,
    "font_color": Color.WHITE
})
message.start_type_on_after_ready("Important message...", 0.03)

dialog.add_button("Continue", close_dialog)
```

## 🔧 Troubleshooting Guide

### Common Issues and Solutions

1. **Panel Not Visible**
   - Ensure the panel is a child of a CanvasLayer
   - Check if the panel's size or position is within viewport bounds
   - Verify that the panel's background color has an alpha value > 0

2. **Type-on Effect Not Working**
   - Make sure the label is properly added to the panel
   - Check if the text parameter is not empty
   - Verify that the speed parameter is reasonable (0.03-0.15 recommended)

3. **Button Not Responding**
   - Confirm the callback function is properly defined
   - Check if the button is not covered by other UI elements
   - Verify that the button's size is not zero

4. **Health Bar Not Updating**
   - Ensure the value is within min_value and max_value range
   - Check if the bar's size is properly set
   - Verify that the color transition logic is correct

5. **Animation Issues**
   - Make sure the panel is properly instantiated before calling animations
   - Check if the panel is visible in the scene tree
   - Verify that no other animations are conflicting

### Performance Tips

1. **Memory Management**
   - Remove unused panels when not needed
   - Use `queue_free()` instead of `free()` for proper cleanup
   - Avoid creating too many panels simultaneously

2. **Animation Optimization**
   - Use appropriate animation speeds (0.03-0.15 for type-on)
   - Limit the number of simultaneous animations
   - Consider using `visible = false` instead of removing panels

3. **Resource Usage**
   - Reuse panels when possible instead of creating new ones
   - Use appropriate panel sizes for your needs
   - Consider using transparent backgrounds when full opacity isn't needed

## 📝 TODO

- [ ] Scrollable content option
- [ ] Dropdowns, checkboxes, sliders
- [ ] Dialog panels with auto-close
- [ ] Theme export support
- [ ] Rich text support for labels
- [ ] Keyboard navigation
- [ ] Accessibility features

---

Built for courses, prototypes, and first games. Simple on purpose 💡
