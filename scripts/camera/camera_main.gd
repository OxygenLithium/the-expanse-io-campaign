extends Camera2D

var player = null
var target = null
var prevTarget = null

var trauma = 0
var maxRoll = 0.05
@onready var noise = FastNoiseLite.new()
var noise_y = 0

var shakeOffset = Vector2(0,0)

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
	randomize()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = 52
	noise.frequency = 0.1

func incrementTrauma(amount):
	trauma = min(trauma + amount, 10)

func shake():
	var amount = sqrt(trauma)
	noise_y += 1
	rotation = maxRoll * noise.get_noise_2d(noise.seed, noise_y)
	shakeOffset.x = 150 * amount * noise.get_noise_2d(noise.seed, noise_y)
	shakeOffset.y = 150 * amount * noise.get_noise_2d(noise_y, noise.seed)

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
	
	position = target.position + shakeOffset
	if get_parent().inGame:
		get_parent().game_map.map_canvas.offset = -shakeOffset/5
		get_parent().game_map.hud_canvas.offset = -shakeOffset/5
		get_parent().game_map.message_canvas.offset = -shakeOffset/5
	
	if trauma > 0:
		shake()
		trauma -= min(0.2,trauma)
	else:
		shakeOffset = Vector2(0,0)
		rotation = 0
 
