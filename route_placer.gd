class_name route_placer
extends Node3D

@export var route_parent : Node
@export var route_prefab : PackedScene
@export var intervalDistance : float

var last_global_position : Vector3
var prev_last_global_position : Vector3

func _enter_tree():
	prev_last_global_position = global_position
	last_global_position = global_position

func _process(delta : float):
	if (last_global_position-global_position).length() > intervalDistance:
		
		if last_global_position == prev_last_global_position:
			prev_last_global_position += last_global_position - global_position
		
		var instance := route_prefab.instantiate() as Node3D
		route_parent.add_child(instance)
		instance.look_at_from_position(prev_last_global_position, global_position)
		instance.global_position = last_global_position
		instance.owner = route_parent
		prev_last_global_position = last_global_position
		last_global_position = global_position
		print(last_global_position)
	
