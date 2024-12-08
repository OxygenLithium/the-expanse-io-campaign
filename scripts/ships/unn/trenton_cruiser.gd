extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Trenton-class Cruiser"
var displayName = ""

func special_init():
	health = 250
	railgunResistance = 2
	acceleration = 0.75
	standardAcceleration = 0.75
	PDCTargetingEffectiveness = 7
	turnSpeed = rng.randf_range(PI/960, PI/480)
	
	canDodge = false
	
	missileShootTimes = [ 440, 460, 480, 500, 1635, 1650, 1665, 1680, 1695, 1710, 1725, 1740, 1755, 1770, 1785, 1800 ]
