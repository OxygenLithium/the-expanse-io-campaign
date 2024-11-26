extends Polygon2D

var markerTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$/root/Node/map_canvas/radar_map.cameraLockable.push_back(self)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !markerTarget or !is_instance_valid(markerTarget):
		$/root/Node/map_canvas/radar_map.cameraLockable.erase(self)
		queue_free()
		return
	rotation = markerTarget.rotation
	position = Vector2(600,600) + (markerTarget.position-$/root/Node/map_canvas/radar_map.mapCenter)/$/root/Node/map_canvas/radar_map.mapScale
	if abs(position.x - 600) > 600 or abs(position.y-600) > 600:
		visible = false
	else:
		visible = true 
