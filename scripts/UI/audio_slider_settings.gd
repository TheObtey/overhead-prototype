extends Control

@onready var audioNameLabel = $HBoxContainer/Audio_Name as Label
@onready var audioNumLabel = $HBoxContainer/Audio_Num as Label
@onready var audioSlider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name: String

var iBusIndex : int = 0

func _ready() -> void:
	audioSlider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	set_name_label_text()
	set_slider_value()

func set_name_label_text() -> void:
	audioNameLabel.text = str(bus_name) + " Volume"

func set_num_label_text() -> void:
	audioNumLabel.text = str(audioSlider.value * 100) + "%"

func get_bus_name_by_index() -> void:
	iBusIndex = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void:
	audioSlider.value = db_to_linear(AudioServer.get_bus_volume_db(iBusIndex))
	set_num_label_text()

func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(iBusIndex, linear_to_db(value))
	set_num_label_text()
