extends "res://scripts/ships/common/ship.gd"

#Imported paths
var missileWarning = load("res://scenes/hud/missileWarning.tscn")

#Variables for AI
var enemyShips
var friendlyShips

#Stances
var defaultStance = "active"
var stance = null

#Escort Stance
var escortTarget = null
var initialOffset
var escortInterceptTarget = null

#Sentry stance
#The alert group is the group of ships that will engage alongside this one
var alertGroup = []

#Acceleration
var baseAcceleration = 1.5
var standardAcceleration

#PDC
var PDCTargetingEffectiveness = 8

#Missile
var missileShootTimes = []

#Dodging
var canDodge = true
var dodgeTimer = 0
var dodgeCooldown = 300
var dodgeChance = 30

func ai_ship_init():
	pass

func custom_init():
	standardAcceleration = baseAcceleration
	acceleration = baseAcceleration
	
	if !stance:
		stance = defaultStance
	
	#Defining variables
	shipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")
	missileCooldown = rng.randi_range(0,150)
	
	#Preparing ships in escort stance
	if stance == "escort":
		initialOffset = position - escortTarget.position
		standardAcceleration = baseAcceleration*1.5
		acceleration = baseAcceleration*1.5
	
	#Initiation operations
	ai_ship_init()
	
	target = null
	friendlyShips.push_back(self)

#AI Navigation
var desiredRotation = 0
var shouldAccelerate = true


var PDCLockDistance = 1500

# Random Movement Behaviour
var desiredDistance = rng.randi_range(3000,6000)
var favouredSide = (rng.randi_range(0,1)-0.5)*2
var turnSpeed = rng.randf_range(PI/480, PI/240)

# Telemetry
var telemetryTimer = 0

var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity

var currTargetDirection
var prevTargetDirection = 0

func ai_ships_processes():
	pass

func death():
	friendlyShips.erase(self)
	if allegiance == "UNN":
		get_parent().unn_ship_destroyed(self)
	elif allegiance == "MCRN":
		get_parent().mcrn_ship_destroyed(self)
	
	var small_ship_explosion = shipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	
	if $/root/Node/mainCamera.target == self:
		$/root/Node/mainCamera.target = small_ship_explosion
	
	queue_free()

func become_active():
	stance = "active"

func become_passive():
	stance = "passive"

func become_escort():
	stance = "escort"
	initialOffset = position - escortTarget.position
	standardAcceleration = baseAcceleration*1.5
	acceleration = baseAcceleration*1.5

func quit_escort():
	standardAcceleration = baseAcceleration
	acceleration = baseAcceleration

func missile_cooldowns():
	if missileShootTimes.size() < 1:
		return
	var isShootTime = false
	for i in range(missileShootTimes.size()):
		if missileCooldown == missileShootTimes[i]:
			isShootTime = true
			if relativeDisplacement.length() > 1500 and relativeDisplacement.length() < 80000:
				shoot_missile()
				missileCooldown += 1
				
				if i == missileShootTimes.size()-1:
					missileCooldown = rng.randi_range(0,150)
			break
	if !isShootTime:
		missileCooldown += 1
	

func getTelemetry(telemetryTarget, bias = Vector2(desiredDistance,0).rotated((telemetryTarget.position-position).angle() + PI/3*favouredSide)):
	var distance = (telemetryTarget.position-position).length()
	
	targetPosition = telemetryTarget.position + bias
	targetVelocity = telemetryTarget.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()

func shoot_missile(mDamage = 40, targeting = "normal"):
	var missile = missileFile.instantiate()
	missile.allegiance = allegiance
	missile.damage = mDamage
	missile.shooter = self
	missile.shooterInitialVelocity = velocity
	if targeting == "random":
		missile.target = enemyShips.pick_random()
	else:
		missile.target = target
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = velocity
	missile.velocity += Vector2(100,0).rotated(rotation)
	missile.velocity += Vector2(300,0).rotated(rng.randf_range(-PI/2,PI/2))
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	get_parent().map_canvas.radar_map.add_child(missile_marker)
	
	missile.marker = missile_marker
	
	if allegiance != "MCRN" and target == get_parent().player:
		var missile_warning = missileWarning.instantiate()
		missile_warning.target = missile
		get_parent().hud_canvas.add_child(missile_warning)

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	var closingVelocityVector = relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	return sqrt(closingVelocityVector.dot(closingVelocityVector))

func weightedNavigation(navTarget = target, decelerate = false):
	var desiredVector  = relativeDisplacement + relativeVelocity * pow(relativeDisplacement.length(),0.5)/10
	if "acceleration" in navTarget:
		desiredVector += Vector2(navTarget.acceleration,0).rotated(navTarget.rotation) * pow(relativeDisplacement.length(),0.5)/100
	desiredRotation = desiredVector.angle()
	acceleration = 1 + 8/PI*atan(sqrt(desiredVector.length())/100)
	
	if desiredVector.length() < 1000:
		shouldAccelerate = false
		velocity += Vector2(1,0).rotated(desiredVector.angle())
		
func proportionalNavigation(propNavTarget = target, decelerate = false):
	if relativeVelocity.dot(relativeDisplacement) < 0 or decelerate:
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)*60
		var closingVelocity = getClosingVelocity()
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > standardAcceleration):
			desiredRotation = relativeVelocity.angle() - PI/2
		elif (desiredAccel < -standardAcceleration):
			desiredRotation = relativeVelocity.angle() + PI/2
		else:
			if decelerate:
				if relativeVelocity.dot(relativeDisplacement) < 0:
					desiredRotation = relativeVelocity.angle() - asin(desiredAccel/standardAcceleration)
				else:
					desiredRotation = relativeVelocity.angle() + PI + asin(desiredAccel/standardAcceleration)
					
			else:
				desiredRotation = relativeVelocity.angle() + PI + asin(desiredAccel/standardAcceleration)
			
	else:
		if velocity.length() < standardAcceleration:
			velocity = Vector2(0,0)
			desiredRotation = relativeDisplacement.angle()
		else:
			desiredRotation = relativeVelocity.angle()

func escortMovementAlgorithm():
	var bias = initialOffset
	escortInterceptTarget = getPDCTarget(escortTarget.incomingMissiles, enemyShips, INF)
	getTelemetry(escortTarget, bias)
	acceleration = escortTarget.acceleration + 1 + 12/PI*atan(sqrt(relativeDisplacement.length())/100)
	if relativeDisplacement.length() < 200 and relativeVelocity.length() < 50:
		shouldAccelerate = false
		desiredRotation = relativeDisplacement.angle()
		velocity += Vector2(0.3,0).rotated(relativeVelocity.angle())
	else:
		var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-100-relativeVelocity.length()*PI/turnSpeed/60))
		proportionalNavigation(target, shouldDecelerate)

func movementAlgorithm():
	var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-relativeVelocity.length()*PI/turnSpeed/60))
	weightedNavigation(target, shouldDecelerate)

func getDiffRotation():
	rotation = fmod(rotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	return diffRotation

func getOtherPDCTargets(closest, minDistance):
	var biasedMinDistance = minDistance*1.5
	if stance == "escort":
		for i in escortTarget.incomingMissiles:
			if (i.position - global_position).length() < biasedMinDistance:
				closest = i
				biasedMinDistance = (i.position - global_position).length()
	
	return closest

func PDCFunctions():
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget(incomingMissiles, enemyShips, PDCTargetingEffectiveness)
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget(incomingMissiles, enemyShips, PDCTargetingEffectiveness)
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
	
	if PDCTarget and shootCooldown == 0:
		shoot_PDC()
		shootCooldown = timeBetweenPDC
	
	if shootCooldown > 0:
		shootCooldown -= 1

func ai_ship_processes():
	pass
	
func targeted_by_railgun():
	if canDodge and dodgeTimer <= 0:
		if rng.randi_range(1,100) <= dodgeChance:
			RCSHard(rng.randi_range(0,3)*PI/2)
			dodgeTimer = dodgeCooldown

func intelligent_pick_target():
	var weights = []
	var currMax = 0
	for i in enemyShips:
		var weight = max(1, 300000/(i.position - position).length())
		weights.push_back(currMax + weight)
		currMax += weight
	
	var chosen = rng.randi_range(1, currMax)
	for i in range(weights.size()):
		if chosen <= weights[i]:
			return enemyShips[i]
	
	return enemyShips.pick_random()

func check_stance():
	if stance == "escort" and (!escortTarget or !is_instance_valid(escortTarget)):
		stance = "active"
	
	if (stance == "active" or stance == "escort") and !target:
		if enemyShips.size() < 1:
			stance = "passive"
		else:
			target = intelligent_pick_target()
	
	if stance == "passive":
		if velocity.length() <= acceleration:
			velocity = Vector2(0,0)
			shouldAccelerate = 0
		else:
			desiredRotation = velocity.angle() + PI
		
		for ship in enemyShips:
			if (ship.position - position).length < 50000:
				stance = "active"

func navigation_algorithm():
	shouldAccelerate = true	
	if stance == "active" or stance == "escort":
		getTelemetry(target)
		if telemetryTimer > 5:
		
			acceleration = standardAcceleration
		
			if stance == "active":
				movementAlgorithm()
			elif stance == "escort":
				escortMovementAlgorithm()
			
			telemetryTimer = 0
		else:
			telemetryTimer += 1

	var diffRotation = getDiffRotation()
	if diffRotation >= 0:
		rotation += min(diffRotation, turnSpeed)
	else:
		rotation += max(diffRotation, -turnSpeed)
		
	if shouldAccelerate:
		shouldAccelerate =  (abs(diffRotation) < PI/6)
	if !shouldAccelerate:
		acceleration = 0

func _physics_process(delta: float) -> void:
	#death detection
	if health <= 0:
		death()
		return

	check_stance()
	navigation_algorithm()
	
	PDCFunctions()
	missile_cooldowns()
	ai_ship_processes()

	if dodgeTimer > 0:
		dodgeTimer -= 1
	
	velocity += Vector2(acceleration,0).rotated(rotation)

	prevTargetDirection = currTargetDirection
	move_and_slide()
