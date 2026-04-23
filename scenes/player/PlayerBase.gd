class_name PlayerBase
extends CharacterBody3D

# Main player root that wires input, movement, interaction,
# inventory, equipment, and UI feedback through components.
@onready var oCameraRoot: Node3D = $CameraRoot
@onready var oCamera: Camera3D = $CameraRoot/Camera3D

@onready var oMovementComponent = $Components/MovementComponent
@onready var oCameraComponent = $Components/CameraComponent
@onready var oInteractComponent = $Components/InteractComponent
@onready var oInventoryComponent = $Components/InventoryComponent
@onready var oEquipmentComponent = $Components/EquipmentComponent
@onready var oGravityReceiverComponent = $Components/GravityReceiverComponent
@onready var oPingComponent : Node3D = $Visuals/PingScene
@onready var oHotbarUI = $HotbarUI
@onready var oViewmodelRoot: Node3D = $CameraRoot/ViewmodelRoot
@onready var oEmoteWheel: Control = $Visuals/EmoteWheel
@onready var oPlayerMeshs: Node3D = $Visuals/PlayerAnimated

@onready var oAnimationHandler: AnimationHandler = $Visuals/PlayerAnimated/AnimationPlayer

@export var oStarterItemScene: PackedScene
@export var iPlayerID : int #player 1 or 2 (0 or 1)

# Initializes all components and the HUD/hotbar bindings.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oMovementComponent.Setup(self)
	oGravityReceiverComponent.Setup(self)
	oCameraComponent.Setup(self, oCameraRoot, oCamera)
	oInteractComponent.Setup(self)
	oInteractComponent.oEntityChanged.connect(_OnEntityChanged)
	oInventoryComponent.Setup(self)
	oEquipmentComponent.Setup(self, oViewmodelRoot)
	oPlayerMeshs.SetPlayerID(iPlayerID)
	oPingComponent.LinkPing(iPlayerID)
	oEmoteWheel.SetUp(oPingComponent,iPlayerID)
	oCamera.set_cull_mask_value(2+iPlayerID,false)
	oHotbarUI.Setup(self, oInventoryComponent, oEquipmentComponent)

# Handles mouse capture toggling and delegates input.
func _unhandled_input(oEvent: InputEvent) -> void:
	if oEvent.is_action_pressed("menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if oEvent is InputEventMouseButton and oEvent.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	oEmoteWheel.HandleInput(oEvent)
	HandleHotbarInput(oEvent)

func _process(iDelta: float) -> void:
	oCameraComponent.UpdateLook(iDelta)

# Runs per-physics-frame player systems.
func _physics_process(iDelta: float) -> void:
	if velocity != Vector3.ZERO:
		AnimationHandler.enumNewStatePlayer[iPlayerID] = AnimationHandler.AnimState.WALK
	if velocity == Vector3.ZERO:
		AnimationHandler.enumNewStatePlayer[iPlayerID] = AnimationHandler.AnimState.IDLE
	oMovementComponent.PhysicsUpdate(iDelta)
	oInteractComponent.ProcessUpdate()
	oEquipmentComponent.HandleInput()
	oEmoteWheel.Update(iDelta)
	oAnimationHandler.UpdatePlayer(iPlayerID)

# Updates on-screen interaction prompt when target changes.
func _OnEntityChanged(oEntity: Node) -> void:
	if oEntity:
		$HUD/Text.text = "[E] " + oInteractComponent.GetCurrentPrompt()
		$HUD/Text.visible = true
	else:
		$HUD/Text.visible = false

# Sets the player's ID
func SetPlayerID(iNewPlayerID: int) -> void:
	iPlayerID = iNewPlayerID

# Returns the player's ID
func GetPlayerID() -> int:
	return iPlayerID

# Exposes inventory component to external callers.
func GetInventoryComponent() -> Node:
	return oInventoryComponent

# Exposes equipment component to external callers.
func GetEquipmentComponent() -> Node:
	return oEquipmentComponent

# Maps hotbar actions (`hotbar_1`..`hotbar_5`) to equip slots.
func HandleHotbarInput(oEvent: InputEvent) -> void:
	if not oEvent.is_pressed():
		return
	
	var tItems: Array = oInventoryComponent.GetItems()
	
	for iIndex in range(5):
		var sAction = "hotbar_" + str(iIndex + 1)
		
		if Input.is_action_just_pressed(sAction):
			oEquipmentComponent.EquipItemByIndex(iIndex, tItems)
			break
			
