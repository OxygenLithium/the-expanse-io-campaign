extends CanvasLayer

@export var missionFailedScreen : Label
@export var missionAccomplishedScreen : Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	missionFailedScreen.visible = false
	missionAccomplishedScreen.visible = false

func missionFailed():
	missionFailedScreen.visible = true

func missionAccomplished():
	missionAccomplishedScreen.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
