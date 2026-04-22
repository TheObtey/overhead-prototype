extends Node

@onready var oWheel : Control = $Wheel
@onready var bIsOpen : bool = false
@onready var vecMouseOffset : Vector2 = Vector2(3.5,2)
@onready var iSelectedEmote : int = 0

var oPingComponent : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetUp(oPingComp : Node3D) -> void:
	oPingComponent  = oPingComp
	pass

func Update(iDelta: float) -> void:
	if (Input.is_action_just_pressed("emote_wheel")):
		if bIsOpen:
			CloseWheel()
		else:
			OpenWheel()
	if (Input.is_action_just_pressed("primary_attack")):
		EmoteInterract(iSelectedEmote)
	pass

func HandleInput(oEvent: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if oEvent is InputEventMouseMotion:
		HandleEmoteChosen(oEvent)

func HandleEmoteChosen(oEvent: InputEventMouseMotion) -> void:
	var vecMouseDir : Vector2 = oEvent.relative
	var bIsGoingLeft : bool = vecMouseDir.x < -vecMouseOffset.x
	var bIsGoingRight : bool = vecMouseDir.x > vecMouseOffset.x
	var bIsGoingUp : bool = vecMouseDir.y < -vecMouseOffset.y
	var bIsGoingDown : bool = vecMouseDir.y > vecMouseOffset.y
	
	if bIsGoingLeft and bIsGoingUp:
		OverWheelPart(5)
		return
	if bIsGoingRight and bIsGoingUp:
		OverWheelPart(1)
		return
	if bIsGoingRight and bIsGoingDown:
		OverWheelPart(2)
		return
	if bIsGoingLeft and bIsGoingDown:
		OverWheelPart(4)
		return
	if bIsGoingDown:
		OverWheelPart(3)
		return
	if bIsGoingUp:
		OverWheelPart(0)
		return
		

func EmoteInterract(iEmoteID : int) -> void :
	if iSelectedEmote < 0 or iSelectedEmote > 5:
		pass
	CloseWheel()
	match iEmoteID:
		0:
			AnimationHandler.enumNewState = AnimationHandler.AnimState.POINT
			oPingComponent.Ping()
	pass

func OpenWheel() -> void:
	bIsOpen = true
	oWheel.visible = true
	pass

func CloseWheel() -> void:
	bIsOpen = false
	oWheel.visible = false
	pass

func OverWheelPart(iEmoteID : int) -> void :
	NotOverWheelPart(iSelectedEmote)
	var oEmoteSprite : Sprite2D = oWheel.get_child(iEmoteID)
	oEmoteSprite.self_modulate.a = 255.0/255.0;
	iSelectedEmote = iEmoteID
	pass

func NotOverWheelPart(iEmoteID : int) -> void :
	var oEmoteSprite : Sprite2D = oWheel.get_child(iEmoteID)
	oEmoteSprite.self_modulate.a = 155.0/255.0;
	pass
