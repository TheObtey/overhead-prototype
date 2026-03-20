extends CharacterBody3D

#Basics Const
const WALK_SPEED = 5.0
const RUN_SPEED = 7.5
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.005

var speed

#Sine wave Const
const FREQUENCY = 2.0
const AMPLITUDE = 0.08

var t_sineWave = 0.0

#FOV const
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D


@export_category("Holding Object")
@export var Can_Holding_Object = false
@export var throwForce = 7.5
@export var followSpeed = 5.0
@export var followDistance = 2.5
@export var maxDistanceFromCamera = 5.0
@export var dropBellowPlayer = false
@export var groundRay: RayCast3D

@onready var interactRay = $Head/Camera3D/InteractRay
var heldObject: RigidBody3D



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	handle_holding_object()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("sprint"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z, delta * 7.0)
	
	t_sineWave += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _sineWave(t_sineWave)
	
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, RUN_SPEED * 1.5)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _sineWave(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * FREQUENCY) * AMPLITUDE
	pos.x = cos(time * FREQUENCY/2) * AMPLITUDE
	return pos


func set_held_object(body: RigidBody3D):
	if body is RigidBody3D:
		heldObject = body

func drop_held_object():
	heldObject = null

func throw_held_object():
	var obj = heldObject
	drop_held_object()
	obj.apply_central_impulse(-camera.global_transform.basis.z * throwForce *10)



func handle_holding_object():
	if Can_Holding_Object:
		
		if Input.is_action_just_pressed("throw"):
			if heldObject != null: throw_held_object()
			
		if Input.is_action_just_pressed("interact"):
			if heldObject != null: drop_held_object()
			elif interactRay.is_colliding(): set_held_object(interactRay.get_collider())
			
		if heldObject != null:
			var targetPos =camera.global_transform.origin + (camera.global_basis * Vector3(0, 0, -followDistance))
			var objectPos = heldObject.global_transform.origin
			heldObject.linear_velocity = ( targetPos - objectPos) * followSpeed
			
			if heldObject.global_position.distance_to(camera.global_position) > maxDistanceFromCamera:
				drop_held_object()
			
			if dropBellowPlayer && groundRay.is_colliding():
				if groundRay.get_collider() == heldObject: drop_held_object() 
			
