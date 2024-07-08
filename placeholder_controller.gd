extends RigidBody3D

@export var force : float

func _physics_process(delta):
	var lr = Input.get_axis("ui_left", "ui_right")
	var up = Input.get_axis("ui_up", "ui_down")
	
	apply_central_force(Vector3(lr,0,up) * force)
