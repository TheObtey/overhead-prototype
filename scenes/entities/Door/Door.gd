extends EntityBase

var isOpen = false

func GetPrompt() -> String:
	if isOpen == false:
		return "Ouvrir " + sEntityName
	else:
		return "Fermer " + sEntityName

func Interact(pPlayer: CharacterBody3D) -> void:
	if isOpen == false:
		isOpen = true
		print("Ouverture de la porte")
	else:
		isOpen = false
		print("Fermeture de la porte")
