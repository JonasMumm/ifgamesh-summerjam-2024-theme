extends Node3D

@export var checkpoints : Array[checkpoint]
@export var vehicle_spawners : Array[vehicle_spawner]
@export var default_spawner: vehicle_spawner
@export var cam : camera_controller
@export var route_container : Node3D
@export var compass : compass

var vehicle : vehicle_controller

func _ready():
	for v in checkpoints:
		v.vehicle_entered.connect(OnCheckpointEntered)
		v.process_mode = Node.PROCESS_MODE_DISABLED
		v.visible = false
		
	for v in vehicle_spawners:
		v.vehicle_spawned.connect(OnVehicleSpawned)
	
	ActivateNextCheckpoints()
	
	default_spawner.SpawnVehicle()
		
func OnCheckpointEntered(point : checkpoint, v:vehicle_controller):
	while checkpoints.size() > 0:
		var c := checkpoints[0]
		c.queue_free()
		checkpoints.remove_at(0)
		
		if c == point:
			break
			
	ActivateNextCheckpoints()
	
func ActivateNextCheckpoints():
	for i in range(0, checkpoints.size()):
		var c := checkpoints[i]
		c.process_mode = Node.PROCESS_MODE_INHERIT
		c.visible = true
		
		if c.mandatory:
			break
			
	if checkpoints.size() > 0:
		compass.SetTarget(checkpoints[0])
	else:
		compass.visible = false
		compass.process_mode = Node.PROCESS_MODE_DISABLED

func OnVehicleSpawned(v : vehicle_controller):
	
	compass.SetOwner(v)
	
	if vehicle != null:
		vehicle.route_placer.Place()
		vehicle.queue_free()
	
	cam.focus_target_position = v
	vehicle = v
	v.route_placer.route_parent = route_container
