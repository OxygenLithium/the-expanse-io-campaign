extends Node2D

var shooter = "/root/Node/player"

var currPDCTargetAngle = 0
var prevPDCTargetAngle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func predictTime(target, targetPosition = null):
	if !targetPosition:
		targetPosition = target.global_position
	var relDistance = targetPosition - global_position
	var relVelocity = target.velocity - get_parent().velocity
	var closingVelocity = relVelocity.dot(relDistance)/relDistance.dot(relDistance)*relDistance
	if relDistance.dot(relVelocity) < 0:
		return relDistance.length()/(3000+closingVelocity.length())
	return relDistance.length()/(3000-closingVelocity.length())

func approximateLead(predictedTime):
	var relativeVelocity = get_parent().PDCTarget.velocity - get_parent().velocity
	if "acceleration" in get_parent().PDCTarget:
		return relativeVelocity/60*predictedTime + Vector2(get_parent().PDCTarget.acceleration,0).rotated(get_parent().PDCTarget.rotation)/60*(predictedTime)**2/2
	
	return relativeVelocity/60*predictedTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().PDCAutotrack:
		if get_parent().PDCTarget and is_instance_valid(get_parent().PDCTarget):
			currPDCTargetAngle = (get_parent().PDCTarget.global_position-global_position).angle()
			if abs(currPDCTargetAngle - prevPDCTargetAngle) < PI/30 or abs(currPDCTargetAngle - prevPDCTargetAngle) > 59*PI/30:
				look_at(get_parent().PDCTarget.global_position)
			else:
				var firstApproxPosition = approximateLead(predictTime(get_parent().PDCTarget))
				look_at(get_parent().PDCTarget.global_position + firstApproxPosition + get_parent().velocity/60)
			prevPDCTargetAngle = currPDCTargetAngle
	else:
		if $/root/Node/map_canvas.visible:
			look_at((get_global_mouse_position()-$/root/Node/mainCamera.target.position)*$/root/Node/map_canvas/radar_map.mapScale + $/root/Node/map_canvas/radar_map.mapCenter + get_node(shooter).velocity/60)
		else:
			look_at(get_global_mouse_position() + get_node(shooter).velocity/60)
