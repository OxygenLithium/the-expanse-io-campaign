extends Polygon2D

var markerTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().cameraLockable2.push_back(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !markerTarget:
		get_parent().cameraLockable2.erase(self)
		queue_free()
	else:
		rotation = markerTarget.rotation
		position = Vector2(600,600) + (markerTarget.position-get_parent().mapCenter)/get_parent().mapScale
		if abs(position.x - 600) > 600 or abs(position.y-600) > 600:
			visible = false
		else:
			visible = true
