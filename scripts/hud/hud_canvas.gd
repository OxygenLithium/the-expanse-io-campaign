extends CanvasLayer

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
