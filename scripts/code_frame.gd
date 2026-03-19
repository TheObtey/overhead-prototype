extends Area2D

const SECRET_CODE := "2486"

var entered_digits: String = ""
var keypad_overlay: CanvasLayer
var display_label: Label

func _ready() -> void:
	input_pickable = true
	print("I'm ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_build_keypad()

func _build_keypad() -> void:
	# CanvasLayer pour passer au-dessus de tout
	keypad_overlay = CanvasLayer.new()
	keypad_overlay.layer = 10
	keypad_overlay.visible = false
	add_child(keypad_overlay)

	# Fond semi-transparent plein écran
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.55)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	keypad_overlay.add_child(bg)

	# Panel central
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(260, 360)
	panel.offset_left   = -130
	panel.offset_right  =  130
	panel.offset_top    = -180
	panel.offset_bottom =  180
	keypad_overlay.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	# Titre
	var title := Label.new()
	title.text = "Entrez le code"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Affichage des chiffres saisis
	display_label = Label.new()
	display_label.text = "----"
	display_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	display_label.add_theme_font_size_override("font_size", 32)
	vbox.add_child(display_label)

	# Grille 3 colonnes pour les boutons 1-9 + 0
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	vbox.add_child(grid)

	# Boutons 1 → 9
	for i in range(1, 10):
		_add_digit_button(grid, str(i))

	# Ligne du bas : vide | 0 | fermer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(60, 60)
	grid.add_child(spacer)

	_add_digit_button(grid, "0")

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(60, 60)
	close_btn.pressed.connect(_close_keypad)
	grid.add_child(close_btn)

func _add_digit_button(parent: Node, digit: String) -> void:
	var btn := Button.new()
	btn.text = digit
	btn.custom_minimum_size = Vector2(60, 60)
	btn.pressed.connect(_on_digit_pressed.bind(digit))
	parent.add_child(btn)

# Ouvre le pavé au clic sur le cadre
func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_open_keypad()

func _open_keypad() -> void:
	entered_digits = ""
	_refresh_display()
	keypad_overlay.visible = true

func _close_keypad() -> void:
	keypad_overlay.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()

func _on_digit_pressed(digit: String) -> void:
	if entered_digits.length() >= 4:
		return
	entered_digits += digit
	_refresh_display()

	if entered_digits.length() == 4:
		_check_code()

func _refresh_display() -> void:
	var shown := entered_digits
	while shown.length() < 4:
		shown += "-"
	display_label.text = shown

func _check_code() -> void:
	if entered_digits == SECRET_CODE:
		print("✅ Bien joué ! Code correct.")
		_close_keypad()
		# → ici tu peux émettre un signal, ouvrir une porte, etc.
	else:
		print("❌ Mauvais code : %s" % entered_digits)
		# Petit délai visuel puis reset
		await get_tree().create_timer(0.4).timeout
		entered_digits = ""
		_refresh_display()
