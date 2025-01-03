extends "res://scripts/ships/common/ship.gd"

#Healthbar
@onready var healthBar

@onready var PDC_sound_player = $/root/Node/mainCamera/PDCSoundPlayer
@onready var missile_sound_player = $/root/Node/mainCamera/MissileSoundPlayer
@onready var take_damage_sound_player = $/root/Node/mainCamera/TakeDamageRailgunSoundPlayer
@onready var drive_sound_player = $/root/Node/mainCamera/DriveSoundPlayer

var maxhealth = 100
var missileReplenish = 1080
var gforce = 0.0

#Movement stats

func custom_init():
	allegiance = "MCRN"
	
	bulletFile = load("res://scenes/projectiles/mcrn/bullet.tscn")
	missileFile = load("res://scenes/projectiles/mcrn/MCRNMissile.tscn")
	missileMarkerFile = load("res://scenes/map/mcrn_missile_marker.tscn")
	shipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")
	bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")
	
	healthBar = get_parent().hud_canvas.health_bar
	
	RCSThrust = 450
	
	health = maxhealth
	healthBar.recalculate(health,maxhealth)
	
	get_parent().MCRNShips.push_back(self)

func on_take_damage(damage):
	healthBar.recalculate(health,maxhealth)
	take_damage_sound_player.play()
	$/root/Node/mainCamera.incrementTrauma(pow(damage, 1/3)*3)

func death():
	get_parent().player_death()
	get_parent().MCRNShips.erase(self)
	
	var small_ship_explosion = shipExplosionFile.instantiate()
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
		if Input.is_action_just_pressed("key_w") && RCSCooldowns[0] == 0 && gforce < 800:
			RCSHard(0)
			RCSCooldowns[0] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_a") && RCSCooldowns[1] == 0 && gforce < 800:
			RCSHard(-PI/2)
			RCSCooldowns[1] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_s") && RCSCooldowns[2] == 0 && gforce < 800:
			RCSHard(PI)
			RCSCooldowns[2] = RCSCooldownLength
			gforce += 200
		if Input.is_action_just_pressed("key_d") && RCSCooldowns[3] == 0 && gforce < 800:
			RCSHard(PI/2)
			RCSCooldowns[3] = RCSCooldownLength
			gforce += 200
	else:
		if Input.is_action_just_pressed("key_w") && RCSCooldowns[0] == 0:
			RCSSoft(0)
			RCSCooldowns[0] = RCSLightCooldownLength
		if Input.is_action_just_pressed("key_a") && RCSCooldowns[1] == 0:
			RCSSoft(PI/2)
			RCSCooldowns[1] = RCSLightCooldownLength
		if Input.is_action_just_pressed("key_s") && RCSCooldowns[2] == 0:
			RCSSoft(PI)
			RCSCooldowns[2] = RCSLightCooldownLength
		if Input.is_action_just_pressed("key_d") && RCSCooldowns[3] == 0:
			RCSSoft(-PI/2)
			RCSCooldowns[3] = RCSLightCooldownLength
	
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
	
	if acceleration != 0:
		drive_sound_player.volume_db = log(acceleration**4)/2
		if !drive_sound_player.playing:
			drive_sound_player.play()
	else:
		if drive_sound_player.playing:
			drive_sound_player.stop()
	
func cameraFunctions():
	if "allegiance" in $/root/Node.mainCamera.target and $/root/Node.mainCamera.target.allegiance != "MCRN":
		target = $/root/Node.mainCamera.target
	if !target or !is_instance_valid(target):
		target = null

func shoot_PDC_audio():
	if !PDC_sound_player.playing:
		PDC_sound_player.play()

func shoot_missile_audio():
	missile_sound_player.play()

func shoot_middle_PDC():
	for i in range(pdcs.size()):
		if pdcs[i].checkActive() and pdcs[i].alwaysResponsive:
			var bullet = bulletFile.instantiate()
			bullet.allegiance = allegiance
			bullet.position = pdcs[i].marker.global_position + velocity/60
			get_parent().add_child(bullet)
			bullet.rotation = pdcs[i].pivot.rotation - pdcs[i].rotation + rotation
			bullet.rotation += rng.randf_range(-PI/60, PI/60)
			bullet.velocity = velocity
			bullet.velocity += Vector2(bulletSpeed,0).rotated(bullet.rotation)
			bullet.set_visible(true)
			
			var bullet_marker = bulletMarkerFile.instantiate()
			bullet_marker.markerTarget = bullet
			get_parent().map_canvas.radar_map.add_child(bullet_marker)

func PDCFunctions():
	var stopSound : bool = true
	if Input.is_action_just_pressed("key_t"):
		PDCAutotrack = !PDCAutotrack
		if PDCAutotrack:
			get_parent().hud_canvas.autotrack_label.text = "PDC Autotrack: ON"
		else:
			get_parent().hud_canvas.autotrack_label.text = "PDC Autotrack: OFF"
	if Input.is_action_pressed("click"):
		shoot_PDC_audio()
		stopSound = false
		if shootCooldown == 0:
			if !PDCAutotrack:
				shoot_PDC()
				shootCooldown = 3
			elif !PDCTarget:
				shoot_middle_PDC()
				shootCooldown = 3
	if PDCAutotrack && PDCTarget:
		shoot_PDC_audio()
		stopSound = false
		if shootCooldown == 0:
			shoot_PDC()
			shootCooldown = 3
	if stopSound:
		PDC_sound_player.stop()
	
	if PDCTarget and !is_instance_valid(PDCTarget):
		PDCTarget = getPDCTarget(incomingMissiles, get_parent().UNNShips, 12)
	
	if getPDCTargetTimer > 30:
		PDCTarget = getPDCTarget(incomingMissiles, get_parent().UNNShips, 12)
		getPDCTargetTimer = 0
	getPDCTargetTimer += 1
		
	if shootCooldown > 0:
		shootCooldown -= 1

func checkFireMissileValid():
	if !target:
		get_parent().hud_canvas.noMissileTargetWarningOn()
		return false
	var relativeDisplacement = target.global_position - position
	var relativeAngle = relativeDisplacement.angle() - Vector2(1,0).rotated(rotation).angle()
	if relativeAngle > PI:
		relativeAngle - 2*PI
	elif relativeAngle < -PI:
		relativeAngle + 2*PI
	
	if relativeDisplacement.length() < 3000 and not abs(relativeAngle) < PI/12:
		get_parent().hud_canvas.tooClose()
		return false
	if relativeDisplacement.length() > 100000:
		get_parent().hud_canvas.tooFar()
		return false
	return true

func missileFunctions():
	if Input.is_action_pressed("key_space") && missileCooldown == 0 && missileReplenish > 180:
		if target:
			shoot_missile(40)
			shoot_missile_audio()
			missileCooldown = 15
			missileReplenish -= 180
		else:
			get_parent().hud_canvas.noMissileTargetWarningOn()
		
	if missileCooldown > 0:
		missileCooldown -= 1
	if missileReplenish < 1080:
		missileReplenish += 1
	get_parent().hud_canvas.setMissileAmmoBar(missileReplenish)

func gforceCheck():
	if acceleration >= 8:
		gforce += 2
	elif acceleration >= 4:
		gforce += 1.5
	elif acceleration >= 2:
		gforce += 0.5
	if gforce > 1:
		gforce -= 1
	if gforce > 990 && acceleration > 2:
		acceleration = 2
	get_parent().hud_canvas.g_limit_bar.value = gforce

func setTargetDisplay():
	if target == null:
		get_parent().hud_canvas.target_label.text = "No Target Selected" 
	elif "displayType" in target:
		get_parent().hud_canvas.target_label.text = "Target:\n" + target.displayType
		if "displayName" in target:
			get_parent().hud_canvas.target_label.text += "\n"+target.displayName

func shipFunctions():
	driveControl()
	RCSControl()
	rotationControl()
	gforceCheck()
	setTargetDisplay()
	cameraFunctions()
	PDCFunctions()
	missileFunctions()
