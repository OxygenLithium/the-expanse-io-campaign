extends "res://scripts/levels/abstract_level.gd"

func unn_ship_destroyed(ship):
	construct_mission_label()
	if UNNShips.size() < 1:
		victory()

func place_ships():
	addMulan(Vector2(100000,6000), "UNN Ashgrove")
	addMulan(Vector2(110000,12000), "UNN Ibadan")
	addMulan(Vector2(110000,0), "UNN Riemann")
