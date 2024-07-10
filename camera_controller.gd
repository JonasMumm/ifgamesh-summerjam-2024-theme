class_name camera_controller
extends Node3D

signal cam_dist_changed(dist: float)

@export var cam : Camera3D

@export var focus_target_position : Node3D
@export var focus_target_distance : float
@export var focus_target_fov : float

@export var position_damping_lambda : float
@export var distance_damping_lambda : float
@export var fov_damping_lambda : float

func _ready():
	if focus_target_distance == 0:
		focus_target_distance = get_current_cam_dist()
		
	if focus_target_fov == 0:
		focus_target_fov = cam.fov

func _process(delta:float):
	global_position = Damp(global_position, focus_target_position.global_position, position_damping_lambda, delta)
	
	if(absf(get_current_cam_dist() - focus_target_distance) > 0.005):	
		var camDir := cam.position.normalized()
		cam.position = Damp(cam.position, camDir * focus_target_distance, distance_damping_lambda, delta)
		cam_dist_changed.emit(get_current_cam_dist())
		
	cam.fov = DampF(cam.fov, focus_target_fov, fov_damping_lambda, delta)
		
func get_current_cam_dist() -> float:
	return cam.position.length()

static func DampF(a: float, b : float, lambda : float, dt : float) -> float:
	return lerpf(a, b, 1 - exp(-lambda * dt))
	
static func Damp(a: Variant, b : Variant, lambda : float, dt : float) -> Variant:
	return lerp(a, b, 1 - exp(-lambda * dt))
