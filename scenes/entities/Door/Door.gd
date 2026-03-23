extends "res://scenes/entities/EntityBase.gd"

var isOpen = false

func GetPrompt() -> String:
	return "Ouvrir " + sEntityName

func Interact(pPlayer: CharacterBody3D) -> void:
	if isOpen == false:
		isOpen = true
		print("Ouverture de la porte")
	else:
		isOpen = false
		print("Fermeture de la porte")
