extends StaticBody3D

@onready var mesh = $MeshInstance3D
@onready var collision = $CollisionShape3D
var ore = preload("res://Nodes/ore.tscn")

var ore_name = "stone"
var health = 10

func _ready():
	mesh.mesh.size.x = snapped(randf_range(2,3),0.1)
	mesh.mesh.size.y = snapped(randf_range(2,3),0.1)
	mesh.mesh.size.z = snapped(randf_range(2,3),0.1)
	collision.shape.size.x = mesh.mesh.size.x
	collision.shape.size.y = mesh.mesh.size.y
	collision.shape.size.z = mesh.mesh.size.z
	global_position.y = mesh.mesh.size.y/2

func spawn_ore():
	var ore_instance = ore.instantiate()
	print(global_position)
	ore_instance.position =  global_position + Vector3(0,1,0)
	if mesh.mesh.size.y - 0.3 > 0.2:
		mesh.mesh.size.y -= 0.3
		global_position.y = mesh.mesh.size.y/2
		collision.shape.size.y = mesh.mesh.size.y
	else:
		queue_free()
	get_node("/root").add_child(ore_instance)

	
