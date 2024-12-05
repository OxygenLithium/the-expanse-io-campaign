extends Camera2D

var player = null
var target = null
var prevTarget = null

func gameStart(player):
	self.player = player
	target = player

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

func closeGame():
	player = null
	target = null
	prevTarget = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_parent().inGame:
		position = Vector2(0,0)
		return
	
	if !target:
		if target == prevTarget:
			prevTarget = null
		if player:
			target = player
		else:
			target = null
		return
	
	position = target.position
