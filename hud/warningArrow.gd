extends Label

@export var pivot : Node2D
@export var arrow : Polygon2D
var target

func _ready():
	if "type" in target:
		print(target.type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_instance_valid(target) or !is_instance_valid($/root/Node/player):
		queue_free()
		return
	var relDistance = target.global_position - $/root/Node/player.global_position
	pivot.rotation = relDistance.angle()
	arrow.scale = Vector2(24.0,24.0)/sqrt(max(500,relDistance.length()))
