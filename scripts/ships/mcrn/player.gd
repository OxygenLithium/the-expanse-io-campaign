extends CharacterBody2D

@export var pdcPivots: Array[Node2D]
@export var drivePlume: Node2D

@export var pdcMarkers: Array[Node2D]

#Fields accessed by others on checks
var type = "ship"
var allegiance = "MCRN"

#Random number generator
var rng = RandomNumberGenerator.new()

#Autotrack AI
var PDCAutotrack = true
var PDCTarget = null
var getPDCTargetTimer = 0

@onready var incomingMissiles = []

#Files
var bulletFile = load("res://scenes/projectiles/mcrn/bullet.tscn")
var missileFile = load("res://scenes/projectiles/mcrn/MCRNMissile.tscn")
var missileMarkerFile = load("res://scenes/map/mcrn_missile_marker.tscn")

var smallShipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")

var bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")

#Healthbar
@onready var healthBar = get_node("/root/Node/hud_canvas/health_bar")

#Stats
#Health stats
var health = 100
var maxhealth = 100

#Movement stats
const ACCELERATION1 = 1
const ACCELERATION2 = 2

var acceleration = 0
var angVelocity = 0

var bulletSpeed = 3000

const RCSThrust = 300
const RCSLightThrust = 30
const RCSCooldownLength = 60
const RCSLightCooldownLength = 30
var RCSCooldowns = [0,0,0,0]

#Cooldowns
var shootCooldown = 0
var missileCooldown = 0

#Weapons
var target = null

func _ready():
	healthBar.recalculate(health,maxhealth)
	drivePlume.visible = false
	
	PDCAutotrack = true
	$/root/Node/hud_canvas/autotrack_label.text = "PDC Autotrack: ON"
	
	$/root/Node.MCRNShips.push_back(self)

func getPDCTarget():
	var futurePos = position + velocity + Vector2(acceleration,0).rotated(rotation)/120
	
	if target == null:
		$/root/Node/hud_canvas/target_label.text = "No Target Selected" 
	elif "displayType" in target:
		$/root/Node/hud_canvas/target_label.text = "Target:\n" + target.displayType
		if "displayName" in target:
			$/root/Node/hud_canvas/target_label.text += "\n"+target.displayName
	
	if incomingMissiles.size() + $/root/Node.UNNShips.size() == 0:
		return null
	var closest = null
	var minDistance = 12
	for i in range(incomingMissiles.size()):
		if incomingMissiles[i].approxImpactTime < minDistance:
			closest = incomingMissiles[i]
			minDistance = incomingMissiles[i].approxImpactTime
	
	minDistance *= 500
	for i in range($/root/Node.UNNShips.size()):
		if ($/root/Node.UNNShips[i].position - futurePos).length() < minDistance:
			closest = $/root/Node.UNNShips[i]
			minDistance = ($/root/Node.UNNShips[i].position - futurePos).length()
	for i in range(incomingMissiles.size()):
		if (incomingMissiles[i].position - futurePos).length() < minDistance:
			closest = incomingMissiles[i]
			minDistance = (incomingMissiles[i].position - futurePos).length()
	return closest

func shoot_PDC():
	for i in range(pdcPivots.size()):
		var bullet = bulletFile.instantiate()
		bullet.allegiance = "MCRN"
		bullet.position = pdcPivots[i].global_position + velocity/60
		bullet.set_collision_layer_value(3, true)
		bullet.set_collision_mask_value(9, true)
		bullet.set_collision_mask_value(10, true)
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
	missile.allegiance = "MCRN"
	
	missile.target = target
	missile.set_collision_layer_value(2, true)
	missile.set_collision_mask_value(9, true)
	missile.set_collision_mask_value(10, true)
	missile.global_position = global_position + Vector2(50,0).rotated(rotation)
	missile.velocity = velocity
	missile.rotation = rotation
	missile.velocity += Vector2(300,0).rotated(rotation)
	get_parent().add_child(missile)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)

func take_damage_missile():
	health -= 20
	healthBar.recalculate(health,maxhealth)
	
func take_damage_bullet():
	health -= 1
	healthBar.recalculate(health,maxhealth)
	
func take_damage_railgun(damage):
	health -= damage
	healthBar.recalculate(health,maxhealth)

func death():
	$/root/Node.player_death()
	$/root/Node.MCRNShips.erase(self)
	
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

func _physics_process(delta: float) -> void:
	if health < 0.1:
		death()
	
	# Add the gravity.
	velocity += Vector2(acceleration,0).rotated(rotation)
	rotation_degrees += angVelocity
	
	if !Input.is_action_pressed("key_shift"):
		if Input.is_action_pressed("key_w") && RCSCooldowns[0] == 0:
			velocity += Vector2(RCSThrust,0).rotated(rotation)
			RCSCooldowns[0] = RCSCooldownLength
		if Input.is_action_pressed("key_a") && RCSCooldowns[1] == 0:
			velocity += Vector2(RCSThrust,0).rotated(rotation-PI/2)
			RCSCooldowns[1] = RCSCooldownLength
		if Input.is_action_pressed("key_s") && RCSCooldowns[2] == 0:
			velocity -= Vector2(RCSThrust,0).rotated(rotation)
			RCSCooldowns[2] = RCSCooldownLength
		if Input.is_action_pressed("key_d") && RCSCooldowns[3] == 0:
			velocity += Vector2(RCSThrust,0).rotated(rotation+PI/2)
			RCSCooldowns[3] = RCSCooldownLength
	else:
		if Input.is_action_pressed("key_w") && RCSCooldowns[0] == 0:
			velocity += Vector2(RCSLightThrust,0).rotated(rotation)
			RCSCooldowns[0] = RCSLightCooldownLength
		if Input.is_action_pressed("key_a") && RCSCooldowns[1] == 0:
			velocity += Vector2(RCSLightThrust,0).rotated(rotation-PI/2)
			RCSCooldowns[1] = RCSLightCooldownLength
		if Input.is_action_pressed("key_s") && RCSCooldowns[2] == 0:
			velocity -= Vector2(RCSLightThrust,0).rotated(rotation)
			RCSCooldowns[2] = RCSLightCooldownLength
		if Input.is_action_pressed("key_d") && RCSCooldowns[3] == 0:
			velocity += Vector2(RCSLightThrust,0).rotated(rotation+PI/2)
			RCSCooldowns[3] = RCSLightCooldownLength
	
	
	if Input.is_action_pressed("key_e"):
		angVelocity += 0.04
	if Input.is_action_pressed("key_q"):
		angVelocity -= 0.04
	if Input.is_action_pressed("ui_right"):
		angVelocity += 0.1
	if Input.is_action_pressed("ui_left"):
		angVelocity -= 0.1
		
		
	if Input.is_action_pressed("key_r"):
		angVelocity = 0

	if Input.is_action_pressed("key_1"):
		acceleration = 0
	if Input.is_action_pressed("key_2"):
		acceleration = ACCELERATION1
		#$ship_sprite.texture = load("res://sprites/ship_and_parts/player/roci_drive_on.png")
	if Input.is_action_pressed("key_3"):
		acceleration = ACCELERATION2
		#$ship_sprite.texture = load("res://sprites/ship_and_parts/player/roci_drive_on.png")
	
	if "allegiance" in $/root/Node/mainCamera.target and $/root/Node/mainCamera.target.allegiance != "MCRN":
		target = $/root/Node/mainCamera.target
	if !target or !is_instance_valid(target):
		target = null
	
	if Input.is_action_just_pressed("key_t"):
		PDCAutotrack = !PDCAutotrack
		if PDCAutotrack:
			$/root/Node/hud_canvas/autotrack_label.text = "PDC Autotrack: ON"
		else:
			$/root/Node/hud_canvas/autotrack_label.text = "PDC Autotrack: OFF"
	if PDCAutotrack && PDCTarget && shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	if !PDCAutotrack && Input.is_action_pressed("click") && shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	if Input.is_action_pressed("key_space") && missileCooldown == 0:
		shoot_missile()
		missileCooldown = 60
		
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget()
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget()
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
		
	if shootCooldown > 0:
		shootCooldown -= 1
		
	if missileCooldown > 0:
		missileCooldown -= 1
		
	for i in range(4):
		if RCSCooldowns[i] > 0:
			RCSCooldowns[i] -= min(RCSCooldowns[i],1)
	
	move_and_slide()
