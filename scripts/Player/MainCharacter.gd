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

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
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
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	t_sineWave += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _sineWave(t_sineWave)

	move_and_slide()

func _sineWave(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * FREQUENCY) * AMPLITUDE
	pos.x = cos(time * FREQUENCY/2) * AMPLITUDE
	return pos
