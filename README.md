# Godot GUI Essentials

A lightweight and beginner-friendly UI helper addon for Godot 4, designed to quickly scaffold placeholder game UI without needing to dive into the full complexity of Godot's UI system.

## ✨ Features

- ✅ Drag-and-drop GUIPanel scene
- ✅ Easy `add_label()` and `add_button()` API in GDScript
- ✅ Type-on text effect with optional typing sound
- ✅ Button click sound built-in
- ✅ Optional fade and slide-in animations
- ✅ Customizable background and border styles
- ✅ Minimal setup — works in code or directly in the editor

## 📦 Installation

1. Copy the `addons/gui_essentials` folder into your project.
2. In Godot, go to **Project > Project Settings > Plugins** and enable **gui_essentials**.
3. (Optional) Add `_GUIPaths.gd` as an autoload singleton for convenient code access.

## 🧱 Usage

### Option 1: Drag & Drop

1. In any scene, create a `CanvasLayer` (if you don't already have one).
2. Drag the `gui_panel.tscn` scene into the CanvasLayer.
3. Set the panel to **Full Rect** using the Layout menu.

You now have a panel ready to fill with buttons and labels!

### Option 2: Code

```gdscript
var panel = preload("res://addons/gui_essentials/gui_panel/gui_panel.tscn").instantiate()
$CanvasLayer.add_child(panel)

panel.set_background_color(Color(0.1, 0.1, 0.1, 0.8))
panel.set_border_style(Color.RED, 4)

var label = panel.add_label("")
label.type_on("Welcome to Godot!", 0.03, label.TypeOnMode.CHAR)

panel.add_button("Start Game", func(): print("Game started!"))
```

## 🧪 Advanced Effects

### Type-on Modes

```gdscript
label.type_on("By letter...", 0.05, label.TypeOnMode.CHAR)
label.type_on("By word instead", 0.15, label.TypeOnMode.WORD)
```

### Animations

```gdscript
panel.fade_in()
panel.slide_in_from_bottom()
```

## ❗ Gotchas

- The GUIPanel must be a child of a `CanvasLayer` or UI root node that fills the screen.
- Always use **Full Rect** anchors on the GUIPanel and MarginContainer.
- Button sounds and type-on sounds can be customized by editing the scenes.

## ✅ TODO

- [ ] Scrollable content option
- [ ] Dropdowns, checkboxes, sliders
- [ ] Dialog panels with auto-close
- [ ] Theme export support

---

Built for courses, prototypes, and first games. Simple on purpose 💡
