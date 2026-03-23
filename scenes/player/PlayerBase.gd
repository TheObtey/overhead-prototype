extends CharacterBody3D

@onready var oCameraRoot: Node3D = $CameraRoot
@onready var oCamera: Camera3D = $CameraRoot/Camera3D

@onready var oMovementComponent = $Components/MovementComponent
@onready var oCameraComponent = $Components/CameraComponent

const vecDefaultGravityDireciton: Vector3 = Vector3.DOWN

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oMovementComponent.Setup(self)
	oCameraComponent.Setup(self, oCameraRoot, oCamera)

func _unhandled_input(oEvent: InputEvent) -> void:
	if oEvent.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if oEvent is InputEventMouseButton and oEvent.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oCameraComponent.HandleInput(oEvent)

func _physics_process(iDelta: float) -> void:
	oMovementComponent.PhysicsUpdate(iDelta)

func SetGravityDirection(vecNewGravityDirection: Vector3) -> void:
	oMovementComponent.SetGravityDirection(vecNewGravityDirection)

func ResetGravityDirection() -> void:
	oMovementComponent.SetGravityDirection(vecDefaultGravityDireciton)
