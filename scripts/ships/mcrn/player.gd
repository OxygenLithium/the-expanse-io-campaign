extends "res://scripts/ships/common/ship.gd"

#Healthbar
@onready var healthBar = get_node("/root/Node/hud_canvas/health_bar")

var maxhealth = 100
var missileReplenish = 1080
var gforce = 0.0

#Movement stats

func custom_init():
	allegiance = "MCRN"
	
	bulletFile = load("res://scenes/projectiles/mcrn/bullet.tscn")
	missileFile = load("res://scenes/projectiles/mcrn/MCRNMissile.tscn")
	missileMarkerFile = load("res://scenes/map/mcrn_missile_marker.tscn")
	smallShipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")
	bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")
	
	health = maxhealth
	healthBar.recalculate(health,maxhealth)

func on_take_damage():
	healthBar.recalculate(health,maxhealth)

func death():
	$/root/Node.player_death()
	$/root/Node.MCRNShips.erase(self)
	
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

func rotationControl():
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

func RCSControl():
	if !Input.is_action_pressed("key_shift"):
		if Input.is_action_just_pressed("key_w") && RCSCooldowns[0] == 0:
			RCSHard(0)
			RCSCooldowns[0] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_a") && RCSCooldowns[1] == 0:
			RCSHard(PI/2)
			RCSCooldowns[1] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_s") && RCSCooldowns[2] == 0:
			RCSHard(PI)
			RCSCooldowns[2] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_d") && RCSCooldowns[3] == 0:
			RCSHard(-PI/2)
			RCSCooldowns[3] = RCSCooldownLength
			gforce += 200
	else:
		if Input.is_action_just_pressed("key_w") && RCSCooldowns[0] == 0:
			RCSSoft(0)
			RCSCooldowns[0] = RCSLightCooldownLength
			gforce += 50
		if Input.is_action_just_pressed("key_a") && RCSCooldowns[1] == 0:
			RCSSoft(PI/2)
			RCSCooldowns[1] = RCSLightCooldownLength
			gforce += 50
		if Input.is_action_just_pressed("key_s") && RCSCooldowns[2] == 0:
			RCSSoft(PI)
			RCSCooldowns[2] = RCSLightCooldownLength
			gforce += 50
		if Input.is_action_just_pressed("key_d") && RCSCooldowns[3] == 0:
			RCSSoft(-PI/2)
			RCSCooldowns[3] = RCSLightCooldownLength
			gforce += 50
	
	for i in range(4):
		if RCSCooldowns[i] > 0:
			RCSCooldowns[i] -= min(RCSCooldowns[i],1)
	

func driveControl():
	if Input.is_action_pressed("key_1"):
		acceleration = 0
	if Input.is_action_pressed("key_2"):
		acceleration = ACCELERATIONS[0]
	if Input.is_action_pressed("key_3"):
		acceleration = ACCELERATIONS[1]
	if Input.is_action_pressed("key_4"):
		acceleration = ACCELERATIONS[2]
	if Input.is_action_pressed("key_5"):
		acceleration = ACCELERATIONS[3]
	
func cameraFunctions():
	if "allegiance" in $/root/Node/mainCamera.target and $/root/Node/mainCamera.target.allegiance != "MCRN":
		target = $/root/Node/mainCamera.target
	if !target or !is_instance_valid(target):
		target = null
	
func PDCFunctions():
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
	
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget($/root/Node.UNNShips)
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget($/root/Node.UNNShips)
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
		
	if shootCooldown > 0:
		shootCooldown -= 1

func missileFunctions():
	if Input.is_action_pressed("key_space") && missileCooldown == 0 && missileReplenish > 180:
		shoot_missile()
		missileCooldown = 15
		missileReplenish -= 180
		
	if missileCooldown > 0:
		missileCooldown -= 1
	if missileReplenish < 1080:
		missileReplenish += 1
	$/root/Node/hud_canvas/missile_ammo_bar.value = missileReplenish

func gforceCheck():
	gforce += max(acceleration-1.5,0)
	if gforce > 1:
		gforce -= 1
	if gforce > 1000:
		death()
	$/root/Node/hud_canvas/g_limit_bar.value = gforce

func shipFunctions():
	driveControl()
	RCSControl()
	rotationControl()
	getPDCTarget($/root/Node.UNNShips)
	gforceCheck()
	cameraFunctions()
	PDCFunctions()
	missileFunctions()
