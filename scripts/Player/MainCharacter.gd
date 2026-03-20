extends CharacterBody3D

#Basics Const
const WALK_SPEED = 5.0
const RUN_SPEED = 7.5
const JUMP_VELOCITY = 20.0
const MOUSE_SENSITIVITY = 0.005
const DEFAULT_GRAVITY_STRENGTH: float = 20.0
const GRAVITY_ALIGN_SPEED: float = 5.0

#Gravity shit
var gravity_direction: Vector3 = Vector3.DOWN
var gravity_strength: float = 20.0
var current_gravity_field: Area3D = null
var speed := WALK_SPEED

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
	up_direction = -gravity_direction
	floor_stop_on_slope = true

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	handle_holding_object()
	
	up_direction = -gravity_direction
	
	var gravity_velocity := gravity_direction * velocity.dot(gravity_direction)
	var planar_velocity := velocity - gravity_velocity
	
	if Input.is_action_pressed("sprint"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var forward: Vector3 = head.global_transform.basis.z
	var right: Vector3 = head.global_transform.basis.x
	
	forward = forward.slide(gravity_direction).normalized()
	right = right.slide(gravity_direction).normalized()
	
	var direction: Vector3 = (right * input_dir.x + forward * input_dir.y).normalized()
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			planar_velocity = direction * speed
		else:
			planar_velocity = Vector3.ZERO
	else:
		if direction != Vector3.ZERO:
			planar_velocity = planar_velocity.lerp(direction * speed, delta * 7.0)
	
	# Add the gravity.
	if not is_on_floor():
		gravity_velocity += gravity_direction * gravity_strength * delta
	else:
		if Input.is_action_just_pressed("ui_accept"):
			gravity_velocity = -gravity_direction * JUMP_VELOCITY
		else:
			gravity_velocity = gravity_direction * 0.1
	
	velocity = planar_velocity + gravity_velocity
	
	t_sineWave += delta * planar_velocity.length() * float(is_on_floor())
	camera.transform.origin = _sineWave(t_sineWave)
	
	#FOV
	var velocity_clamped = clamp(planar_velocity.length(), 0.5, RUN_SPEED * 1.5)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	_align_to_gravity(delta)
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

func set_gravity_field(new_direction: Vector3, new_strength: float) -> void:
	gravity_direction = new_direction.normalized()
	gravity_strength = new_strength

func clear_gravity_field(field: Area3D) -> void:
	gravity_direction = Vector3.DOWN
	gravity_strength = DEFAULT_GRAVITY_STRENGTH

func _align_to_gravity(delta: float) -> void:
	var target_up: Vector3 = -gravity_direction.normalized()
	var current_up: Vector3 = global_transform.basis.y.normalized()

	var dot_value: float = clamp(current_up.dot(target_up), -1.0, 1.0)

	if dot_value > 0.9999:
		return

	var rotation_axis: Vector3 = current_up.cross(target_up)

	if rotation_axis.length() < 0.001:
		rotation_axis = global_transform.basis.x.normalized()

	rotation_axis = rotation_axis.normalized()

	var angle: float = acos(dot_value)
	var step: float = min(angle, GRAVITY_ALIGN_SPEED * delta)

	global_rotate(rotation_axis, step)
	global_transform.basis = global_transform.basis.orthonormalized()
