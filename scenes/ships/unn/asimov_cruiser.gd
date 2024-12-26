extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Asimov-class Cruiser"
var displayName = ""

#Railgun stuff
@export var railgun : Node2D
var railgunRoundFile = load("res://scenes/projectiles/unn/enemyRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://scenes/map/railgun_round_marker.tscn")
var railgunWarning = load("res://scenes/hud/railgunWarning.tscn")
var railgunTimer = rng.randi_range(0,150)
const railgunMaxRange = 30000
const railgunMinRange = 10000

var railgunRoundSpeed = 20000

func special_init():
	health = 250
	railgunResistance = 2
	acceleration = 1.5
	standardAcceleration = 1.5
	PDCTargetingEffectiveness = 7
	turnSpeed = rng.randf_range(PI/960, PI/480)
	
	canDodge = false
	
	missileShootTimes = [1155, 1170, 1185, 1200]
	
func shoot_railgun():
	var railgunRound = railgunRoundFile.instantiate()
	railgunRound.allegiance = "UNN"
	railgunRound.rotation = railgun.rotation + rotation
	railgunRound.position = railgun.global_position + velocity/60 + Vector2(100,0).rotated(railgunRound.rotation)
	
	get_parent().add_child(railgunRound)
	railgunRound.velocity = velocity
	railgunRound.velocity += Vector2(railgunRoundSpeed,0).rotated(railgunRound.rotation)
	railgunRound.set_visible(true)
	
	var railgun_round_marker = railgunRoundMarkerFile.instantiate()
	railgun_round_marker.markerTarget = railgunRound
	get_parent().map_canvas.radar_map.add_child(railgun_round_marker)
	
	if target == get_parent().player:
		var railgun_warning = railgunWarning.instantiate()
		railgun_warning.target = railgunRound
		get_parent().hud_canvas.add_child(railgun_warning)
	
	if "targeted_by_railgun()" in target:
		target.targeted_by_railgun()

func calc_railgun_lead():
	var closingVelocity = getClosingVelocity()
	if "acceleration" in target:
		return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity)) + Vector2(target.acceleration,0).rotated(target.rotation)*(((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))**2)*30
	return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))

func movementAlgorithm():
	acceleration = 0.75
	if relativeDisplacement.length() < 16000:
		weightedNavigation(target, true)
	elif relativeDisplacement.length() < 28000 and relativeVelocity.length() < 50:
		shouldAccelerate = false
		desiredRotation = relativeDisplacement.angle()
		velocity += Vector2(0.3,0).rotated(relativeVelocity.angle())
	else:
		var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-(railgunMaxRange+railgunMinRange)/2-relativeVelocity.length()*PI/turnSpeed/60))
		weightedNavigation(target, shouldDecelerate)
	

func special_actions():
	railgun.look_at(target.global_position + calc_railgun_lead())
	railgunTimer += 1
	if railgunTimer > 900 and (target.global_position-global_position).length() < railgunMaxRange and (target.global_position-global_position).length() > railgunMinRange:
		railgunRoundSpeed = (target.global_position-global_position).length()
		shoot_railgun()
		railgunTimer = rng.randi_range(0,60)
	pass
