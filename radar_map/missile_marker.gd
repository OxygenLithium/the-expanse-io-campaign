extends Polygon2D

var markerTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$/root/Node/map_canvas/radar_map.cameraLockable.push_back(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !markerTarget:
		get_parent().cameraLockable.erase(self)
		queue_free()
	else:
		rotation = markerTarget.rotation
		position = Vector2(600,600) + markerTarget.position/100
