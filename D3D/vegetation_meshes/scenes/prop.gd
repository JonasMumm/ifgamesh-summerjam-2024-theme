extends StaticBody3D

@export var randomize_y_rotation : bool
@export var meshes : Array[Mesh]
@export var meshInstance : MeshInstance3D
@export var randomize_scale_range : float

func _ready():
	if randomize_y_rotation:
		rotate(Vector3.UP, randf() * PI * 2)
		
	if meshes.size() > 0:
		meshInstance.mesh = meshes[randi_range(0,meshes.size() - 1)]
		
	if randomize_scale_range != 0:
		scale *= randf_range(1-randomize_scale_range*0.5,1+randomize_scale_range*0.5)
