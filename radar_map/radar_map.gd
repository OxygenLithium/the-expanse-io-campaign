extends ColorRect

@export var mainCamera : Node2D

var cameraLockable = []

const cameraLockDistanceInMap = 50
const cameraLockDistanceInGame = 150

var mapCenter = Vector2(0,0)

var mapScale = 50
const mapScales = [1000,250,50,10]

var mapSizeNumber = 2

const mapRadius = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cameraTarget = mainCamera.getTarget()
	var cameraPrevTarget = mainCamera.getPrevTarget()
	if !cameraTarget:
		return
	
	if Input.is_action_just_pressed("key_-") and mapSizeNumber > 0:
		mapSizeNumber -= 1
		mapScale = mapScales[mapSizeNumber]
		if mapSizeNumber == 0:
			mapCenter = Vector2(0,0)
	if Input.is_action_just_pressed("key_+") and mapSizeNumber < 3:
		mapSizeNumber += 1
		mapScale = mapScales[mapSizeNumber]
	if mapSizeNumber > 0:
		mapCenter = cameraTarget.position
	if Input.is_action_just_pressed("key_v"):
		if cameraTarget != $/root/Node/mainCamera.player:
			mainCamera.setPrevTarget(cameraTarget)
		mainCamera.setTarget($/root/Node/mainCamera.player)
	if Input.is_action_just_pressed("key_c"):
		var minDistance = INF
		var closestMarker = null
		if $/root/Node/map_canvas.visible:
			for el in cameraLockable:
				if (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
					minDistance = (el.global_position - get_global_mouse_position()).length()
					closestMarker = el
			if closestMarker:
				mainCamera.setTarget(closestMarker.markerTarget)
			elif $/root/Node/mainCamera.prevTarget:
				mainCamera.setTarget(cameraPrevTarget)
		#else:
			#var absoluteMousePos = get_global_mouse_position() + cameraTarget.position
			#print(absoluteMousePos)
			#for el in cameraLockable:
				#print(el.markerTarget.global_position)
				#if (el.markerTarget.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInGame,minDistance):
					#minDistance = (el.markerTarget.global_position - get_global_mouse_position()).length()
					#closestMarker = el
			#if closestMarker:
				#cameraTarget = closestMarker.markerTarget
			#print("----------")
