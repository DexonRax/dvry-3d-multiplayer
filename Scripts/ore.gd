extends RigidBody3D

@export var volume = 1
@onready var mesh3d = $MeshInstance3D
@onready var collision = $CollisionShape3D

func rand_mesh_size():
	var x = snapped(randf_range(0.5,1),0.1)
	var y = snapped(randf_range(0.5,1),0.1)
	var z = snapped(randf_range(0.5,1),0.1)
	mesh3d.mesh.size.x = x
	mesh3d.mesh.size.y = y
	mesh3d.mesh.size.z = z
	collision.shape.size.x = x
	collision.shape.size.y = y
	collision.shape.size.z = z

func _ready():
	rand_mesh_size()
	volume = mesh3d.mesh.size.x * mesh3d.mesh.size.y * mesh3d.mesh.size.z
