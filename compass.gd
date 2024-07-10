class_name compass
extends Node3D

@export var animation_player : AnimationPlayer

var target : Node3D

func _process(delta:float):
	global_rotation = Vector3(0,atan2(global_position.x - target.global_position.x, global_position.z - target.global_position.z), 0)

func SetOwner(owner : Node3D):
	reparent(owner, false)
	position = Vector3.ZERO
	
func SetTarget(target : Node3D):
	self.target = target
	animation_player.play("new_objective")
