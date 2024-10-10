extends Camera2D

var player = "/root/Node/player"

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node(player):
		position = get_node(player).position
		velocity = get_node(player).velocity
	else:
		position += velocity
