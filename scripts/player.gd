extends CharacterBody3D

const SPEED = 15.0
const JUMP_VELOCITY = 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 24.0
var sensitivity = 0.002
var selected = 0

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d = $Camera3D/RayCast3D
@onready var hotbar = $Hotbar

#camera control stuff
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hotbar.select(0)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		camera_3d.rotation.x = camera_3d.rotation.x - event.relative.y * sensitivity
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED) 
	move_and_slide()
	#mouse clicks and controller triggers
	if Input.is_action_just_pressed("left_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("destroy_block"):
				ray_cast_3d.get_collider().destroy_block(ray_cast_3d.get_collision_point() - 
														ray_cast_3d.get_collision_normal())
	if Input.is_action_just_pressed("right_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("place_block"):
				ray_cast_3d.get_collider().place_block(ray_cast_3d.get_collision_point() + 
														ray_cast_3d.get_collision_normal(), selected)
	#handle block selction
	if	Input.is_action_just_pressed("slot1"):	
		selected = 0
		hotbar.select(0)
	if	Input.is_action_just_pressed("slot2"):	
		selected = 1
		hotbar.select(1) 
	if	Input.is_action_just_pressed("slot3"):	
		selected = 2
		hotbar.select(2) 
	if	Input.is_action_just_pressed("slot4"):	
		selected = 4
		hotbar.select(3)		
	if	Input.is_action_just_pressed("slot5"):	
		selected = 5
		hotbar.select(4)		
	if	Input.is_action_just_pressed("slot6"):	
		selected = 3
		hotbar.select(5)		
	if	Input.is_action_just_pressed("slot7"):	
		selected = 7
		hotbar.select(6)		
	if	Input.is_action_just_pressed("slot8"):	
		selected = 10
		hotbar.select(7)		
	if	Input.is_action_just_pressed("slot9"):	
		selected = 11
		hotbar.select(8)			
		
		
		
