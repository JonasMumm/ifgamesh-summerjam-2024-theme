class_name checkpoint
extends Area3D

signal vehicle_entered(point: checkpoint, vehicle: vehicle_controller)

@export var mandatory : bool
@export var visual : Node

func _ready():
	
	body_entered.connect(OnBodyEntered)
	
	if !mandatory:
		visual.process_mode = Node.PROCESS_MODE_DISABLED
		visual.visible = false

func OnBodyEntered(body: Node3D):
	vehicle_entered.emit(self, body as vehicle_controller)
