class_name snap
extends Node3D

@export var animation_player : AnimationPlayer
@export var texture : Texture2D
@export var texturerect : TextureRect

func _ready():
	texturerect.texture = texture

func appear():
	visible = true
	process_mode = PROCESS_MODE_INHERIT
	animation_player.play("appear")

func disappear():
	visible = false
	process_mode = PROCESS_MODE_DISABLED


func _on_checkpoint_entered(point, vehicle):
	appear()
