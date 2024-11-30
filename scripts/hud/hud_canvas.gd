extends CanvasLayer

@export var autotrack_label : Label
@export var target_label : Label
@export var health_bar : ProgressBar
@export var missile_ammo_bar : ProgressBar
@export var g_limit_bar : ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	
func player_death():
	visible = false
	
func victory():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
