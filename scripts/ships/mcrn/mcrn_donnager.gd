extends "res://scripts/ships/mcrn/friendly_ship.gd"

const displayType = "Donnager-class Battleship"
var displayName

const idealRange = 40000

#Railgun stuff
@export var railgun : Node2D
var railgunRoundFile = load("res://scenes/projectiles/mcrn/MCRNRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://scenes/map/railgun_round_marker.tscn")
var railgunTimer = rng.randi_range(0,150)
const railgunMaxRange = 50000
const railgunMinRange = 5000

var railgunRoundSpeed = 100000

func special_init():
	shipExplosionFile = load("res://scenes/projectiles/common/largeShipExplosion.tscn")
	health = 1000
	railgunResistance = 2
	acceleration = 1.5
	standardAcceleration = 1.5
	PDCTargetingEffectiveness = 20
	turnSpeed = rng.randf_range(PI/1440, PI/720)
	
	missileCooldown = 500
	
	canDodge = false
	
	missileShootTimes = [ 1020, 1035, 1050, 1065, 1080, 1095, 1110, 1125, 1140, 1155, 1170, 1185, 1200, 1215, 1230, 1245, 1260, 1275, 1290, 1305, 1320, 1335, 1350, 1365, 1380, 1395, 1410, 1425, 1440, 1455 ]

func movementAlgorithm():
	acceleration = 1.5
	if relativeDisplacement.length() < 16000:
		proportionalNavigation(target, true)
	elif relativeDisplacement.length() < 28000 and relativeVelocity.length() < 50:
		shouldAccelerate = false
		desiredRotation = relativeDisplacement.angle()
		velocity += Vector2(0.3,0).rotated(relativeVelocity.angle())
	else:
		var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-idealRange-relativeVelocity.length()*PI/turnSpeed/60))
		proportionalNavigation(target, shouldDecelerate)

func shoot_railgun():
	var railgunRound = railgunRoundFile.instantiate()
	railgunRound.allegiance = "MCRN"
	railgunRound.rotation = railgun.rotation + rotation
	railgunRound.position = railgun.global_position + velocity/60 + Vector2(100,0).rotated(railgunRound.rotation)
	railgunRound.damage = 100
	
	get_parent().add_child(railgunRound)
	railgunRound.velocity = velocity
	railgunRound.velocity += Vector2(railgunRoundSpeed,0).rotated(railgunRound.rotation)
	railgunRound.set_visible(true)
		
	var railgun_round_marker = railgunRoundMarkerFile.instantiate()
	railgun_round_marker.markerTarget = railgunRound
	get_parent().map_canvas.radar_map.add_child(railgun_round_marker)
	
	if "targeted_by_railgun()" in target:
		target.targeted_by_railgun()

func calc_railgun_lead():
	var closingVelocity = getClosingVelocity()
	if "acceleration" in target:
		return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity)) + Vector2(target.acceleration,0).rotated(target.rotation)*(((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))**2)*30
	return (target.velocity - velocity)*((target.global_position-global_position).length()/(railgunRoundSpeed + closingVelocity))

func special_actions():
	railgun.look_at(target.global_position + calc_railgun_lead())
	railgunTimer += 1
	if railgunTimer > 300 and (target.global_position-global_position).length() < railgunMaxRange and (target.global_position-global_position).length() > railgunMinRange:
		railgunRoundSpeed = (target.global_position-global_position).length()/3
		shoot_railgun()
		railgunTimer = rng.randi_range(0,60)
	pass

func missile_cooldowns():
	if missileShootTimes.size() < 1:
		return
	var isShootTime = false
	for i in range(missileShootTimes.size()):
		if missileCooldown == missileShootTimes[i]:
			isShootTime = true
			if relativeDisplacement.length() > 1500 and relativeDisplacement.length() < 100000:
				shoot_missile(40, "random")
				missileCooldown += 1
				
				if i == missileShootTimes.size()-1:
					missileCooldown = rng.randi_range(0,150)
			break
	if !isShootTime:
		missileCooldown += 1
