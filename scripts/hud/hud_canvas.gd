extends CanvasLayer

@export var autotrack_label : Label
@export var target_label : Label
@export var health_bar : ProgressBar
@export var missile_ammo_bar : ProgressBar
@export var g_limit_bar : ProgressBar
@export var no_missile_target_warning : Label
@export var mission_status : Label

@export var missile_ammo_bars : Array[ProgressBar]
@export var missile_ammo_icons : Array[Sprite2D]

var noMissileTargetWarningTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	no_missile_target_warning.visible = false
	
func player_death():
	visible = false
	
func victory():
	visible = false
	
func tooClose():
	no_missile_target_warning.text = "Target too close for missiles"
	no_missile_target_warning.visible = true
	noMissileTargetWarningTimer = 15
	
func badAngle():
	no_missile_target_warning.text = "Angle to target is too extreme"
	no_missile_target_warning.visible = true
	noMissileTargetWarningTimer = 15
	
func tooFar():
	no_missile_target_warning.text = "Target is out of missile range"
	no_missile_target_warning.visible = true
	noMissileTargetWarningTimer = 15
	
func noMissileTargetWarningOn():
	no_missile_target_warning.text = "No missile target selected"
	no_missile_target_warning.visible = true
	noMissileTargetWarningTimer = 15

func setMissileAmmoBar(replenish):
	for i in range(6):
		if replenish >= 180*(i+1):
			missile_ammo_bars[i].value = 180
			missile_ammo_icons[i].self_modulate = "#ffffff"
		else:
			missile_ammo_bars[i].value = replenish - 180*i
			missile_ammo_icons[i].self_modulate = "#7bff00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if noMissileTargetWarningTimer > 0:
		noMissileTargetWarningTimer -= 1
	else:
		no_missile_target_warning.visible = false
