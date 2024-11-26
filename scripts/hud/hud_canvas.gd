extends CanvasLayer

@export var health_bar : ProgressBar
@export var mission_failed : Node2D
@export var mission_accomplished : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.visible = true
	mission_failed.visible = false
	mission_accomplished.visible = false
	pass # Replace with function body.
	
func player_death():
	health_bar.visible = false
	mission_failed.visible = true
	
func victory():
	health_bar.visible = false
	mission_accomplished.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
