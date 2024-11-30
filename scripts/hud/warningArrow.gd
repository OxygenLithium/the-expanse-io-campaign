extends Label

@export var pivot : Node2D
@export var arrow : Polygon2D
var target
var targetType = null

func _ready():
	if "type" in target:
		targetType = target.type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_instance_valid(target) or !is_instance_valid($/root/Node.game_map.player):
		queue_free()
		return
	if targetType == "bullet" and target.velocity.dot($/root/Node.game_map.player.global_position - target.global_position) < 0:
		visible = false
		arrow.visible = false
	else:
		visible = true
		arrow.visible = true
	var relDistance = target.global_position - $/root/Node.game_map.player.global_position
	pivot.rotation = relDistance.angle()
	arrow.scale = Vector2(24.0,24.0)/sqrt(max(500,relDistance.length()))
