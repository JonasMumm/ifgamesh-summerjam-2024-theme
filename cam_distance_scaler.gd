class_name cam_distance_scaler
extends Node

@export var cam_controller : camera_controller
@export var distClose : float
@export var scaleClose : Vector3
@export var distFar : float
@export var scaleFar : Vector3

var targets : Array[Node3D]

func _ready():
	cam_controller.cam_dist_changed.connect(on_cam_distance_changed)

func add(v:Node3D):
	targets.append(v)
	apply_scale(v, cam_controller.get_current_cam_dist())
	
func remove(v:Node3D):
	targets.erase(v)
	
func apply_scale(v:Node3D, cam_dist:float):
	var scl = lerp(scaleClose,scaleFar,inverse_lerp(distClose,distFar,cam_dist))
	v.scale = scl

func on_cam_distance_changed(dist:float):
	print("CHANGED " + str(dist))
	for i in targets:
		apply_scale(i, dist)
