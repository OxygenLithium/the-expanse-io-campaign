extends "res://scripts/ships/common/ship.gd"

#Stats called by others

#Imported paths
var missileWarning = load("res://scenes/hud/missileWarning.tscn")
var enemyShips
var friendlyShips

var standardAcceleration
var PDCTargetingEffectiveness = 8
var missileShootTimes = []

func ai_ship_init():
	pass

func custom_init():
	#Defining variables
	smallShipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")
	missileCooldown = rng.randi_range(0,150)
	
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
	get_parent().unn_ship_destroyed()
	
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

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
	

func getTelemetry():
	targetPosition = target.position + Vector2(desiredDistance,0).rotated((target.position-position).angle() + PI/3*favouredSide)
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = allegiance
	missile.target = target
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = velocity
	missile.velocity += Vector2(300,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	get_parent().map_canvas.radar_map.add_child(missile_marker)
	
	if allegiance != "MCRN":
		var missile_warning = missileWarning.instantiate()
		missile_warning.target = missile
		get_parent().hud_canvas.add_child(missile_warning)

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	var closingVelocityVector = relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	return sqrt(closingVelocityVector.dot(closingVelocityVector))

func proportionalNavigation(decelerate = false):
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

func movementAlgorithm():
	var shouldDecelerate = (relativeVelocity.dot(relativeDisplacement) < 0 && relativeVelocity.length()**2 > float(standardAcceleration)*120*(relativeDisplacement.length()-relativeVelocity.length()*PI/turnSpeed/60))
	proportionalNavigation(shouldDecelerate)

func getDiffRotation():
	rotation = fmod(rotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	return diffRotation

func PDCFunctions():
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget(enemyShips, PDCTargetingEffectiveness)
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget(enemyShips, PDCTargetingEffectiveness)
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
	
	if PDCTarget and shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	
	if shootCooldown > 0:
		shootCooldown -= 1

func ai_ship_processes():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if enemyShips.size() < 1:
		move_and_slide()
		return
	
	if health <= 0:
		death()
		return
	
	if !target:
		target = enemyShips.pick_random()
	
	getTelemetry()
	PDCFunctions()
	
	missile_cooldowns()
	
	ai_ship_processes()
	
	acceleration = standardAcceleration
	shouldAccelerate = true
	
	movementAlgorithm()

	var diffRotation = getDiffRotation()
	if diffRotation >= 0:
		rotation += min(diffRotation, turnSpeed)
	else:
		rotation += max(diffRotation, -turnSpeed)
		
	if shouldAccelerate:
		shouldAccelerate =  (abs(diffRotation) < PI/6)
	if !shouldAccelerate:
		acceleration = 0
	
	velocity += Vector2(acceleration,0).rotated(rotation)

	prevTargetDirection = currTargetDirection
	move_and_slide()
