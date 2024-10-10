extends Polygon2D

var player = "/root/Node/player"

var markers = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_node(player):
		queue_free()
		return
	rotation = get_node(player).rotation
	position = Vector2(600,600) + get_node(player).position/100
