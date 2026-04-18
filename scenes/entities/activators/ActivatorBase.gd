class_name ActivatorBase
extends EntityBase

@export var tTargets: Array[ActivationTarget] = []
@export var sPrompt: String = "Interact with me!"
@export var bTriggerOnce: bool = false

var bHasBeenTriggered: bool = false

func CanInteract(oInteractor: Node) -> bool:
	if not super.CanInteract(oInteractor):
		return false
	
	if bTriggerOnce and bHasBeenTriggered:
		return false
	
	return true

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	super.Interact(oInteractor)
	_TriggerTargets(oInteractor)
	
	if bTriggerOnce:
		bHasBeenTriggered = true

func _TriggerTargets(oInteractor: Node) -> void:
	for entry in tTargets:
		if entry == null:
			continue
		
		var oTarget = get_node_or_null(entry.TargetPath)
		if oTarget == null:
			push_warning("%s: invalid target" % name)
			continue
		
		if not oTarget.has_method("Toggle"):
			push_warning("%s: target '%s' has no method 'toggle'" % [name, oTarget.name])
			continue
		
		var tArgs: Array = [oInteractor]
		tArgs.append_array(entry.tExtraArgs)
		
		oTarget.callv("Toggle", tArgs)

func GetPrompt() -> String:
	if bTriggerOnce and bHasBeenTriggered:
		return ""
	
	return sPrompt
