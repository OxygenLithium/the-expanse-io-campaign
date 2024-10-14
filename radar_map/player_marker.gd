extends Polygon2D

@onready var markerTarget = get_node("/root/Node/player")

var markers = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$/root/Node/map_canvas/radar_map.cameraLockable.push_back(self)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !markerTarget:
		queue_free()
		return
	rotation = markerTarget.rotation
	position = Vector2(600,600) + markerTarget.position/100
