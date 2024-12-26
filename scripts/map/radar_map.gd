extends ColorRect

@onready var mainCamera = $/root/Node/mainCamera

@export var radiusLabel : Label

var cameraLockable = []
var cameraLockable2 = []

const cameraLockDistanceInMap = 50
const cameraLockDistanceInGame = 150

var mapCenter = Vector2(0,0)
var mapScale = 20
const mapRadius = 600

var showNames = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cameraTarget = mainCamera.getTarget()
	var cameraPrevTarget = mainCamera.getPrevTarget()
	if !cameraTarget:
		return
		
	if Input.is_action_just_pressed("key_n"):
		showNames = !showNames
	
	if Input.is_action_just_pressed("key_-"):
		if get_parent().visible:
			if Input.is_action_pressed("key_shift"):
				mapScale *= 16
			else:
				mapScale *= 2
			radiusLabel.text = "Map Diameter: " + str(mapScale*4) + "km"
	if Input.is_action_just_pressed("key_+") and mapScale > 10:
		if get_parent().visible:
			if Input.is_action_pressed("key_shift"):
				mapScale = mapScale/16
				if mapScale < 10:
					mapScale = 10
			else:
				mapScale = mapScale/2
			radiusLabel.text = "Map Diameter: " + str(mapScale*4) + "km"
	mapCenter = cameraTarget.position
		
	if Input.is_action_just_pressed("key_v"):
		if cameraTarget != $/root/Node.mainCamera.player:
			mainCamera.setPrevTarget(cameraTarget)
		mainCamera.setTarget($/root/Node.mainCamera.player)
		
	if Input.is_action_just_pressed("key_c"):
		var minDistance = INF
		var closestMarker = null
		if visible:
			for el in cameraLockable:
				if (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
					minDistance = (el.global_position - get_global_mouse_position()).length()
					closestMarker = el
			if Input.is_action_pressed("key_shift"):
				for el in cameraLockable2:
					if (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
						minDistance = (el.global_position - get_global_mouse_position()).length()
						closestMarker = el
			if closestMarker:
				mainCamera.setTarget(closestMarker.markerTarget)
			elif $/root/Node.mainCamera.prevTarget:
				mainCamera.setTarget(cameraPrevTarget)
	if Input.is_action_just_pressed("key_f"):
		var minDistance = INF
		var closestMarker = null
		if visible:
			for el in cameraLockable:
				if el.markerTarget.allegiance != "MCRN" and (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
					minDistance = (el.global_position - get_global_mouse_position()).length()
					closestMarker = el
			if Input.is_action_pressed("key_shift"):
				for el in cameraLockable2:
					if el.markerTarget.allegiance != "MCRN" and (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
						minDistance = (el.global_position - get_global_mouse_position()).length()
						closestMarker = el
			if closestMarker:
				get_parent().get_parent().player.target = closestMarker.markerTarget
