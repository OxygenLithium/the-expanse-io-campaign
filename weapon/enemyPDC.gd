extends Node2D


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
	if get_parent().PDCTarget and is_instance_valid(get_parent().PDCTarget):
		var firstApproxPosition = approximateLead(predictTime(get_parent().PDCTarget))
		look_at(get_parent().PDCTarget.global_position + firstApproxPosition + get_parent().velocity/60)
	pass
