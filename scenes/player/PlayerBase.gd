extends CharacterBody3D

@onready var oCameraRoot: Node3D = $CameraRoot
@onready var oCamera: Camera3D = $CameraRoot/Camera3D

@onready var oMovementComponent = $Components/MovementComponent
@onready var oCameraComponent = $Components/CameraComponent
@onready var oInteractComponent = $Components/InteractComponent
@onready var oInventoryComponent = $Components/InventoryComponent
@onready var oEquipmentComponent = $Components/EquipmentComponent
@onready var oHotbarUI = $HotbarUI

@export var oStarterItemScene: PackedScene

const vecDefaultGravityDireciton: Vector3 = Vector3.DOWN

var oActiveGravityField: Area3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oMovementComponent.Setup(self)
	oCameraComponent.Setup(self, oCameraRoot, oCamera)
	oInteractComponent.Setup(self)
	oInteractComponent.oEntityChanged.connect(_OnEntityChanged)
	oInventoryComponent.Setup(self)
	oEquipmentComponent.Setup(self)
	
	var oGravityGun = preload("res://scenes/items/GravityGun.gd").new()
	add_child(oGravityGun)
	
	oInventoryComponent.AddItem(oGravityGun)
	oEquipmentComponent.EquipItem(oGravityGun)
	
	oHotbarUI.Setup(self, oInventoryComponent, oEquipmentComponent)
	
	if oStarterItemScene:
		var oStarterItem = oStarterItemScene.instantiate()
		add_child(oStarterItem)
		
		oInventoryComponent.AddItem(oStarterItem)
		#oEquipmentComponent.EquipItem(oStarterItem)

func _unhandled_input(oEvent: InputEvent) -> void:
	if oEvent.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if oEvent is InputEventMouseButton and oEvent.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oCameraComponent.HandleInput(oEvent)

func _physics_process(iDelta: float) -> void:
	oMovementComponent.PhysicsUpdate(iDelta)
	oInteractComponent.ProcessUpdate()
	oEquipmentComponent.HandleInput()

func _OnEntityChanged(oEntity: Node) -> void:
	if oEntity:
		$HUD/Text.text = "[E] " + oInteractComponent.GetCurrentPrompt()
		$HUD/Text.visible = true
	else:
		$HUD/Text.visible = false

func SetGravityDirection(oField: Area3D, vecNewGravityDirection: Vector3) -> void:
	oActiveGravityField = oField
	oMovementComponent.SetGravityDirection(vecNewGravityDirection)

func ResetGravityDirection() -> void:
	oMovementComponent.SetGravityDirection(vecDefaultGravityDireciton)

func ClearActiveGravityField(oField: Area3D) -> void:
	if oActiveGravityField != oField:
		return
	
	oActiveGravityField = null
	ResetGravityDirection()
