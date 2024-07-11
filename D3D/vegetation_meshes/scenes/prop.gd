extends StaticBody3D

@export var randomize_y_rotation : bool
@export var meshes : Array[Mesh]
@export var meshInstance : MeshInstance3D

func _ready():
	if randomize_y_rotation:
		rotate(Vector3.UP, randf() * PI * 2)
		
	if meshes.size() > 0:
		meshInstance.mesh = meshes[randi_range(0,meshes.size() - 1)]
