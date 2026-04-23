class_name LocalPlayerDeviceBinding
extends RefCounted

enum BindingType {
	KEYBOARD_MOUSE,
	JOYPAD
}

var enumBindingType: BindingType
var iJoypadDeviceID: int = -1

static func CreateKeyboardMouse() -> LocalPlayerDeviceBinding:
	var oBinding = LocalPlayerDeviceBinding.new()
	oBinding.enumBindingType = BindingType.KEYBOARD_MOUSE
	oBinding.iJoypadDeviceID = -1
	
	return oBinding

static func CreateJoypad(iDeviceID: int) -> LocalPlayerDeviceBinding:
	var oBinding = LocalPlayerDeviceBinding.new()
	oBinding.enumBindingType = BindingType.JOYPAD
	oBinding.iJoypadDeviceID = iDeviceID
	
	return oBinding
