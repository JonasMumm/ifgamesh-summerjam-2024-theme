class_name  vehicle_spawner
extends Node3D

signal vehicle_spawned(v:vehicle_controller)

@export var vehicle_prefab: PackedScene

func SpawnVehicle():
	var v := vehicle_prefab.instantiate() as vehicle_controller
	add_child(v)
	v.position = Vector3.ZERO
	v.rotation = Vector3.ZERO
	vehicle_spawned.emit(v)

func _on_checkpoint_vehicle_entered(point, vehicle):
	SpawnVehicle()
