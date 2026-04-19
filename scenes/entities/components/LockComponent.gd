class_name LockComponent
extends EntityComponent

@export var bLocked: bool = false
@export var sLockedPrompt: String = "Locked"

func CanInteract(oInteractor: Node) -> bool:
	return not bLocked

func GetPromptOverride() -> String:
	if bLocked:
		return sLockedPrompt
	return ""

func Lock() -> void:
	bLocked = true

func Unlock() -> void:
	bLocked = false

func ToggleLock() -> void:
	bLocked = not bLocked
