tool
extends CheckButton
class_name CheckGameButton

func _ready():
	connect("button_up", self, "_on_GameCheckButton_button_up")
	connect("button_down", self, "_on_GameCheckButton_button_down")
	mouse_default_cursor_shape = CURSOR_POINTING_HAND



func _on_GameCheckButton_button_up():
	AudioHandler.play_sound("menu_button_released")


func _on_GameCheckButton_button_down():
	AudioHandler.play_sound("menu_button_pressed")