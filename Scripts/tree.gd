extends StaticBody3D

@onready var log_mesh = $LogMesh
@onready var leaves_mesh = $LeavesMesh
@onready var log_collision = $CollisionShape3D

@onready var branch_1_mesh = $Branch1Mesh
@onready var branch_2_mesh = $Branch2Mesh

func _ready():
	randomize()
	var x = snapped(randf_range(0.4,0.7),0.1)
	var y = snapped(randf_range(3,4),0.1)
	var z = x
	log_mesh.mesh.size.x = x
	log_mesh.mesh.size.y = y
	log_mesh.mesh.size.z = z
	log_collision.shape.size.x = x
	log_collision.shape.size.y = y
	log_collision.shape.size.z = z
	
	
	branch_1_mesh.rotation_degrees.x = 45
	branch_1_mesh.rotation_degrees.y = 45
	branch_1_mesh.mesh.size.x = x - (x*0.1)
	branch_1_mesh.mesh.size.z = x - (x*0.1)
	branch_1_mesh.mesh.size.y = y - (y*0.4)
	branch_1_mesh.position.y = log_mesh.mesh.size.y*0.6
	branch_1_mesh.position.x = branch_1_mesh.mesh.size.x
	branch_1_mesh.position.z = branch_1_mesh.mesh.size.z
	
	branch_2_mesh.position.y = log_mesh.mesh.size.y
	branch_2_mesh.rotation_degrees.x = -45
	branch_2_mesh.rotation_degrees.y = -45
	
	global_position.y = log_mesh.mesh.size.y / 2
	
	leaves_mesh.global_position.y = log_mesh.mesh.size.y + leaves_mesh.mesh.size.y/2
	
