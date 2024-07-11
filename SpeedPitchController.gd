extends Node

@export var rb : RigidBody3D
@export var sound : AudioStreamPlayer3D
@export var pitch_min : float
@export var pitch_max : float
@export var speed_max : float

func _process(delta:float):
	sound.pitch_scale = lerpf(pitch_min, pitch_max, clampf(rb.linear_velocity.length() / speed_max, 0, 1))
