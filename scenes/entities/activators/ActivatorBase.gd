class_name ActivatorBase
extends EntityBase

# Base activator entity that calls `Toggle(interactor, ...)`
# on configured targets when interacted with.
@export var tTargets: Array[ActivationTarget] = []
@export var bTriggerOnce: bool = false

var bHasBeenTriggered: bool = false

# --------------------------------------------------
# Extends base interaction validation.
# Prevents interaction if the activator is set to
# trigger only once and has already been used.
# --------------------------------------------------
func CanInteract(oInteractor: Node) -> bool:
	if not super.CanInteract(oInteractor):
		return false
	
	if bTriggerOnce and bHasBeenTriggered:
		return false
	
	return true

# --------------------------------------------------
# Main interaction logic.
# Calls base interaction, then triggers all targets.
# Optionally disables future interactions if set to
# trigger only once.
# --------------------------------------------------
func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	super.Interact(oInteractor)
	_TriggerTargets(oInteractor)
	
	if bTriggerOnce:
		bHasBeenTriggered = true

# --------------------------------------------------
# Iterates over all configured targets and calls
# their "Toggle" method.
# Automatically injects the interactor as first arg,
# then appends any extra arguments defined in editor.
# --------------------------------------------------
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


# --------------------------------------------------
# Returns the interaction prompt.
# Hides it if the activator is single-use and already
# triggered.
# --------------------------------------------------
func GetPrompt() -> String:
	if bTriggerOnce and bHasBeenTriggered:
		return ""
	
	return sPrompt
