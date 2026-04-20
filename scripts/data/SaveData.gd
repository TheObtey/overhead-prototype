class_name SaveData
extends Node

# --------------------------------------------------------------------------
var sPath : String = "user://SaveData.save"

# --- Saveable data
# Window-related
var vecWindowRes : Vector2
var sWindowMode : String

# Volume-related
var iMasterVolume : float
var iSfxVolume : float
var iMusicVolume : float

# Progression-related
var sLastRoom : String
var tProgression : Dictionary
var tInventory : Dictionary

# Method which creates a Dictionary that regroups every data in class
func GetDictionary() -> Dictionary:
	var toReturn : Dictionary = {
		"window_resolution" : vecWindowRes,
		"window_mode" : sWindowMode,
		"master_volume" : iMasterVolume,
		"sfx_volume" : iSfxVolume,
		"music_volume" : iMusicVolume,
		"last_room" : sLastRoom,
		"progression" : {
			"hub" : tProgression["hub"],
			"staffroom" : tProgression["staffroom"],
			"restaurant" : tProgression["restaurant"],
		},
		"inventory" : tInventory
	}
	return toReturn

# Method which stores every data in class
func SetDictionary(tDict : Dictionary) -> void:
	vecWindowRes = tDict["window_resolution"]
	sWindowMode = tDict["window_mode"]
	iMasterVolume = tDict["master_volume"]
	iSfxVolume = tDict["sfx_volume"]
	iMusicVolume = tDict["music_volume"]
	sLastRoom = tDict["last_room"]
	tProgression = tDict["progression"]
	tInventory = tDict["inventory"]
	return
