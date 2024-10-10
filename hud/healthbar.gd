extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func recalculate(health,maxhealth):
	value = health*100/maxhealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
