extends ColorRect

var cameraLockable = []

const cameraLockDistanceInMap = 50
const cameraLockDistanceInGame = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("key_v"):
		if $/root/Node/mainCamera.target != $/root/Node/mainCamera.player:
			$/root/Node/mainCamera.prevTarget = $/root/Node/mainCamera.target
		$/root/Node/mainCamera.target = $/root/Node/mainCamera.player
		print($/root/Node/mainCamera.prevTarget)
	if Input.is_action_pressed("key_c"):
		var minDistance = INF
		var closestMarker = null
		if $/root/Node/map_canvas.visible:
			for el in cameraLockable:
				if (el.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInMap,minDistance):
					minDistance = (el.global_position - get_global_mouse_position()).length()
					closestMarker = el
			if closestMarker:
				$/root/Node/mainCamera.target = closestMarker.markerTarget
			elif $/root/Node/mainCamera.prevTarget:
				$/root/Node/mainCamera.target = $/root/Node/mainCamera.prevTarget
			print($/root/Node/mainCamera.prevTarget)
		#else:
			#var absoluteMousePos = get_global_mouse_position() + $/root/Node/mainCamera.target.position
			#print(absoluteMousePos)
			#for el in cameraLockable:
				#print(el.markerTarget.global_position)
				#if (el.markerTarget.global_position - get_global_mouse_position()).length() < min(cameraLockDistanceInGame,minDistance):
					#minDistance = (el.markerTarget.global_position - get_global_mouse_position()).length()
					#closestMarker = el
			#if closestMarker:
				#$/root/Node/mainCamera.target = closestMarker.markerTarget
			#print("----------")
