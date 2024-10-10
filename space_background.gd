extends TextureRect

var player = "/root/Node/player"
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node(player):
		position = Vector2(-1500,-1000) + get_node(player).position
		velocity = get_node(player).velocity
	else:
		position += velocity
