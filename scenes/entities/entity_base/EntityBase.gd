class_name EntityBase
extends Node3D

# Generic interactable world entity.
# It centralizes interaction flow and delegates specialized
# behavior to children under the `Components` node.
@export var sEntityName: String = "Entity"
@export var bCanInteract: bool = true
@export var sPrompt: String = "Interact with me!"

@onready var oVisuals: Node3D = $Visuals
@onready var oComponents: Node = $Components

# --------------------------------------------------
# Checks if the entity can be interacted with.
# It first validates the entity itself, then asks every
# attached component. If any component refuses, the
# interaction is blocked.
# --------------------------------------------------
func CanInteract(oInteractor: Node) -> bool:
	if not bCanInteract:
		return false
	
	if oComponents != null:
		for oComponent in oComponents.get_children():
			if not oComponent is EntityComponent:
				continue
			
			if not oComponent.CanInteract(oInteractor):
				return false
	
	return true

# --------------------------------------------------
# Main interaction entry point.
# Called when the player interacts with the entity.
# If allowed, the interaction is forwarded to all
# components so each can react independently.
# --------------------------------------------------
func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	for oComponent in oComponents.get_children():
		if oComponent is EntityComponent:
			oComponent.OnInteract(oInteractor)

# --------------------------------------------------
# Returns the interaction prompt shown to the player.
# Components can override the prompt dynamically.
# If none provides one, the default prompt is used.
# --------------------------------------------------
func GetPrompt() -> String:
	for oComponent in oComponents.get_children():
		if oComponent is EntityComponent:
			var sCustomPrompt = oComponent.GetPromptOverride()
			if sCustomPrompt != "":
				return sCustomPrompt
	
	return sPrompt

func GetName() -> String:
	return sEntityName
