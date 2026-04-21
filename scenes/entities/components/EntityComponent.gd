class_name EntityComponent
extends Node

# Base hook class for entity-driven interactions.
# Subclasses can veto interaction, react to interaction,
# and optionally override the interaction prompt.
func CanInteract(oInteractor: Node) -> bool:
	return true

# Called by `EntityBase` once interaction is accepted.
func OnInteract(oInteractor: Node) -> void:
	pass

# Returns a custom prompt string or empty to use default.
func GetPromptOverride() -> String:
	return ""
