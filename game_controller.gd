extends Node3D

const default_route_path = "res://default_route.tscn"

@export var checkpoints : Array[checkpoint]
@export var vehicle_spawners : Array[vehicle_spawner]
@export var default_spawner: vehicle_spawner
@export var cam : camera_controller
@export var route_container : Node3D
@export var compass : compass
@export var final_cam_position : Node3D
@export var final_cam_distance : float
@export var final_cam_damping_factor : float
@export var route_marker_scaler : cam_distance_scaler
@export var snap_scaler : cam_distance_scaler
@export var snaps : Array[snap]
@export var route_marker_area : Area3D
@export var route_marker_switchover_area : Area3D

var vehicle : vehicle_controller

func _ready():
	for v in checkpoints:
		v.vehicle_entered.connect(OnCheckpointEntered)
		v.process_mode = Node.PROCESS_MODE_DISABLED
		v.visible = false
		
	for v in vehicle_spawners:
		v.vehicle_spawned.connect(OnVehicleSpawned)
		
	for v in snaps:
		v.disappear()
		snap_scaler.add(v)
	
	ActivateNextCheckpoints()
	
	default_spawner.SpawnVehicle()
	
	route_marker_switchover_area.body_entered.connect(OnSwitchoverAreaEnter)

func _process(delta:float):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func OnCheckpointEntered(point : checkpoint, v:vehicle_controller):
	while checkpoints.size() > 0:
		var c := checkpoints[0]
		c.queue_free()
		checkpoints.remove_at(0)
		
		if c == point:
			break
			
	ActivateNextCheckpoints()
	
	if checkpoints.size() == 0:
		cam.focus_target_position = final_cam_position
		cam.focus_target_distance = final_cam_distance
		cam.position_damping_lambda *= final_cam_damping_factor
		cam.distance_damping_lambda *= final_cam_damping_factor
		vehicle.process_mode = Node.PROCESS_MODE_DISABLED
	
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
	vehicle.route_placer.placed.connect(OnRouteMarkerPlaced)

func OnRouteMarkerPlaced(v:Node3D):
	route_marker_scaler.add(v)
	
func OnSwitchoverAreaEnter(b : Node3D):
	route_marker_switchover_area.body_entered.disconnect(OnSwitchoverAreaEnter)
	
	if !ResourceLoader.exists(default_route_path):
		for v in route_container.get_children():
			v.owner = null
		
		for v in route_marker_area.get_overlapping_areas():
			v.get_parent().owner = route_container
	
		var scene := PackedScene.new()
		var result := scene.pack(route_container)
		print("CONNECTTTT "+str(result))
		if result == OK:
			var error := ResourceSaver.save(scene, default_route_path)
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")

	for v in route_marker_area.get_overlapping_areas():
		route_marker_scaler.remove(v.get_parent())
		v.get_parent().queue_free()
	
	var default_instance := load(default_route_path).instantiate() as Node3D
	default_instance.name += "instanced"
	route_container.get_parent().add_child(default_instance)
	
	for v in default_instance.get_children():
		OnRouteMarkerPlaced(v as Node3D)
	
