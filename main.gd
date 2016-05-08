
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var res = []

var texture_o
var texture_x

var img_o = preload("sprites/o.png")
var img_x = preload("sprites/x.png")

var game_states = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var select_init = 'o'
var dificult = 1
func _ready2():
	# Called every time the node is added to the scene.
	# Initialization here
	OS.execute("./gato.pl", StringArray(["D", 1]), true, res)
	print(res)
	print("end")
	var arr = evaluate(res)
	for i in arr:
		print(i)
	get_node("Label").set_text(str(res))

func _ready():
	get_node("Buttons/B1").connect("pressed", self, "_b1")
	get_node("Buttons/B2").connect("pressed", self, "_b2")
	get_node("Buttons/B3").connect("pressed", self, "_b3")
	get_node("Buttons/B4").connect("pressed", self, "_b4")
	get_node("Buttons/B5").connect("pressed", self, "_b5")
	get_node("Buttons/B6").connect("pressed", self, "_b6")
	get_node("Buttons/B7").connect("pressed", self, "_b7")
	get_node("Buttons/B8").connect("pressed", self, "_b8")
	get_node("Buttons/B9").connect("pressed", self, "_b9")
	get_node("Popup/Reload").connect("pressed", self, "_reload")
	get_node("Configuración/Play").connect("pressed", self, "_go_game")
	var options = get_node("Configuración/OptionButton")
	options.add_icon_item(img_x, "Tú", 1)
	options.add_icon_item(img_o, "PC", 2)
	var levels = get_node("Configuración/Level")
	levels.add_item("Facil", 1)
	levels.add_item("Dificil", 2)

func _play(button, val="x"):
	print("play")
	if val == "x":
		_change(button, val)

	print(game_states)
	var move = StringArray(game_states)
	if val == "x": #movimiento inicial por pc
		move.push_back(button)
	print("Exec", move)
	OS.execute("./Gato.pl", StringArray(move), true, res)
	print("resss")
	print(res)
	print(".")
	var win = res[0][38]
	if win == '1':
		print("gano 1")
		_winner("Gano el \njugador: x")
	elif win == '2':
		print("gano 2")
		_winner("Gano el \njugador: o")
	elif win == '3':
		_winner("Es un empate")
		
	res[0][39] = ''
	res[0][38] = ''
	res[0][37] = ''
	game_states = evaluate(res)
	var index = 1
	for i in game_states:
		var name = "Buttons/B" + str(index)
		if ! _used(name) and i == '2':
			_change(str(index), 'o')
		index += 1
	
	if dificult == 2:
		game_states.push_front("d")
	else:
		game_states.push_front("f")

func _change(button, player):
	var name = "Buttons/B" + button
	var node = get_node(name)
	if player == "o":
		node.set_normal_texture(img_o)
	else:
		node.set_normal_texture(img_x)
	node.set_meta("used", true)

func _winner(text):
	get_node("Popup").show()
	get_node("Popup/Win").set_text(text)
	get_tree().set_pause(true)

func evaluate(input):
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + str(input))
	script.reload()

	var obj = Reference.new()
	obj.set_script(script)

	return obj.eval()

func _b1():
	_move_button("Buttons/B1", 1)
func _b2():
	_move_button("Buttons/B2", 2)
func _b3():
	_move_button("Buttons/B3", 3)
func _b4():
	_move_button("Buttons/B4", 4)
func _b5():
	_move_button("Buttons/B5", 5)
func _b6():
	_move_button("Buttons/B6", 6)
func _b7():
	_move_button("Buttons/B7", 7)
func _b8():
	_move_button("Buttons/B8", 8)
func _b9():
	_move_button("Buttons/B9", 9)

func _move_button(node, index):
	if !_used(node):
		_play(str(index))

func _used(node):
	return get_node(node).has_meta("used")

func _reload():
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	
func _go_game():
	var initial = get_node("Configuración/OptionButton").get_selected_ID()
	dificult = get_node("Configuración/Level").get_selected_ID()
	print(initial)
	print(dificult)
	get_node("Configuración").hide()
	if dificult == 2:
		game_states.push_front("d")
	else:
		game_states.push_front("f")
	if initial == 2:
		print('inicia pc')
		_play(0, "o")
	get_node("Game").show()
	get_node("Buttons").show()