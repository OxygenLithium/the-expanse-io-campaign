extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Trenton-class Cruiser"
var displayName = ""

const idealRange = 30000

func special_init():
	health = 250
	railgunResistance = 2
	acceleration = 1
	standardAcceleration = 1
	PDCTargetingEffectiveness = 7
	turnSpeed = rng.randf_range(PI/960, PI/480)
	
	canDodge = false
	
	missileShootTimes = [ 440, 460, 480, 500, 1665, 1680, 1695, 1710, 1725, 1740, 1755, 1770, 1785, 1800 ]

func movementAlgorithm():
	if relativeDisplacement.length() < 16000:
		weightedNavigation(target, true)
	elif relativeDisplacement.length() < 28000 and relativeVelocity.length() < 50:
		shouldAccelerate = false
		desiredRotation = relativeDisplacement.angle()
		velocity += Vector2(0.3,0).rotated(relativeVelocity.angle())
	else:
		var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-idealRange-relativeVelocity.length()*PI/turnSpeed/60))
		weightedNavigation(target, shouldDecelerate)
		
