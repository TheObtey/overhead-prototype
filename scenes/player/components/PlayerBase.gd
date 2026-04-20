extends CharacterBody3D

@onready var oCameraRoot: Node3D = $CameraRoot
@onready var oCamera: Camera3D = $CameraRoot/Camera3D

@onready var oMovementComponent = $Components/MovementComponent
@onready var oCameraComponent = $Components/CameraComponent
@onready var oInteractComponent = $Components/InteractComponent
@onready var oInventoryComponent = $Components/InventoryComponent
@onready var oEquipmentComponent = $Components/EquipmentComponent
@onready var oGravityReceiverComponent = $Components/GravityReceiverComponent
@onready var oHotbarUI = $HotbarUI
@onready var oViewmodelRoot: Node3D = $CameraRoot/ViewmodelRoot

@export var oStarterItemScene: PackedScene

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oMovementComponent.Setup(self)
	oGravityReceiverComponent.Setup(self)
	oCameraComponent.Setup(self, oCameraRoot, oCamera)
	oInteractComponent.Setup(self)
	oInteractComponent.oEntityChanged.connect(_OnEntityChanged)
	oInventoryComponent.Setup(self)
	oEquipmentComponent.Setup(self, oViewmodelRoot)
	
	oHotbarUI.Setup(self, oInventoryComponent, oEquipmentComponent)

func _unhandled_input(oEvent: InputEvent) -> void:
	if oEvent.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if oEvent is InputEventMouseButton and oEvent.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oCameraComponent.HandleInput(oEvent)
	HandleHotbarInput(oEvent)

func _physics_process(iDelta: float) -> void:
	if velocity != Vector3.ZERO:
		AnimationHandler.enumNewState = AnimationHandler.AnimState.WALK
	if velocity == Vector3.ZERO:
		AnimationHandler.enumNewState = AnimationHandler.AnimState.IDLE
	oMovementComponent.PhysicsUpdate(iDelta)
	oInteractComponent.ProcessUpdate()
	oEquipmentComponent.HandleInput()

func _OnEntityChanged(oEntity: Node) -> void:
	if oEntity:
		$HUD/Text.text = "[E] " + oInteractComponent.GetCurrentPrompt()
		$HUD/Text.visible = true
	else:
		$HUD/Text.visible = false

func GetInventoryComponent() -> Node:
	return oInventoryComponent

func GetEquipmentComponent() -> Node:
	return oEquipmentComponent

func HandleHotbarInput(oEvent: InputEvent) -> void:
	if not oEvent.is_pressed():
		return
	
	var tItems: Array = oInventoryComponent.GetItems()
	
	for iIndex in range(5):
		var sAction = "hotbar_" + str(iIndex + 1)
		
		if Input.is_action_just_pressed(sAction):
			oEquipmentComponent.EquipItemByIndex(iIndex, tItems)
			break
			
