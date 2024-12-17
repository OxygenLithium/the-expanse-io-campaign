extends Node2D

var markerTarget
var isTarget = false

@export var markerIcon : Polygon2D
@export var markerLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().cameraLockable.push_back(self)
	markerLabel.text = markerTarget.displayName
	
	isTarget = (markerTarget == get_parent().get_parent().get_parent().target or get_parent().get_parent().get_parent().targets.has(markerTarget))
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !isTarget:
		markerLabel.visible = get_parent().showNames
	
	if !markerTarget or !is_instance_valid(markerTarget):
		get_parent().cameraLockable.erase(self)
		queue_free()
		return
	markerIcon.rotation = markerTarget.rotation
	position = Vector2(600,600) + (markerTarget.position-get_parent().mapCenter)/get_parent().mapScale
	if abs(position.x - 600) > 600 or abs(position.y-600) > 600:
		visible = false
	else:
		visible = true 
