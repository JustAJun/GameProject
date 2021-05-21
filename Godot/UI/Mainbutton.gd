extends TextureButton
onready var audio = $AudioStreamPlayer

func _ready():
	get_child(0).animation = "CandlesBurning"
	
func _physics_process(delta):
	if is_hovered():
		grab_focus()
	
	if has_focus():
		get_child(0).playing = true
		get_child(0).visible = true
	else: 
		get_child(0).playing = false
		get_child(0).visible = false


func _on_Button_pressed():
	audio.play()
