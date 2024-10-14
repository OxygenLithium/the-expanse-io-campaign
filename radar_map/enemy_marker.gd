extends Polygon2D

@onready var markerTarget = get_node("/root/Node/enemy_ship")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$/root/Node/map_canvas/radar_map.cameraLockable.push_back(self)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !markerTarget:
		return
	rotation = markerTarget.rotation
	position = Vector2(600,600) + markerTarget.position/100
