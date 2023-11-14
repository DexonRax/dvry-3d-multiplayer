extends VehicleBody3D

var active = false
var player = null

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and player != null and active == false:
		active = true
		player.active = false
		print("jazdajazda")
		
	elif Input.is_action_just_pressed("interact") and active == true:
		active = false
		player.active = true
		player = null
		print("notjazdajazda")
		
	if active:
		steering = lerp(steering, Input.get_axis("move_right", "move_left")*0.7, 15 * delta)
		engine_force = Input.get_axis("move_backward", "move_forward") * 2000
		player.rotation_degrees.y = rotation_degrees.y-180
	else:
		engine_force = 0
		steering = 0
			
func _on_area_3d_area_entered(area):
	if area.name == "PlayerHitbox":
		player = area.get_parent()

func _on_area_3d_area_exited(area):
	if area.name == "PlayerHitbox":
		if active == true:
			player.active = true
			active = false
		player = null


