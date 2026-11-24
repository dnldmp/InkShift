extends SceneTree
var n := 0
var p
var died := false
var last := Vector2.ZERO
var sc: Dictionary
const SC := {
	"l1_segredo1": {"lvl": 1, "shape": "drop", "cell": Vector2i(13, 13), "dir": 1, "jump_x": [222], "frames": 40},
	"l1_segredo2": {"lvl": 1, "shape": "drop", "cell": Vector2i(46, 11), "dir": 1, "jump_x": [766], "frames": 45},
	"l1_campo": {"lvl": 1, "shape": "drop", "cell": Vector2i(104, 12), "dir": 1, "jump_x": [1680, 1760], "frames": 90},
	"l1_fim": {"lvl": 1, "shape": "drop", "cell": Vector2i(1, 15), "dir": 1, "jump_x": [110, 175, 300, 415, 595, 640, 700, 760, 910, 950, 1000, 1210, 1340, 1440, 1555, 1680, 1760, 2225], "frames": 1500},
	"l2_plato": {"lvl": 2, "shape": "spring", "cell": Vector2i(55, 15), "dir": 1, "jump_x": [905, 1048], "frames": 150},
	"l2_segredo": {"lvl": 2, "shape": "spring", "cell": Vector2i(69, 5), "dir": -1, "jump_x": [1078], "frames": 90},
	"l2_cercas": {"lvl": 2, "shape": "spring", "cell": Vector2i(103, 11), "dir": 1, "jump_x": [1650], "frames": 120},
	"l2_final": {"lvl": 2, "shape": "spring", "cell": Vector2i(112, 15), "dir": 1, "jump_x": [1835, 1885], "frames": 300},
	"l2_tunel_secreto": {"lvl": 2, "shape": "drop", "cell": Vector2i(119, 15), "dir": 1, "jump_x": [], "frames": 120},
	"l3_dois_papeis": {"lvl": 3, "shape": "weight", "cell": Vector2i(57, 15), "dir": 1, "jump_x": [], "frames": 260},
	"l3_bolso": {"lvl": 3, "shape": "weight", "cell": Vector2i(100, 15), "dir": 1, "jump_x": [], "frames": 150},
	"l3_sair_bolso": {"lvl": 3, "shape": "drop", "cell": Vector2i(102, 17), "dir": 1, "jump_x": [1650], "frames": 60},
	"l3_ponte_gota": {"lvl": 3, "shape": "drop", "cell": Vector2i(108, 15), "dir": 1, "jump_x": [1795], "frames": 260},
	"l3_ponte_peso": {"lvl": 3, "shape": "weight", "cell": Vector2i(110, 15), "dir": 1, "jump_x": [], "frames": 120},
	"l4_corredor": {"lvl": 4, "shape": "weight", "cell": Vector2i(73, 15), "dir": 1, "jump_x": [], "frames": 320},
	"l4_saida_mola": {"lvl": 4, "shape": "spring", "cell": Vector2i(88, 19), "dir": 1, "jump_x": [1440], "frames": 80},
	"l4_patio_mola": {"lvl": 4, "shape": "spring", "cell": Vector2i(99, 11), "dir": 1, "jump_x": [1620, 1748, 1876], "frames": 220},
	"l4_pedestal": {"lvl": 4, "shape": "spring", "cell": Vector2i(123, 15), "dir": 1, "jump_x": [1988], "frames": 60},
	"l4_botao2": {"lvl": 4, "shape": "weight", "cell": Vector2i(126, 10), "dir": 1, "jump_x": [], "frames": 40},
	"l4_ponte": {"lvl": 4, "shape": "drop", "cell": Vector2i(129, 15), "dir": 1, "jump_x": [2098], "frames": 150},
}
func _initialize() -> void:
	sc = SC[OS.get_environment("SC")]
	change_scene_to_file("res://levels/level_0%d.tscn" % sc.lvl)
func _physics_process(_d: float) -> bool:
	var room = current_scene
	if room == null: return false
	n += 1
	if n == 2:
		p = room.get_node("Player")
		var sh = load("res://shapes/%s.tres" % sc.shape)
		p.learn(sh)
		p.apply_shape(sh)
		p.global_position = Vector2(sc.cell.x * 16 + 8, (sc.cell.y + 1) * 16)
		p.respawn_point = Vector2(-999, -999)
		p.reset_physics_interpolation()
		Input.action_press("move_right" if sc.dir > 0 else "move_left")
	if n > 2:
		if not is_instance_valid(p):
			print("%s: CHEGOU NA SAIDA morreu=%s" % [OS.get_environment("SC"), died]); quit(); return false
		if not p.visible and not died: print("MORREU em ", last)
		if not p.visible: died = true
		if p.visible: last = p.global_position.round()
		if OS.get_environment("TRACE") != "" and n % 6 == 0 and p.visible: print("  f", n, " ", p.global_position.round(), " chao=", p.is_on_floor())
		var want_jump := false
		for jx in sc.jump_x:
			if p.global_position.x > jx and p.global_position.x < jx + 20: want_jump = true
		if want_jump and p.is_on_floor() and not Input.is_action_pressed("jump"):
			Input.action_press("jump")
		elif Input.is_action_pressed("jump") and p.velocity.y > 0:
			Input.action_release("jump")
	if n == sc.frames + 2:
		var extra := ""
		extra = " portoes=%d" % room.find_children("Gate*", "", true, false).size()
		for g in []:
			if g.name.begins_with("Gate"): extra += " gate_aberto=%s" % (not is_instance_valid(g) or g.is_queued_for_deletion())
		var papers := room.find_children("TornPaper*", "", true, false).size()
		var erasers := room.find_children("Eraser*", "", true, false).size()
		print("%s: pos=(%.0f,%.0f) celula=(%d,%d) morreu=%s chao=%s papeis=%d borrachas=%d%s" % [OS.get_environment("SC"), p.global_position.x, p.global_position.y, int(p.global_position.x) / 16, int(p.global_position.y - 1) / 16, died, p.is_on_floor(), papers, erasers, extra])
		quit()
	return false
