extends Camera2D

@onready var player = get_node("/root/Node/player")
@onready var target = get_node("/root/Node/player")
var prevTarget = null

func getTarget():
	if is_instance_valid(target):
		return target
	if is_instance_valid(prevTarget):
		target = prevTarget
		prevTarget = null
	return null
	
func setTarget(newTarget):
	target = newTarget
	
func setPrevTarget(newTarget):
	prevTarget = newTarget

func getPrevTarget():
	if is_instance_valid(prevTarget):
		return prevTarget
	prevTarget = null
	return null

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
			target = null
		return
	
	position = target.position
