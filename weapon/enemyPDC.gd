extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func approximateLead(predictedTime):
	var relativeVelocity = get_parent().pdcTarget.velocity - get_parent().velocity
	if "acceleration" in get_parent().pdcTarget:
		return relativeVelocity/60*predictedTime + Vector2(get_parent().pdcTarget.acceleration,0).rotated(get_parent().pdcTarget.rotation)/60*(predictedTime)**2/2
	
	return relativeVelocity/60*predictedTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().pdcTarget and is_instance_valid(get_parent().pdcTarget):
		var firstApproxPosition = approximateLead((get_parent().pdcTarget.global_position - get_parent().global_position).length()/60)
		look_at(get_parent().pdcTarget.global_position + approximateLead(firstApproxPosition.length()/60) + get_parent().velocity/60)
	pass
