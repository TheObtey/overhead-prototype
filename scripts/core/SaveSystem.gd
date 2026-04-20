extends Node

	## Called when the node enters the scene tree for the first time.
	#func _ready() -> void:
		#pass # Replace with function body.
#
	## Called every frame. 'delta' is the elapsed time since the previous frame.
	#func _process(delta: float) -> void:
		#pass

class SaveSystem :
	# ----- Field
	var oData : SaveData
	
	# ----- Methods
	# Method to save current data into a JSON file
	func Save(sPath : String) -> bool:
		if oData == null || sPath == null:
			return false
			
		oData.SAVE_PATH = sPath
		
		var oSaveDataFile : FileAccess = FileAccess.open(oData.sPath, FileAccess.WRITE)
		
		if oSaveDataFile == null:
			return false
			
		var sJsonData : String = JSON.stringify(oData.GetDictionary())

		oSaveDataFile.store_line(sJsonData)
		return true
	
	# Method to load save data from a JSON file
	func Load(sPath : String) -> bool:
		var file = FileAccess.open(sPath, FileAccess.READ)
		if file == null:
			return false

		var json : JSON = JSON.new()
		var res : Error = json.parse(file.get_as_text())
		if res != OK:
			return false
			
		var tLoad : Dictionary = json.data
		if tLoad == null:
			return false
		
		oData.SetDictionary(tLoad)
		return true
