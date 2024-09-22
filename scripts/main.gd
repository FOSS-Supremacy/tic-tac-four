extends Control

const Cell = preload("res://scenes/cell.tscn")

@export_enum("Human", "AI") var play_with : String = "Human"

var cells : Array = []
var turn : int = 0

var is_game_end : bool = false

func _ready():
	for cell_count in range(64):
		var cell = Cell.instantiate()
		cell.main = self
		$cells.add_child(cell)
		cells.append(cell)
		cell.cell_updated.connect(_on_cell_updated)

func _on_cell_updated(cell):
	randomize()
	var match_result = check_match()
	
	print(match_result)
	
	if match_result:
		is_game_end = true
		start_win_animation(match_result)
	
	elif play_with == "AI" and turn == 1:
		var ai_cell = cells[randi() % cells.size()]
		if ai_cell.cell_value == "":
			ai_cell.draw_cell()
		else:
			_on_cell_updated(cell)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func check_match():
	for h in range(8):
		for start in range(5):
			if cells[start + h * 8].cell_value == "X" and cells[start + 1 + h * 8].cell_value == "X" and cells[start + 2 + h * 8].cell_value == "X" and cells[start + 3 + h * 8].cell_value == "X":
				return ["X", start + h * 8 + 1, start + h * 8 + 2, start + h * 8 + 3]
	
	for v in range(8):
		for start in range(5):
			if cells[v + start * 8].cell_value == "X" and cells[v + (start + 1) * 8].cell_value == "X" and cells[v + (start + 2) * 8].cell_value == "X" and cells[v + (start + 3) * 8].cell_value == "X":
				return ["X", (start + 1) * 8 + v + 1, (start + 2) * 8 + v + 1, (start + 3) * 8 + v + 1]

	for start in range(5):
		for row in range(5):
			if cells[start + row * 8].cell_value == "X" and cells[start + (row + 1) * 8 + 1].cell_value == "X" and cells[start + (row + 2) * 8 + 2].cell_value == "X" and cells[start + (row + 3) * 8 + 3].cell_value == "X":
				return ["X", start + row * 8 + 1, start + (row + 1) * 8 + 2, start + (row + 2) * 8 + 3]

	for start in range(3, 8):
		for row in range(5):
			if cells[start + row * 8].cell_value == "X" and cells[start + (row + 1) * 8 - 1].cell_value == "X" and cells[start + (row + 2) * 8 - 2].cell_value == "X" and cells[start + (row + 3) * 8 - 3].cell_value == "X":
				return ["X", start + row * 8 + 1, start + (row + 1) * 8, start + (row + 2) * 8]

	var full = true
	for cell in cells:
		if cell.cell_value == "":
			full = false
	
	if full: return["Draw", 0, 0, 0]

func start_win_animation(match_result: Array):
	var color: Color
	
	if match_result[0] == "X":
		color = Color.BLUE
	elif match_result[0] == "O":
		color = Color.RED
	
	for c in range(3):
		cells[match_result[c+1]-1].glow(color)
