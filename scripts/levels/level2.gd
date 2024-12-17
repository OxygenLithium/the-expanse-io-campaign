extends "res://scripts/levels/abstract_level.gd"

func level_init():
	missionType = "destroySingleTarget"

func unn_ship_destroyed(ship):
	if ship == target:
		victory()

func place_ships():
	addMulan(Vector2(110000,6000), "UNN Honolulu")
	addMulan(Vector2(110000,-6000), "UNN Arthur Cayley")
	addMulan(Vector2(100000,0), "UNN Triangulum")
	
	target = addTrenton(Vector2(500000,0), "UNN Chesapeake")
	
	setEscort(addAndronicus(Vector2(499000,-2000), "UNN Rawlinson"), target)
	setEscort(addAndronicus(Vector2(501000,-2000), "UNN Arthur Dent"), target)
	setEscort(addAndronicus(Vector2(499000,2000), "UNN Horatio"), target)
	setEscort(addAndronicus(Vector2(501000,2000), "UNN Claudius"), target)
