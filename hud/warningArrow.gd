extends Label

@export var pivot : Node2D
var target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_instance_valid(target) or !is_instance_valid($/root/Node/player):
		queue_free()
		return
	pivot.rotation = (target.global_position - $/root/Node/player.global_position).angle()
