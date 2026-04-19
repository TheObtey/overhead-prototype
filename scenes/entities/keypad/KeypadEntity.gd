class_name KeypadEntity
extends EntityBase

@export var keypadUI = preload("res://scenes/entities/keypad/KeypadUI.tscn") 
@export var keypadCode: int = 0121

var codeIsCorrect: bool = false

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	super.Interact(oInteractor)
	OpenCode(null)

func GetPrompt() -> String:
	if not CanInteract(null):
		return super.GetPrompt()
	
	if codeIsCorrect:
		return "Close Keypad"
	
	return "Open Keypad"

func OpenCode(oInteractor: Node):
	var instance = keypadUI.instantiate()
	add_child(instance)
	
	codeIsCorrect = not codeIsCorrect
	return
