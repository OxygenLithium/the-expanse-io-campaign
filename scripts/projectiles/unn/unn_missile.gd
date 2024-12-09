extends "res://scripts/projectiles/common/missile.gd"

func missile_init():
	accelerations = [0,9,18,27]

func phases_functions():
	if timer >= 30:
		if approxImpactTime < finalManeuverTime:
			accelerationGrade = 3
			proportionalNavigation(false)
			proportionalNavTimer = 0
		if proportionalNavTimer > 5:
			proportionalNavigation()
			proportionalNavTimer = 0
		
	if timer == 30:
		accelerationGrade = 3
		
	if timer == 120:
		accelerationGrade = 2
