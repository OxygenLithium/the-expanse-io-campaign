extends Polygon2D

@onready var markerTarget

var markers = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	markerTarget = get_parent().get_parent().get_parent().player
	get_parent().cameraLockable.push_back(self)
	return

var stop_execution = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stop_execution:
		return
	if !markerTarget or !is_instance_valid(markerTarget):
		get_parent().cameraLockable.erase(self)
		queue_free()
		return
	rotation = markerTarget.rotation
	position = Vector2(600,600) + (markerTarget.position-get_parent().mapCenter)/get_parent().mapScale
	if abs(position.x - 600) > 600 or abs(position.y-600) > 600:
		visible = false
	else:
		visible = true
		
