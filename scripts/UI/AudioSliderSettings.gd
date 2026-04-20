extends Control

@onready var labelAudioName = $HBoxContainer/Audio_Name as Label
@onready var labelAudioNum = $HBoxContainer/Audio_Num as Label
@onready var sliderAudioSetting = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var sBusName: String

var iBusIndex : int = 0

func _ready() -> void:
	sliderAudioSetting.value_changed.connect(on_value_changed)
	_getBusNameByIndex()
	_setNameLabelText()
	_setSliderValue()

func _setNameLabelText() -> void:
	labelAudioName.text = str(sBusName) + " Volume"

func _setNumLabelText() -> void:
	labelAudioNum.text = str(sliderAudioSetting.value * 100) + "%"

func _getBusNameByIndex() -> void:
	iBusIndex = AudioServer.get_bus_index(sBusName)

func _setSliderValue() -> void:
	sliderAudioSetting.value = db_to_linear(AudioServer.get_bus_volume_db(iBusIndex))
	_setNumLabelText()

func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(iBusIndex, linear_to_db(value))
	_setNumLabelText()
