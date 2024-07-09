class_name camera_controller
extends Node3D

@export var cam : Camera3D

@export var focus_target_position : Node3D
@export var focus_target_distance : float
@export var focus_target_fov : float

@export var position_damping_lambda : float
@export var distance_damping_lambda : float
@export var fov_damping_lambda : float

func _ready():
	if focus_target_distance == 0:
		focus_target_distance = cam.position.length()
		
	if focus_target_fov == 0:
		focus_target_fov = cam.fov

func _process(delta:float):
	global_position = Damp(global_position, focus_target_position.global_position, position_damping_lambda, delta)
	var camDir := cam.position.normalized()
	cam.position = Damp(cam.position, camDir * focus_target_distance, distance_damping_lambda, delta)
	cam.fov = DampF(cam.fov, focus_target_fov, fov_damping_lambda, delta)

static func DampF(a: float, b : float, lambda : float, dt : float) -> float:
	return lerpf(a, b, 1 - exp(-lambda * dt))
	
static func Damp(a: Variant, b : Variant, lambda : float, dt : float) -> Variant:
	return lerp(a, b, 1 - exp(-lambda * dt))
