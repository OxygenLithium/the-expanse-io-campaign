extends CharacterBody2D

var type = "missile"
var displayType = "Missile"
var allegiance

var marker
var shooter
var target

var explosionFile = load("res://scenes/projectiles/common/explosion.tscn")

var targetPosition
var targetVelocity
var relativeVelocityShooter
var relativeDisplacement
var relativeVelocity
var currTargetDirection
var prevTargetDirection

var velocityDirection
var relativeVelocityDireciton

const lifespan = 1800
var accelerations = [0,9,27]

var acceleration = 4
var accelerationGrade

var desiredRotation = 0

var cutAcceleration
const cutAccelerationSpeed = 6000
const cutAccelerationDistance = 3000
var relativeToTarget = false

var approxImpactTime = INF

var damage = 40

#seconds
const finalManeuverTime = 10

var timer = 0
var offTargetTimer = 0

var proportionalNavTimer = 0

func missile_init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	missile_init()
	
	if target and is_instance_valid(target):
		getTelemetry()
	prevTargetDirection = currTargetDirection
	accelerationGrade = 1
	
	if target and "incomingMissiles" in target:
		target.incomingMissiles.push_back(self)
	pass # Replace with function body.

func getTelemetry():
	targetPosition = target.position
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	
	relativeVelocityShooter = shooter.velocity - velocity
	currTargetDirection = relativeDisplacement.angle()
	velocityDirection = velocity.angle()

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	return -relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement.length()
	
func getPerpendicularVelocityVector():
	#vector projection of rel. velocity onto rel. displacement
	return -relativeVelocity+relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	
func getClosingAcceleration():
	#vector projection of rel. velocity onto rel. displacement
	if not "acceleration" in target:
		return 0
	return -Vector2(target.acceleration,0).rotated(target.rotation).dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement.length()

func approximateImpactTime(closingVelocity):
	return (-(closingVelocity*60) + sqrt((closingVelocity*60)**2 + 4*(acceleration+getClosingAcceleration())*relativeDisplacement.length()))/2*acceleration

func nonzeroAcceleration():
	if acceleration == 0:
		return 9
	return acceleration

func proportionalNavigation(limitSpeed = true):
	var velocityType
	if (targetPosition - position).length() < (shooter.position - position).length():
		relativeToTarget = true
	if timer > 30:
		relativeToTarget = true
	if relativeToTarget:
		velocityType = relativeVelocity
	else:
		velocityType = relativeVelocityShooter
	if velocityType.dot(relativeDisplacement) < 0:
		offTargetTimer = 0
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)
		var closingVelocity = getClosingVelocity()
		approxImpactTime = approximateImpactTime(closingVelocity)
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > acceleration):
			desiredRotation = velocityType.angle() + PI + PI/2
		elif (desiredAccel < -acceleration):
			desiredRotation = velocityType.angle() + PI - PI/2
		else:
			if limitSpeed:
				if closingVelocity > cutAccelerationSpeed*1.5:
					desiredRotation = velocityType.angle() - asin(desiredAccel/acceleration)
				else:
					desiredRotation = velocityType.angle() + PI + asin(desiredAccel/acceleration)
					if closingVelocity > cutAccelerationSpeed:
						cutAcceleration = true
						velocity += Vector2(0,desiredAccel).rotated(velocityType.angle())
			else:
				desiredRotation = velocityType.angle() + PI + asin(desiredAccel/acceleration)
	else:
		if timer > 180:
			offTargetTimer += 1
		if offTargetTimer > 30:
			death()
			return
		if velocity.length() < acceleration:
			velocity = Vector2(0,0)
			desiredRotation = relativeDisplacement.angle()
		else:
			desiredRotation = velocityType.angle()

func collision_functions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if not "type" in collider:
			continue
		
		if (collider.type == "missile"):
			death()
			collider.hit_by_bullet()
			return
		
		if (collider.type == "ship"):
			death()
			collider.take_damage_missile(damage)
			return
			
		death()
		break

func death():
	var explosion = explosionFile.instantiate()
	explosion.position = global_position
	explosion.velocity = velocity
	get_parent().add_child(explosion)
	if is_instance_valid(target) && "incomingMissiles" in target:
		target.incomingMissiles.erase(self)
	if $/root/Node/mainCamera.target == self:
		$/root/Node/mainCamera.target = explosion
		
	queue_free()

func hit_by_railgun():
	death()

func hit_by_bullet():
	death()
	
func phases_functions():
	if timer >= 30:
		if approxImpactTime < finalManeuverTime:
			accelerationGrade = 2
			proportionalNavigation(false)
			proportionalNavTimer = 0
		if proportionalNavTimer > 5:
			proportionalNavigation()
			proportionalNavTimer = 0
		
	if timer == 30:
		accelerationGrade = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#fetches and calculates parameters about the target
	cutAcceleration = false
	
	if !is_instance_valid(target):
		target = null
	
	if !target or !is_instance_valid(shooter):
		death()
		return
		
	getTelemetry()
	
	phases_functions()
	
	if timer == lifespan:
		death()
		return
	
	rotation = fmod(rotation, 2*PI)
	desiredRotation = fmod(desiredRotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	if timer > 30:
		if timer < 60:
			if diffRotation >= 0:
				rotation += min(diffRotation, PI/60)
			else:
				rotation += max(diffRotation, -PI/60)
		else:
			if diffRotation >= 0:
				rotation += min(diffRotation, PI/90)
			else:
				rotation += max(diffRotation, -PI/90)
	
	if abs(diffRotation) > PI/18:
		cutAcceleration = true
		
	acceleration = accelerations[accelerationGrade]
	if !cutAcceleration:
		velocity += Vector2(acceleration,0).rotated(rotation)
	
	timer += 1
	
	proportionalNavTimer += 1
	
	collision_functions()
	
	prevTargetDirection = currTargetDirection

	move_and_slide()
