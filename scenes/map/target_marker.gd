extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var playerTarget = get_parent().get_parent().get_parent().player.target
	if playerTarget == null || !is_instance_valid(playerTarget) || not "marker" in playerTarget:
		visible = false
	else:
		visible = true
		position = playerTarget.marker.position
