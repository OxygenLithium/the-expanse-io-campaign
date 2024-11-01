extends CanvasLayer

var toggleDelay = 0

@export var radar_map : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radar_map.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if toggleDelay == 0 && Input.is_action_pressed("key_m"):
		set_visible(!visible)
		toggleDelay = 10
	
	if (toggleDelay > 0):
		toggleDelay -= 1
