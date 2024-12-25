extends Node2D

@export var pivot : Node2D
@export var marker : Marker2D
@export var alwaysResponsive : bool

@onready var shooter = get_parent()

var currPDCTargetAngle = 0
var prevPDCTargetAngle = 0
var active = true

var target = null
var closingVelocity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().pdcs.append(self)
	pivot.rotation -= rotation
	pass # Replace with function body.

func getClosingVelocity():
	closingVelocity = -(target.velocity - get_parent().velocity).dot(target.position - global_position)/(target.position - global_position).dot(target.position - global_position)*((target.position - global_position).length())

func calc_lead():
	getClosingVelocity()
	if "acceleration" in target:
		return (target.velocity - get_parent().velocity)*((target.global_position - global_position).length()/(get_parent().bulletSpeed + closingVelocity)) + Vector2(target.acceleration,0).rotated(target.rotation)*(((target.global_position-global_position).length()/(get_parent().bulletSpeed + closingVelocity))**2)*30
	return (target.velocity - get_parent().velocity)*((target.global_position-global_position).length()/(get_parent().bulletSpeed + closingVelocity))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target = get_parent().PDCTarget
	active = true
	
	if get_parent().PDCAutotrack and !(alwaysResponsive and Input.is_action_pressed("click")):
		if get_parent().PDCTarget and is_instance_valid(get_parent().PDCTarget):
			currPDCTargetAngle = (get_parent().PDCTarget.global_position-global_position).angle()
			if abs(currPDCTargetAngle - prevPDCTargetAngle) < PI/30 or abs(currPDCTargetAngle - prevPDCTargetAngle) > 59*PI/30:
				pivot.look_at(get_parent().PDCTarget.global_position)
			else:
				pivot.look_at(global_position + calc_lead() + get_parent().velocity/60)
			prevPDCTargetAngle = currPDCTargetAngle
	else:
		if get_parent().get_parent().map_canvas.visible:
			pivot.look_at((get_global_mouse_position()-$/root/Node.mainCamera.target.position)*get_parent().get_parent().map_canvas.radar_map.mapScale + get_parent().get_parent().map_canvas.radar_map.mapCenter + shooter.velocity/60)
		else:
			pivot.look_at(get_global_mouse_position() + shooter.velocity/60)
	
	if (fmod(pivot.rotation,2*PI) > 0) and (fmod(pivot.rotation,2*PI) < PI):
		pivot.rotation = 0
		active = false
	elif fmod(pivot.rotation,2*PI) < -PI:
		pivot.rotation = 0
		active = false
