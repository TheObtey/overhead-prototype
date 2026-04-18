extends EntityBase

var bIsActivated = false
signal sActivated

func GetPrompt() -> String:
	if bIsActivated == false:
		return "Ouvrir la porte"
	else:
		return "Fermer la porte"

func Interact(pPlayer: CharacterBody3D) -> void:
	bIsActivated = !bIsActivated
	sActivated.emit()
