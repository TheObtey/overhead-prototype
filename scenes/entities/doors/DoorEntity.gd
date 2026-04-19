class_name DoorEntity
extends EntityBase

@export var iOpenedAngle: float = 90.0
@export var iAnimationDuration: float = 0.6

var bIsOpen: bool = false
var bIsAnimating: bool = false

@onready var oDoorPivot: Node3D = $Visuals/DoorPivot

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	super.Interact(oInteractor)
	Toggle(null)

func GetPrompt() -> String:
	if not CanInteract(null):
		return super.GetPrompt()
	
	if bIsOpen:
		return "Close %s" % sEntityName
	
	return "Open %s" % sEntityName

func Toggle(oInteractor: Node):
	if bIsAnimating:
		return
	
	bIsAnimating = true
	
	var iTargetRotation: float = 0.0
	if not bIsOpen:
		iTargetRotation = iOpenedAngle
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(oDoorPivot, "rotation_degrees:y", iTargetRotation, iAnimationDuration)
	tween.finished.connect(OnToggleFinished)
	
	bIsOpen = not bIsOpen

func OnToggleFinished() -> void:
	bIsAnimating = false
