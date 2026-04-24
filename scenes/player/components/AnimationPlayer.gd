extends AnimationPlayer

class_name AnimationHandler

@onready var oEmptyHand: Node3D = $"../charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Hand_R"
@onready var oGunPart1: Node3D =  $"../charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/HandGun_R"
@onready var oGunPart2: Node3D = $"../charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Battery_and_Tape"
@onready var oGunHand: Node3D = $"../charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Canon"
@onready var oHandsPivot: Node3D = $"../charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay"

static var bHasGun : Array[bool] = [false,false]
static var bChangeCamPitch : Array[bool] = [false,false]
static var iCamPitch :Array[float] = [0.0,0.0]
@onready var bIsGunDisplayed : Array[bool] = [false,false]

enum AnimState {WALK, RUN, JUMP, POINT, SHOOT, IDLE, NONE}

static var enumNewStatePlayer : Array = [AnimState.NONE,AnimState.NONE]
@onready var enumCurrentState : Array = [AnimState.IDLE,AnimState.IDLE]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func UpdatePlayer(iPlayerID : int) -> void:
	if bIsGunDisplayed[iPlayerID] != bHasGun[iPlayerID]:
		SwitchDisplayedHand(iPlayerID)
	if bChangeCamPitch[iPlayerID] == true:
		ChangeCameraPitch(-iCamPitch[iPlayerID],iPlayerID)
	
	if is_playing() == false:
		enumCurrentState[iPlayerID] = AnimState.NONE
	if enumNewStatePlayer[iPlayerID] == enumCurrentState[iPlayerID]:
		pass
	match enumNewStatePlayer[iPlayerID]:
		AnimState.JUMP:
			JumpAnimation(iPlayerID)
		AnimState.POINT:
			PointAnimation(iPlayerID)
		AnimState.SHOOT:
			ShootAnimation(iPlayerID)
		AnimState.RUN:
			StartRunningAnim(iPlayerID)
		AnimState.WALK:
			StartWalkingAnim(iPlayerID)
		AnimState.IDLE:
			StartIdleAnim(iPlayerID)
	pass

func UpdatePlayer2() -> void:
	
	pass

func ChangeCameraPitch(iPitch : float,iPlayerID : int) -> void :
	oHandsPivot.rotation.x = iPitch
	bChangeCamPitch[iPlayerID] = false
	pass

static func SetCamPitch(iPitch : float,iPlayerID : int) -> void :
	bChangeCamPitch[iPlayerID] = true
	iCamPitch[iPlayerID] = iPitch
	pass

func SwitchDisplayedHand(iPlayerID: int) -> void:
	match AnimationHandler.bHasGun[iPlayerID]:
		true:
			bIsGunDisplayed[iPlayerID] = true
			oGunPart1.visible = true
			oGunPart2.visible = true
			oGunHand.visible = true
			oEmptyHand.visible = false
		false:
			bIsGunDisplayed[iPlayerID] = false
			oEmptyHand.visible = true
			oGunPart1.visible = false
			oGunPart2.visible = false
			oGunHand.visible = false

func ShootAnimation(iPlayerID :int) -> void :
	# wait for anim
	pass

func PointAnimation(iPlayerID:int) -> void :
	match enumCurrentState[iPlayerID]:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState[iPlayerID] = AnimState.POINT;
	play("PlayerAnimation/Point")
	pass

func JumpAnimation(iPlayerID:int) -> void :
	match enumCurrentState[iPlayerID]:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState[iPlayerID] = AnimState.JUMP
	play("PlayerAnimation/Jump")
	pass
	
func StartWalkingAnim(iPlayerID:int) -> void :
	match enumCurrentState[iPlayerID]:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState[iPlayerID] = AnimState.WALK
	play("PlayerAnimation/Walk")
	pass

func StartRunningAnim(iPlayerID:int) -> void :
	match enumCurrentState[iPlayerID]:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState[iPlayerID] = AnimState.RUN
	play("PlayerAnimation/Run")
	pass

func StartIdleAnim(iPlayerID:int) -> void :
	match enumCurrentState[iPlayerID]:
		AnimState.JUMP:
			return
		AnimState.POINT:
			return
	enumCurrentState[iPlayerID] = AnimState.IDLE
	play("PlayerAnimation/Idle")
	pass
	
func StopCurrentAnim(iPlayerID:int) -> void :
	stop();
	enumCurrentState[iPlayerID] = AnimState.NONE
	pass
	
