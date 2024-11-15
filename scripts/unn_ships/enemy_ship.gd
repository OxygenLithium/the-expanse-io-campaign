extends CharacterBody2D

@export var pdcPivots: Array[Node2D]
@export var pdcMarkers: Array[Node2D]

#Stats called by others
const type = "ship"
const allegiance = "UNN"

var health = 50

@onready var incomingMissiles = []
var PDCTarget = null
var getPDCTargetTimer = 0

var bulletSpeed = 3000

var rng = RandomNumberGenerator.new()

#Imported paths
@onready var player = get_node("/root/Node/player")
@onready var target = player

var missileFile = load("res://scenes/weapon/missile.tscn")
var missileMarkerFile = load("res://radar_map/unn_missile_marker.tscn")
var bulletFile = load("res://scenes/weapon/enemyBullet.tscn")
var bulletMarkerFile = load("res://radar_map/bullet_marker.tscn")

var missileWarning = load("res://hud/missileWarning.tscn")

var enemyMarkerFile = load("res://radar_map/enemy_marker.tscn")

var smallShipExplosionFile = load("res://scenes/weapon/smallShipExplosion.tscn")

var acceleration = 1.5

#AI Distance Control
const minDistance = 1500
const maxDistance = 10000

#AI Navigation
var desiredRotation = 0

#Weaponry control
var missileCooldown = rng.randi_range(0,150)
var shootCooldown = 0


var PDCLockDistance = 1500

# Random Movement Behaviour
var desiredDistance = rng.randi_range(2000,3000)
var favouredSide = (rng.randi_range(0,1)-0.5)*2
var turnSpeed = rng.randf_range(PI/480, PI/240)

# Telemetry
var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity

var currTargetDirection
var prevTargetDirection

func special_init():
	pass

func _ready():
	var marker = enemyMarkerFile.instantiate()
	marker.markerTarget = self
	$/root/Node/map_canvas/radar_map.add_child(marker)
	
	$/root/Node.UNNShips.push_back(self)
	
	special_init()

func death():
	$/root/Node.UNNShips.erase(self)
	$/root/Node.unn_ship_destroyed()
	
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

func special_actions():
	pass

func missile_cooldowns():
	if missileCooldown == 500:
		shoot_missile()
	if missileCooldown > 600:
		shoot_missile()
		missileCooldown = rng.randi_range(0,150)

func getTelemetry():
	targetPosition = target.position + Vector2(desiredDistance,0).rotated((target.position-position).angle() + PI/3*favouredSide)
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()

func shoot_PDC():
	for i in range(pdcMarkers.size()):
		var bullet = bulletFile.instantiate()
		bullet.allegiance = "UNN"
		bullet.position = pdcMarkers[i].global_position + velocity/60
		bullet.set_collision_layer_value(11, true)
		bullet.set_collision_mask_value(1, true)
		bullet.set_collision_mask_value(2, true)
		
		get_parent().add_child(bullet)
		bullet.rotation = pdcPivots[i].rotation + rotation
		bullet.rotation += rng.randf_range(-PI/60, PI/60)
		bullet.velocity = velocity
		bullet.velocity += Vector2(bulletSpeed,0).rotated(bullet.rotation)
		bullet.set_visible(true)
		
		var bullet_marker = bulletMarkerFile.instantiate()
		bullet_marker.markerTarget = bullet
		$/root/Node/map_canvas/radar_map.add_child(bullet_marker)
		

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = "UNN"
	missile.target = $/root/Node/player
	missile.set_collision_layer_value(10, true)
	missile.set_collision_mask_value(1, true)
	missile.set_collision_mask_value(2, true)
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = Vector2(300,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)
	
	var missile_warning = missileWarning.instantiate()
	missile_warning.target = missile
	$/root/Node/map_canvas.add_child(missile_warning)

func take_damage_missile():
	health -= 20
	pass

func take_damage_bullet():
	health -= 1
	pass
	
func tanke_damage_railgun(damage):
	health -= damage
	pass

func getVelocityDirection():
	var fixedVX = velocity.x
	if fixedVX == 0:
		fixedVX = 0.01
	var angle = atan(velocity.y/fixedVX)
	if (sign(velocity.x) == -1):
		angle += PI
	return angle

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	var closingVelocityVector = relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	return sqrt(closingVelocityVector.dot(closingVelocityVector))

func proportionalNavigation():
	if relativeVelocity.dot(relativeDisplacement) < 0:
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)*60
		var closingVelocity = getClosingVelocity()
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > acceleration):
			desiredRotation = relativeVelocity.angle() + PI + PI/2
		elif (desiredAccel < -acceleration):
			desiredRotation = relativeVelocity.angle() + PI - PI/2
		else:
			desiredRotation = relativeVelocity.angle() + PI + asin(desiredAccel/acceleration)
			
	else:
		if velocity.length() < acceleration:
			velocity = Vector2(0,0)
			desiredRotation = relativeDisplacement.angle()
		else:
			desiredRotation = relativeVelocity.angle()

func getPDCTarget():
	if incomingMissiles.size() + $/root/Node.MCRNShips.size() == 0:
		return null
	var closest = null
	var PDCMinDistance = PDCLockDistance
	for i in range(incomingMissiles.size()):
		if (incomingMissiles[i].position - position).length() < PDCMinDistance:
			closest = incomingMissiles[i]
			PDCMinDistance = (incomingMissiles[i].position - position).length()
	
	for i in range($/root/Node.MCRNShips.size()):
		if ($/root/Node.MCRNShips[i].position - position).length() < minDistance:
			closest = $/root/Node.MCRNShips[i]
			PDCMinDistance = ($/root/Node.MCRNShips[i].position - position).length()
	return closest

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !player:
		move_and_slide()
		return
		
	if health <= 0:
		death()
		return
	
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget()
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget()
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
	
	if PDCTarget and shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	
	if shootCooldown > 0:
		shootCooldown -= 1
	
	special_actions()
	
	missile_cooldowns()
	
	missileCooldown += 1
	
	getTelemetry()
	
	if relativeDisplacement.length() > maxDistance:
		proportionalNavigation()
	elif relativeDisplacement.length() < minDistance:
		desiredRotation = relativeDisplacement.angle() + PI
	elif relativeVelocity != Vector2(0,0):
		desiredRotation = relativeVelocity.angle()

	rotation = fmod(rotation, 2*PI)
	desiredRotation = fmod(desiredRotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	if diffRotation >= 0:
		rotation += min(diffRotation, turnSpeed)
	else:
		rotation += max(diffRotation, -turnSpeed)
	
	velocity += Vector2(min(acceleration,relativeVelocity.length()),0).rotated(rotation)

	prevTargetDirection = currTargetDirection

	move_and_slide()
