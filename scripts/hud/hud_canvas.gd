extends CanvasLayer

@export var autotrack_label : Label
@export var target_label : Label
@export var health_bar : ProgressBar
@export var missile_ammo_bar : ProgressBar
@export var g_limit_bar : ProgressBar
@export var no_missile_target_warning : Label

var noMissileTargetWarningTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	no_missile_target_warning.visible = false
	
func player_death():
	visible = false
	
func victory():
	visible = false
	
func noMissileTargetWarningOn():
	no_missile_target_warning.visible = true
	noMissileTargetWarningTimer = 15

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if noMissileTargetWarningTimer > 0:
		noMissileTargetWarningTimer -= 1
	else:
		no_missile_target_warning.visible = false
