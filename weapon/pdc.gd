extends Node2D

var shooter = "/root/Node/player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $/root/Node/map_canvas.visible:
		look_at((get_global_mouse_position()-get_parent().position)*100 + get_node(shooter).velocity/60)
	else:
		look_at(get_global_mouse_position() + get_node(shooter).velocity/60)
