class_name EntityBase
extends Node3D

@export var sEntityName: String = "Entity"
@export var bCanInteract: bool = true
@export var sPrompt: String = "Interact with me!"

@onready var oVisuals: Node3D = $Visuals
@onready var oComponents: Node = $Components

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

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	for oComponent in oComponents.get_children():
		if oComponent is EntityComponent:
			oComponent.OnInteract(oInteractor)

func GetPrompt() -> String:
	for oComponent in oComponents.get_children():
		if oComponent is EntityComponent:
			var sCustomPrompt = oComponent.GetPromptOverride()
			if sCustomPrompt != "":
				return sCustomPrompt
	
	return sPrompt
