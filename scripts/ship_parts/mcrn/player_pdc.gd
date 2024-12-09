extends Node2D

@export var pivot : Node2D
@export var marker : Marker2D

@onready var shooter = get_parent()

var currPDCTargetAngle = 0
var prevPDCTargetAngle = 0
var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().pdcs.append(self)
	pivot.rotation -= rotation
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
	active = true
	if get_parent().PDCAutotrack:
		if get_parent().PDCTarget and is_instance_valid(get_parent().PDCTarget):
			currPDCTargetAngle = (get_parent().PDCTarget.global_position-global_position).angle()
			if abs(currPDCTargetAngle - prevPDCTargetAngle) < PI/30 or abs(currPDCTargetAngle - prevPDCTargetAngle) > 59*PI/30:
				pivot.look_at(get_parent().PDCTarget.global_position)
			else:
				var firstApproxPosition = approximateLead(predictTime(get_parent().PDCTarget))
				pivot.look_at(get_parent().PDCTarget.global_position + firstApproxPosition + get_parent().velocity/60)
			prevPDCTargetAngle = currPDCTargetAngle
	else:
		if $/root/Node.game_map.map_canvas.visible:
			pivot.look_at((get_global_mouse_position()-$/root/Node.mainCamera.target.position)*$/root/Node.game_map.map_canvas.radar_map.mapScale + $/root/Node.game_map.map_canvas.radar_map.mapCenter + shooter.velocity/60)
		else:
			pivot.look_at(get_global_mouse_position() + shooter.velocity/60)
	
	if (fmod(pivot.rotation,2*PI) > 0) and (fmod(pivot.rotation,2*PI) < PI):
		pivot.rotation = 0
		active = false
	elif fmod(pivot.rotation,2*PI) < -PI:
		pivot.rotation = 0
		active = false
