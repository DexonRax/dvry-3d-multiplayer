extends Node3D


func _on_sell_area_body_entered(body):
	if body.is_in_group("sell"):
		Global.money += snapped(body.volume * 200, 0.1)
		$Player.grabbed = false
		$Player.grabbed_object = null
		body.queue_free()
