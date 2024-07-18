class_name thumbstick_area extends Control

signal input_changed(input : Vector2)

@export var thumbstick_bg : Control
@export var thumbstick_knob : Control
@export var max_radius: float

var button := -1
var down_pos : Vector2

func _gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			down_pos = event.position
			button = event.button_index
			thumbstick_bg.visible = true
			thumbstick_knob.visible = true
			thumbstick_bg.position = down_pos - thumbstick_bg.size * 0.5
			thumbstick_knob.position = down_pos  - thumbstick_knob.size * 0.5
		elif button == event.button_index:
			input_changed.emit(Vector2.ZERO)
			button = -1
			thumbstick_bg.visible = false
			thumbstick_knob.visible = false
	elif event is InputEventMouseMotion:
		if button >= 0:
			input_changed.emit((event.position - down_pos).normalized())
			var diff = event.position - down_pos
			if diff.length()>max_radius:
				diff = diff.normalized() * max_radius
			thumbstick_knob.position = down_pos + diff  - thumbstick_knob.size * 0.5
