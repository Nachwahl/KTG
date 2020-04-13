tool
extends GameTextureButton
class_name LoadButton

const PORTRAIT_PATH_FORMAT = "res://resources/sprites/level_selection/boss_level_%1d_%s.png"
const LEVEL_SCENE_FORMAT = "res://level/1/Level%1d.tscn"

enum LOCK_STATES {UNLOCKED, LOCKED, TBA}


export(int) var level_to_load = 0 setget set_level_to_load
export(bool) var boss_unknown = true setget set_boss_unknown
export(bool) var locked = false setget set_locked
export(bool) var coming_soon = false setget set_coming_soon
export(Texture) var boss_portait = null setget set_boss_portrait


func _ready():
	set_level_to_load(level_to_load)


func load_boss_portrait():
	var new_portrait
	if boss_unknown:
		new_portrait = load(PORTRAIT_PATH_FORMAT % [level_to_load, "unknown"])
	else:
		new_portrait = load(PORTRAIT_PATH_FORMAT % [level_to_load, "known"])
	set_boss_portrait(new_portrait)


func set_level_to_load(_level_to_load):
	level_to_load = _level_to_load
	if !Engine.is_editor_hint() and SCENES.LEVELS.has(level_to_load):
		load_boss_portrait()
		if has_node("LevelLabel"):
			$LevelLabel.text = SCENES.LEVELS[level_to_load]["name"]


func set_boss_unknown(_boss_unknown):
	boss_unknown = _boss_unknown
	load_boss_portrait()
	set_boss_portrait(boss_portait)



func set_locked(_locked):
	locked = _locked
	if has_node("LockedOverlay"):
		$LockedOverlay.visible = (_locked and !coming_soon)
		disabled = locked or coming_soon


func set_coming_soon(_coming_soon):
	coming_soon = _coming_soon
	if has_node("ComingSoonOverlay"):
		$ComingSoonOverlay.visible = coming_soon
		$BossPortrait.visible = !coming_soon
		disabled = locked or coming_soon


func set_boss_portrait(_boss_portrait):
	boss_portait = _boss_portrait
	if has_node("BossPortrait"):
		$BossPortrait.texture = boss_portait


func _on_LoadButton_button_up():
	if SCENES.LEVELS.has(level_to_load):
		LevelChanger.change_level_to(SCENES.LEVELS[level_to_load]["path"])
