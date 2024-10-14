extends Camera2D

@onready var player = get_node("/root/Node/player")
@onready var target = get_node("/root/Node/player")
var prevTarget = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !target:
		if target == prevTarget:
			prevTarget = null
		if player:
			target = player
	else:
		position = target.position
