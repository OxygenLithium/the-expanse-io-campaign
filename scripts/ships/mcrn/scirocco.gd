extends "res://scripts/ships/mcrn/friendly_ship.gd"

const displayType = "Scirocco-class Cruiser"
var displayName

#Railgun stuff
@export var railgun : Node2D
var railgunRoundFile = load("res://scenes/projectiles/mcrn/MCRNRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://scenes/map/railgun_round_marker.tscn")
var railgunTimer = rng.randi_range(0,150)
const railgunMaxRange = 30000
const railgunMinRange = 5000

var railgunRoundSpeed = 15000

func special_init():
	health = 300
	railgunResistance = 2
	acceleration = 1.5
	standardAcceleration = 1.5
	PDCTargetingEffectiveness = 12
	turnSpeed = rng.randf_range(PI/960, PI/480)
	
	canDodge = false
	
	missileShootTimes = [ 1665, 1680, 1695, 1710, 1725, 1740, 1755, 1770, 1785, 1800 ]

func shoot_railgun():
	var railgunRound = railgunRoundFile.instantiate()
	railgunRound.allegiance = "MCRN"
	railgunRound.rotation = railgun.rotation + rotation
	railgunRound.position = railgun.global_position + velocity/60 + Vector2(100,0).rotated(railgunRound.rotation)
	railgunRound.damage = 50
	
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
	if railgunTimer > 600 and (target.global_position-global_position).length() < railgunMaxRange and (target.global_position-global_position).length() > railgunMinRange:
		railgunRoundSpeed = (target.global_position-global_position).length()/1.5
		shoot_railgun()
		railgunTimer = rng.randi_range(0,60)
	pass
