extends "res://scripts/ships/common/ship.gd"

#Stats called by others

#Imported paths
@onready var player = get_parent().player

var enemyMarkerFile = load("res://scenes/map/enemy_marker.tscn")
var missileWarning = load("res://scenes/hud/missileWarning.tscn")

var PDCTargetingEffectiveness = 8

func custom_init():
	#Defining variables
	missileFile = load("res://scenes/projectiles/unn/UNNMissile.tscn")
	missileMarkerFile = load("res://scenes/map/unn_missile_marker.tscn")
	bulletFile = load("res://scenes/projectiles/unn/enemyBullet.tscn")
	bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")
	smallShipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")
	missileCooldown = rng.randi_range(0,150)
	
	target = player
	allegiance = "UNN"
	
	health = 50
	acceleration = 1.5
	
	#Initiation operations
	marker = enemyMarkerFile.instantiate()
	marker.markerTarget = self
	$/root/Node.game_map.map_canvas.radar_map.add_child(marker)
	
	$/root/Node.game_map.UNNShips.push_back(self)
	
	special_init()

const standardAcceleration = 1.5

#AI Distance Control
const minDistance = 0
const maxDistance = 0

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

func special_init():
	pass

func death():
	$/root/Node.game_map.UNNShips.erase(self)
	$/root/Node.game_map.unn_ship_destroyed()
	
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

func special_actions():
	pass

func missile_cooldowns():
	if missileCooldown == 1185:
		shoot_missile()
	if missileCooldown > 1200:
		shoot_missile()
		missileCooldown = rng.randi_range(-150,150)

func getTelemetry():
	targetPosition = target.position + Vector2(desiredDistance,0).rotated((target.position-position).angle() + PI/3*favouredSide)
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = "UNN"
	missile.target = $/root/Node.game_map.player
	missile.set_collision_layer_value(10, true)
	missile.set_collision_mask_value(1, true)
	missile.set_collision_mask_value(2, true)
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = velocity
	missile.velocity += Vector2(300,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node.game_map.map_canvas.radar_map.add_child(missile_marker)
	
	var missile_warning = missileWarning.instantiate()
	missile_warning.target = missile
	$/root/Node.game_map.hud_canvas.add_child(missile_warning)

func take_damage_missile():
	health -= 20
	pass

func take_damage_bullet():
	health -= 1
	pass
	
func take_damage_railgun(damage):
	health -= damage
	pass

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
		PDCTarget = getPDCTarget($/root/Node.game_map.MCRNShips, PDCTargetingEffectiveness)
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget($/root/Node.game_map.MCRNShips, PDCTargetingEffectiveness)
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
	
	if PDCTarget and shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	
	if shootCooldown > 0:
		shootCooldown -= 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !player:
		move_and_slide()
		return
		
	if health <= 0:
		death()
		return
	
	getTelemetry()
	PDCFunctions()
	special_actions()
	
	missile_cooldowns()
	missileCooldown += 1
	
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
