extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Munroe-class Frigate"
var displayName

#railgun files
var railgunRoundFile = load("res://scenes/projectiles/unn/enemyRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://scenes/map/railgun_round_marker.tscn")
var railgunWarning = load("res://scenes/hud/railgunWarning.tscn")

#railgun AI handling
var railgunTimer = rng.randi_range(0,150)
var railgunRoundSpeed = 10000
const railgunMaxRange = 25000
const railgunMinRange = 5000
var railgunAiming = false

func special_init():
	health = 25
	missileShootTimes = []
	PDCLockDistance = 2500
	desiredDistance = 0
	
func calc_railgun_lead():
	var closingVelocity = getClosingVelocity()
	if "acceleration" in target:
		return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity)) + Vector2(target.acceleration,0).rotated(target.rotation)*(((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))**2)*30
	return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))

func special_actions():
	railgunTimer += 1
	if railgunTimer > 900 and (target.global_position-global_position).length() < railgunMaxRange and (target.global_position-global_position).length() > railgunMinRange:
		railgunAiming = true
		shouldAccelerate = false
		var diffRotation = getDiffRotation()
		if abs(diffRotation) < PI/180:
			shoot_railgun()
			railgunTimer = rng.randi_range(0,60)
	else:
		railgunAiming = false
	
func shoot_railgun():
	var railgunRound = railgunRoundFile.instantiate()
	railgunRound.allegiance = "UNN"
	railgunRound.rotation = (calc_railgun_lead() + target.global_position - position).angle()
	railgunRound.position = global_position + velocity/60 + Vector2(100,0).rotated(railgunRound.rotation)
	
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

func movementAlgorithm():
	acceleration = 1.5
	if railgunAiming:
		desiredRotation = (relativeDisplacement + calc_railgun_lead()).angle()
		return
	if relativeDisplacement.length() < 8000:
		weightedNavigation(target, true)
	elif relativeDisplacement.length() < 14000 and relativeVelocity.length() < 100:
		shouldAccelerate = false
		desiredRotation = relativeDisplacement.angle()
		velocity += Vector2(0.5,0).rotated(relativeVelocity.angle())
	else:
		var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-(railgunMaxRange+railgunMinRange)/2-relativeVelocity.length()*PI/turnSpeed/60))
		weightedNavigation(target, shouldDecelerate)
	
