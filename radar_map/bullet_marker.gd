extends Polygon2D

var bullet

var markers = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !bullet:
		queue_free()
	else:
		rotation = bullet.rotation
		position = Vector2(600,600) + bullet.position/100
