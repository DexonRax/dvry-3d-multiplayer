extends CharacterBody3D

#--PLAYER VARIABLES--#
const SPEED = 3.4
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#--OBJECTS--#
@onready var animation_player = $player/AnimationPlayer
@onready var head = $Head
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/Hand
@onready var fps_label = $FPSLabel
@onready var money_label = $MoneyLabel
@onready var crosshair = $Control/Crosshair
@onready var hit_cooldown = $HitCooldown

#--EXPORTED--#
@export var sens = 0.1
@export var active = true

#--GRAB STUFF--#
var grabbed = false
var grabbed_object = null
var pull_power = 4
var holding_tool = false
var hitting = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	crosshair.play("idle")
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens))
		head.rotate_x(deg_to_rad(-event.relative.y*sens))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 80)
		
func grab_object():
	var object = raycast.get_collider()
	if object != null and object.is_in_group("grab"):
		grabbed = true
		grabbed_object = object
		print("item volume = ", grabbed_object.volume)

func ungrab_object():
	if grabbed_object != null:
		grabbed_object = null
		grabbed = false

func handle_grabbing():
	if grabbed_object != null:
		var a = grabbed_object.global_transform.origin
		var b = hand.global_transform.origin
		grabbed_object.set_linear_velocity((b-a)*pull_power)

func handle_ui():
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	money_label.text = "Money: " + str(Global.money)
	
	if grabbed == true:
		crosshair.play("grabbed")
	elif grabbed == false:
		if raycast.is_colliding():
			if raycast.get_collider() != null:
				if raycast.get_collider().is_in_group("grab"):
					crosshair.play("grab")
				else:
					crosshair.play("idle")
			else:
				crosshair.play("idle")
		else:
			crosshair.play("idle")


func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	handle_ui()
	handle_grabbing()
	
	#if raycast.is_colliding():
	if Input.is_action_pressed("grab") and holding_tool and hitting == false and active:
		hitting = true
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("mineable"):
				raycast.get_collider().spawn_ore()
				print(raycast.get_collider().ore_name)
		hit_cooldown.start()
		animation_player.play("animation_model_hit")
			
	if Input.is_action_just_pressed("grab") and active and holding_tool == false:
		if grabbed_object == null:
			grab_object()
		elif grabbed_object != null:
			ungrab_object()
		
	if Input.is_action_just_pressed("1") and grabbed == false:
		holding_tool = !holding_tool
		print(holding_tool)
		
	if holding_tool:
		$player/Node2/arm_r/test_pickaxe.visible = true
	else:
		$player/Node2/arm_r/test_pickaxe.visible = false
		
	if not is_on_floor():
		velocity.y -= gravity * delta


	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and active:
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if hitting == false:
		if direction and active:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			animation_player.play("animation_model_walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			animation_player.play("animation_model_idle")
	else:
		velocity.x = 0
		velocity.z = 0
		
	move_and_slide()


func _on_hit_cooldown_timeout():
	hitting = false
