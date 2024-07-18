class_name vehicle_controller
extends RigidBody3D

@export var force : float
@export var rotation_speed : float
@export var route_placer : route_placer

var stick_input : Vector2

func _physics_process(delta):
	var input = stick_input if stick_input != Vector2.ZERO else Vector2(Input.get_axis("control_left", "control_right"), Input.get_axis("control_up", "control_down"))
	
	if input.length_squared() == 0:
		return
		
	var angInput := atan2(input.y,input.x)
	var basisBody := -global_basis.z
	var angBody := atan2(basisBody.z,basisBody.x)
	
	var diff := angle_difference(angInput,angBody)
	var addedRotation = signf(diff) * minf(absf(diff),delta * rotation_speed)
	
	rotate(Vector3.UP, addedRotation)
	apply_central_force(basisBody * force)
