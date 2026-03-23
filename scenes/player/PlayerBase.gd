extends CharacterBody3D

@onready var camera_root: Node3D = $CameraRoot
@onready var camera: Camera3D = $CameraRoot/Camera3D

@onready var movement_component = $Components/MovementComponent
@onready var camera_component = $Components/CameraComponent

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	movement_component.setup(self)
	camera_component.setup(self, camera_root, camera)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseButton and event.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	camera_component.handle_input(event)

func _physics_process(iDelta: float) -> void:
	movement_component.physics_update(iDelta)
