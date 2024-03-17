GDPC                 �                                                                             res://.godot/extension_list.cfg  �     j       )%.��P��-#��    ,   res://.godot/global_script_class_cache.cfg  ��           �Pg
_�5~����&`;       res://.godot/uid_cache.bin  �     =      �x�/�\;Qfh9X�    8   res://addons/discord-sdk-gd/nodes/discord_autoload.gd   `�     f       ��$�M:;��(���    4   res://modres/ommodutils/custom_character_select.gd          1	       ����`J������s    (   res://modres/ommodutils/window_camera.gd@	      J       N�����L.��bx       res://project.binaryp�     ��      ��Y���#h�gE�|�       res://src/autoload/audio.gd @V      �      14��Я�Jg,��B        res://src/autoload/controls.gd  ��      _7      5<��ɺ�������T    $   res://src/autoload/discord_rpc.gd    |     6      ��e�Bt������!�       res://src/autoload/events.gd 
     �      Fnv>K����OE�C>       res://src/autoload/focus.gd P#     Z      ��*:�������u��       res://src/autoload/game.gd  �m      �_      ��0}��"6���       res://src/autoload/global.gd8      �      ں�1;���`Kc�w
�       res://src/autoload/meta.gd   �     n       ^�{��xT�LAЩ;{�C        res://src/autoload/players.gd   �     �      �)uW�@1V�D&6=�        res://src/autoload/rawInput.gd  �d      	      �&qV�w~��f��W�    $   res://src/autoload/shaderPreload.gd ��      1      [�҅ ��8��ἥ
�       res://src/autoload/stats.gd Ј     L      ���h��'�\��%vM        res://src/autoload/torCurve.gd  �R            CNVT�0*_^��y2        res://src/autoload/unlocks.gd   �>     e=      (kW�Q�4�F�5A       res://src/autoload/utils.gd �	      {.      p���;b��E �'G�R       res://src/iconicon.svg  ��     2      
��V�S��!ʫ�        extends TitleWindow
@onready var button = %Button
@onready var char_icon_bg = %charIconBG
@onready var char_icon = %charIcon
@onready var crown = %crown
var char:=Players.Char.BASIC
var charName:String
var charVisualName:String
var mod:String
var color := Color.WHITE
var colorState := 0
var skinIndex := 0
var skin := ""
func _ready():
	print("im custom!!!")
	button.click.connect(startGame)
	Events.titleCharColor.connect(func(val):
		color = val
		updateChar()
	)
	Events.titleCharColorState.connect(func(val):
		colorState = val
		updateChar()
	)
	Events.titleCharSkin.connect(func(dir):
		skinIndex = posmod(skinIndex+dir, Players.charData[char].skins.size())
		updateChar()
	)
	var charList = Players.unlockedCharList
	char = charList[Global.title._charId]
	Global.title._charId += 1
	crown.rotation = randf_range(-TAU/16,TAU/16)
	print("got here")
	updateState()
	Events.titleReturn.connect(updateState)
	updateChar()
func startGame():
	Players.inMultiplayer = false
	Players.playerCount = 1
	Players.details = [{
		char = char,
		charInt = charName,
		color = color,
		bgColor = Color.TRANSPARENT,
		colorState = colorState,
		skin = skin,
		charMod = mod
	}]
	Players.saveData(true)
	Global.title.startGame()
func updateState():
	Utils.runLater(1, func():
		color = Players.singleDetails.color
		colorState = Players.singleDetails.colorState
		if Players.charData[char].skins.has(Players.singleDetails.skin):
			skin = Players.singleDetails.skin
			skinIndex = Players.charData[char].skins.find(skin)
		updateChar()
	)
func updateChar():
	print("EVEN HERE")
	if colorState == 0:
		char_icon.modulate = color
		char_icon_bg.modulate = Color.TRANSPARENT
	elif colorState == 1:
		char_icon.modulate = color
		char_icon_bg.modulate = Color.WHITE
	elif colorState == 2:
		char_icon.modulate = Color.WHITE
		char_icon_bg.modulate = color
	skin = ""
	print("if i am called this next line is the problem")
	#if Players.charData[char].skins.size() > 1:
	#skin = Players.charData[char].skins[skinIndex]
	
	print(charName)
	print(mod)
	print(charVisualName)
	char_icon.texture = load("res://modres/"+mod+"/characters/"+charName+"/top.png")
	char_icon_bg.texture = load("res://modres/"+mod+"/characters/"+charName+"/back.png")
	button.title = charVisualName
	
	if skin == "skinCrown":
		crown.visible = true
	else:
		crown.visible = false
	button.update()
               extends Camera2D

func _process(delta):
	position = get_parent().position
      extends Node
var deltaBase := 0.01666666666667
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
func instance(scene:Resource, args:Dictionary = {}) -> Node:
	var inst = scene.instantiate()
	if not args.is_empty():
		var iargs = inst.get("args")
		if iargs != null:
			iargs.merge(args, true)
	return inst
func spawn(scene:Resource, position:Vector2, parent:Node, args:Dictionary = {}) -> Node:
	var inst = scene.instantiate()
	if not args.is_empty():
		var iargs = inst.get("args")
		if iargs != null:
			iargs.merge(args, true)
	inst.position = position
	parent.call_deferred("add_child", inst)
	return inst
func place(scene:Resource, parent:Node, args:Dictionary = {}) -> Node:
	var inst = scene.instantiate()
	if not args.is_empty():
		var iargs = inst.get("args")
		if iargs != null:
			iargs.merge(args, true)
	parent.call_deferred("add_child", inst)
	return inst
func removeChildren(parent:Node):
	for c in parent.get_children():
		parent.remove_child(c)
func sprite(path:String) -> Sprite2D:
	var spr = Sprite2D.new()
	spr.texture = load(path)
	return spr
func mouseScreenPos() -> Vector2:
	return get_viewport().get_mouse_position()
func within(a:Variant, b:Variant, dist:float = 0.0) -> bool:
	return abs(a - b) < dist
func withinVec(a:Vector2, b:Vector2, dist:float = 0.0) -> bool:
	return abs(a.distance_to(b)) < dist
func withinVecFast(a:Vector2, b:Vector2, dist:float = 0.0) -> bool:
	return abs(a.x - b.x) < dist and abs(a.y - b.y) < dist
func withinRect(a:Rect2, b:Rect2, dist:float = 0.0) -> bool:
	return withinVec(a.position, b.position, dist) and withinVec(a.end, b.end, dist)
func withinRectFast(a:Rect2, b:Rect2, dist:float = 0.0) -> bool:
	return withinVecFast(a.position, b.position, dist) and withinVecFast(a.end, b.end, dist)
func axisWithin(a:Vector2, b:Vector2, dist:float = 0.0) -> bool:
	return abs(a.x - b.x) < dist or abs(a.y - b.y) < dist
func lexp(a:Variant, b:Variant, t:float):
	return a + (b - a) * (1.0 - exp(-t))
func slexp(a:Vector2, b:Vector2, t:float):
	return a.slerp(b, 1.0 - exp(-t))
func spring(a:Variant, b:Variant, vel:Variant, acc := 2.0, att := 0.9):
	vel += acc * (b - a)
	vel *= att
	return vel
func dualSpring(a:Variant, b:Variant, vel:Variant, acc1 := 0.5, acc2 := 4.0, att := 0.9):
	vel += lerp(acc2, acc1, (vel.normalized().dot((b-a).normalized()) + 1.0) / 2.0) * (b - a)
	vel *= att
	return vel
func flip(test:bool):
	return 1 if test else -1
func randFlip():
	return -1 if randf() < 0.5 else 1
var _awaitCancelIndex := 0
var _awaitCancelToggle := false
func runLater(ms:float, f:Callable):
	if _awaitCancelToggle:
		return
	if ms <= 0.0:
		if f.is_valid():
			f.call_deferred()
	else:
		var index = _awaitCancelIndex
		await(get_tree().create_timer(ms/1000.0).timeout)
		if index == _awaitCancelIndex:
			if f.is_valid():
				f.call_deferred()
func processLater(node:Node, ms:float, f:Callable):
	if _awaitCancelToggle:
		return
	if ms <= 0.0:
		if f.is_valid():
			f.call_deferred()
	else:
		var timer = Timer.new()
		node.add_child(timer)
		timer.start(ms/1000.0)
		var index = _awaitCancelIndex
		await(timer.timeout)
		if index == _awaitCancelIndex:
			if f.is_valid():
				f.call_deferred()
func cancelAwaits():
	_awaitCancelIndex += 1
func toggleAwaits(val := true):
	_awaitCancelToggle = val
var _runLaterFramesQueue:Array[Callable] = []
var _runLaterFramesTimers:Array[int] = []
func runLaterFrames(frames:int, f:Callable):
	_runLaterFramesQueue.push_back(f)
	_runLaterFramesTimers.push_back(frames)
var _debounceQueue:Array[Callable] = []
var _debounceTimers:Array[float] = []
func debounce(ms:float, immediate:bool, f:Callable):
	if _debounceQueue.has(f):
		_debounceTimers[_debounceQueue.find(f)] = ms/1000.0
	else:
		_debounceQueue.push_back(f)
		_debounceTimers.push_back(ms/1000.0)
		if immediate:
			f.call()
func _process(delta: float) -> void:
	for i in range(_runLaterFramesTimers.size()-1, -1, -1):
		_runLaterFramesTimers[i] -= 1
		if _runLaterFramesTimers[i] <= 0:
			_runLaterFramesQueue[i].call()
			_runLaterFramesTimers.remove_at(i)
			_runLaterFramesQueue.remove_at(i)
	for i in range(_debounceTimers.size()-1, -1, -1):
		_debounceTimers[i] -= 1.0 * delta
		if _debounceTimers[i] <= 0:
			_debounceQueue[i].call()
			_debounceTimers.remove_at(i)
			_debounceQueue.remove_at(i)
func color(c:float = 1.0, a:float = 1.0) -> Color:
	return Color(c,c,c,a)
func vec2(c:float = 1.0) -> Vector2:
	return Vector2(c,c)
func vec3(c:float = 1.0) -> Vector3:
	return Vector3(c,c,c)
func colorFromVec(vec) -> Color:
	if vec is Vector3:
		return Color(vec.x, vec.y, vec.z)
	elif vec is Vector4:
		return Color(vec.x, vec.y, vec.z, vec.w)
	else:
		return Color.BLACK
	return Color()
func vec3FromColorRGB(col:Color) -> Vector3:
	return Vector3(col.r, col.g, col.b)
func vec3FromColorHSV(col:Color) -> Vector3:
	return Vector3(col.h, col.s, col.v)
func maxAbs(a, b):
	return a if abs(a) >= abs(b) else b
func minAbs(a, b):
	return a if abs(a) <= abs(b) else b
func maxDir(a, b, dir):
	if dir == 0:
		return maxAbs(a,b)
	return max(a*dir, b*dir)/dir
func minDir(a, b, dir):
	if dir == 0:
		return minAbs(a,b)
	return min(a*dir, b*dir)/dir
func minv(curvec,newvec) -> Vector2:
	return Vector2(min(curvec.x,newvec.x),min(curvec.y,newvec.y))
func maxv(curvec,newvec) -> Vector2:
	return Vector2(max(curvec.x,newvec.x),max(curvec.y,newvec.y))
func maxvDir(curvec:Vector2, newvec:Vector2, dir:Vector2) -> Vector2:
	return Vector2(maxDir(curvec.x,newvec.x,dir.x),maxDir(curvec.y,newvec.y,dir.y))
func minvDir(curvec:Vector2, newvec:Vector2, dir:Vector2) -> Vector2:
	return Vector2(minDir(curvec.x,newvec.x,dir.x),minDir(curvec.y,newvec.y,dir.y))
func minvc(vec:Vector2) -> float:
	return min(vec.x,vec.y)
func maxvc(vec:Vector2) -> float:
	return max(vec.x,vec.y)
func clampVec(vec:Vector2, a:Vector2, b:Vector2) -> Vector2:
	return Vector2(clamp(vec.x, a.x, b.x), clamp(vec.y, a.y, b.y))
func absProject(a:Vector2, b:Vector2) -> Vector2:
	var bn = b.normalized()
	return abs(a.dot(bn)) * bn
func maxProject(a:Vector2, b:Vector2) -> Vector2:
	var bn = b.normalized()
	return max(0.0, a.dot(bn)) * bn
func angleDiff(x, y):
	return posmod((x - y) + TAU/2.0, TAU) - TAU/2.0
func rectRim(rect:Rect2, angle:float, cornerSharpness:float = 0.0) -> Vector2:
	var p := Vector2.ZERO
	if cornerSharpness <= 0.0:
		var dist = min((rect.size.x*0.5)/abs(cos(angle)), (rect.size.y*0.5)/abs(sin(angle)))
		p = rect.get_center() + dist*Vector2.from_angle(angle)
	else:
		var dist = 1.0 / pow(pow(abs(cos(angle))/(rect.size.x*0.5), cornerSharpness) + pow(abs(sin(angle))/(rect.size.y*0.5), cornerSharpness), 1.0/cornerSharpness)
		p = rect.get_center() + dist*Vector2.from_angle(angle)
	return p
func rectRimDist(rect:Rect2, angle:float, cornerSharpness:float = 0.0) -> float:
	if cornerSharpness <= 0.0:
		return min((rect.size.x*0.5)/abs(cos(angle)), (rect.size.y*0.5)/abs(sin(angle)))
	else:
		return 1.0 / pow(pow(abs(cos(angle))/(rect.size.x*0.5), cornerSharpness) + pow(abs(sin(angle))/(rect.size.y*0.5), cornerSharpness), 1.0/cornerSharpness)
	return 0.0
func reflectInside(vec:Vector2, rect:Rect2) -> Vector2:
	if vec.x < rect.position.x:
		vec.x = 2.0*vec.x - rect.position.x
	if vec.x > rect.end.x:
		vec.x = 2.0*rect.end.x - vec.x
	if vec.y < rect.position.y:
		vec.y = 2.0*vec.y - rect.position.y
	if vec.y > rect.end.y:
		vec.y = 2.0*rect.end.y - vec.y
	return vec
func randRectPoint(rect:Rect2) -> Vector2:
	return Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y))
func rectToPoly(rect:Rect2) -> PackedVector2Array:
	var a:PackedVector2Array = [
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	]
	return a
func rectResizeCenter(rect:Rect2, size:Vector2) -> Rect2:
	rect.position += rect.size/2.0
	rect.size = size
	rect.position -= rect.size/2.0
	return rect
func rectClamp(rect:Rect2, clampRect:Rect2) -> Rect2:
	var newRect = Rect2()
	newRect.position = clampVec(rect.position, clampRect.position, clampRect.end - minv(clampRect.size, rect.size))
	newRect.size = minv(clampRect.size, rect.size)
	if rect.size.x > clampRect.size.x:
		newRect.position.x = clampRect.get_center().x - rect.size.x/2.0
	if rect.size.y > clampRect.size.y:
		newRect.position.y = clampRect.get_center().y - rect.size.y/2.0
	return newRect
func rectLerp(a:Rect2, b:Rect2, t:float):
	return Rect2(a.position.lerp(b.position, t), a.size.lerp(b.size, t))
func polygonBoundingBox(polygon:PackedVector2Array):
	var min_vec = Vector2.INF
	var max_vec = -Vector2.INF
	for v in polygon:
		min_vec = minv(min_vec,v)
		max_vec = maxv(max_vec,v)
	return Rect2(min_vec,max_vec-min_vec)
func clipLine(points:Array, start:float, end:float, absolute := true) -> Array[Vector2]:
	if points.size() < 2:
		return points
	var totalLength := 0.0
	var distances:Array[float] = []
	for i in points.size()-1:
		var d = points[i].distance_to(points[i+1])
		distances.push_back(d)
		totalLength += d
	if not absolute:
		start = start*totalLength
		end = end*totalLength
	start = clamp(start, 0.0, totalLength)
	end = clamp(end, start, totalLength)
	var newPoints:Array[Vector2] = []
	var curLength := 0.0
	for i in points.size()-1:
		var nextLength = curLength + distances[i]
		if curLength <= start and nextLength > start:
			newPoints.push_back(points[i].lerp(points[i+1], remap(start, curLength, nextLength, 0, 1)))
		if curLength <= end and nextLength > end:
			newPoints.push_back(points[i].lerp(points[i+1], remap(end, curLength, nextLength, 0, 1)))
			break
		else:
			newPoints.push_back(points[i+1])
			curLength = nextLength
	return newPoints
func closestPoint(pos:Vector2, points:Array) -> Vector2:
	var dist = INF
	var point:Vector2
	for p in points:
		var d = (p - pos).length_squared()
		if d < dist:
			dist = d
			point = p
	return point
func perf(printText:String, f:Callable):
	var start = Time.get_ticks_usec()
	f.call()
	var end = Time.get_ticks_usec()
	print(printText, " ", (end-start)/1000.0, "ms")
var _perfTasks := {}
func perfStart(name:String = ""):
	_perfTasks[name] = Time.get_ticks_usec()
func perfContinue(printText:String = "", name:String = ""):
	if not _perfTasks.has(name):
		return
	print(printText, " ", (Time.get_ticks_usec()-_perfTasks[name])/1000.0, "ms")
	_perfTasks[name] = Time.get_ticks_usec()
func perfEnd(printText:String = "", name:String = ""):
	if not _perfTasks.has(name):
		return
	print(printText, " ", (Time.get_ticks_usec()-_perfTasks[name])/1000.0, "ms")
	_perfTasks.erase(name)
func hms(totalSeconds := 0.0, decimalPlaces := 0, leadingZero := false):
	var decimals = fposmod(totalSeconds, 1.0)
	var timeSign = "" if totalSeconds >= 0.0 else "-"
	var totalSecondsI := int(totalSeconds)
	var seconds := totalSecondsI%60
	var minutes := (totalSecondsI/60)%60
	var hours := (totalSecondsI/60)/60
	var base = ""
	var values = [hours, minutes, seconds]
	if leadingZero:
		base = "%02d:%02d:%02d"
	else:
		base = "%d:%02d:%02d"
	if decimalPlaces > 0:
		base += ".%0"+str(decimalPlaces)+"d"
		values += [decimals * pow(10, decimalPlaces)]
	return timeSign + (base % values)
func weightedRandom(items:Array):
	var weights := []
	for i in items.size():
		var item = items[i]
		if i == 0:
			weights.push_back(item.weight)
		else:
			weights.push_back(item.weight + weights.back())
	var rand = randf() * weights.back()
	var choice := 0
	for item in items:
		if weights[choice] > rand:
			break
		choice += 1
	return items[choice]
func addUnique(array:Array, item):
	if not array.has(item):
		array.push_back(item)
func find(array:Array, cb:Callable):
	for el in array:
		if cb.call(el):
			return el
	return null
func removeInvalid(array:Array):
	for i in range(array.size()-1,-1,-1):
		var v = array[i]
		if not v or not is_instance_valid(v):
			array.remove_at(i)
var _uidSource := "abcdefghijklmnopqrstuvwxyz"
func uid(length := 6):
	var id = ""
	for i in length:
		id += _uidSource[floor(randf() * _uidSource.length())]
	return id
     extends Node
var _defaults := {}
var debugVal:Dictionary = {}
var debugEnabled := false
var debugInvuln := false
var main:Node2D
var player:Node2D
var players:Array[Node2D] = []
var ui:Control
var gameArea:Node2D
var groundArea:Node2D
var window:Window
var windowRect:Rect2
var windowRectRel:Rect2
var windowVelocity:Vector2
var windowMinSize:Vector2
var escapeBG:Node2D
var button2:Node2D
var title:Control
var inTitle := true
var timedModeLimit := 60.0*20.0
var timedModeEnding := false
var timedModeDone := false
var bastionChallengeFailed := false
var multiCursor := false
var fakeWindows := false
var timescale := 1.0
var playerTimescale := 1.0
var windowTimescale := 1.0
var paused := false
var resuming := false
var ultraWin := false
var attemptCounter := 0
var attemptStarted := false
var moveTime := 1.0
var hitTimer := 0.0
var frameTime := 0
var lastStand := false
var gameTime := 0.0
var speedrunTime := 0.0
var difficultyScale := 0.0
var spawnCount := 0
var bossCount := 0
var shop:Window
var coins := 0
var tokens := 0
var shopRestockPrice := 10
var shopRestockCount := 0
var shopChoosePrice := 1
var speed := 0
var fireRate := 0
var multiShot := 0
var multiShotExtra := 0
var homing := 0
var wealth := 0
var wallPunch := 0
var heals := 0
var maxHealthUps := 0
var freezing := 0
var piercing := 0
var splashDamage := 0
var echo := 0
var nextEcho := -1
var multiply := 0
var multiplyStack := 0
var refresh := 0
var refreshStack := 0
var absorb := 0
var absorbTimer := 0.0
var obliterate := 0
var obliterateTimer := 0.0
var bubble := 0
var bubbleTimer := 0.0
var manifestCounts := {
	speed = 0,
	fireRate = 0,
	multiShot = 0,
	homing = 0,
	wealth = 0,
	wallPunch = 0,
	heals = 0,
	maxHealthUps = 0,
	freezing = 0,
	piercing = 0,
	splashDamage = 0,
}
var peer := 0
var drain := 0
var bellow := 0
var halt := 0
var torrent := 0
var endure := 0
var deflect := 0
var detach := 0
var crumb := 0
var bellowReal := 0
var haltReal := 0
var torrentReal := 0
var endureReal := 0
var deflectReal := 0
var detachReal := 0
var crumbReal := 0
var bellowReset := -1
var haltReset := -1
var torrentReset := -1
var endureReset := -1
var deflectReset := -1
var detachReset := -1
var crumbReset := -1
var drainTickRate := 1.0
var torrentActive := false
var torrentTimer := 0.0
var detachActive := false
var detachTimer := 0.0
var haltActive := false
var haltTimer := 0.0
var upgradesBought := 0
var curAbility:Players.Ability = 0
var abilityTimer := 0.0
var abilityCooldown := 0.0
var abilityCount := 0
var usableAbilityCount := 0
var abilityTooltip := 0
var maxHealth := 10
var baseHealth := 10
var health := 1
var dead := false
var peerSet := false
var peerTarget := Vector2.ZERO
var drainSet := false
var drainTarget := Vector2.ZERO
var ultraUpgrade := false
var escaped := false
var escapedTimer := 0.0
var escapedLeft := false
var ultraBossStarted := false
var infiniteEnd := false
var drainOffset := Vector2.ZERO
var openedShop := false
var openedPerks := false
var usedAbility := false
var virusBossesKilled := 0
var snakeBossesKilled := 0
var ultraBossWon := false
var optionChoices := {
	fakeWindowTheme = {
		"window_win11" = "windows 11", 
		"window_win10" = "windows 10", 
		"window_win8" = "windows 8", 
		"window_win7" = "windows 7", 
		"window_winxp" = "windows xp",
		"window_win98" = "windows 98",
		"window_ubuntu" = "ubuntu",
		"window_torc" = "torc",
		"window_cute" = "cute",
		"window_vaporwave" = "vaporwave",
	},
	background = {
		"0" = "void",
		"1" = "transparent",
		"2" = "grid",
		"3" = "cells",
		"4" = "stars",
		"5" = "soup",
		"6" = "ripple",
	},
	customCursor = {
		"none" = "[disabled]",
		"simple" = "simple",
		"ring" = "ring",
		"ring-color" = "ring-color",
		"frame" = "frame",
		"frame-color" = "frame-color",
		"crosshair" = "crosshair",
		"crosshair-color" = "crosshair-color",
		"flamesword" = "flame sword",
	},
	musicTrack = {
		"jungle" = "windowkiller",
		"chill" = "windowchill",
		"break" = "windowbreaker",
	},
	startingMonitor = {
		"-1" = "auto"
	},
	language = {
		"en" = "english",
		"ar" = "arabic",
		"bg" = "bulgarian",
		"cs" = "czech",
		"de" = "german",
		"es" = "spanish",
		"es_MX" = "mexican spanish",
		"fr" = "french",
		
		"it" = "italian",
		"ja" = "japanese",
		"ko" = "korean",
		"nl" = "dutch",
		"pl" = "polish",
		"pt" = "portuguese",
		"pt_BR" = "brazilian portuguese",
		"ru" = "russian",
		"zh_CN" = "simplified chinese",
		"zh_TW" = "traditional chinese",
		
	},
}
var options := {
	soundVolume = 0.75,
	musicVolume = 0.6,
	musicEffects = true,
	dangerSound = true,
	uiAudio = true,
	showTimer = false,
	showSpeedrunTimer = false,
	playerVisibility = true,
	bulletVisibility = false,
	bgEffects = true,
	shootToggle = false,
	controllerDisconnectPause = true,
	unfocusPause = false,
	alwaysOnTop = true,
	autoReveal = true,
	aidAlwaysOnTop = true,
	faceAlwaysOnTop = true,
	animateWindows = false,
	clampWindow = true,
	backingWindow = false,
	backingWindowTransparency = 0.0,
	backingWindowColor = 0.0,
	windowTitles = true,
	closeConfirm = true,
	hideHUD = false,
	disableTimedCutscene = false,
	showFace = true,
	ultraBgEffects = true,
	preventFullChargeOrb = false,
	transparencyFix = false,
	transparencyFixShrink = false,
	slowFix = false,
	limitWindowUpdates = false,
	screenBufferSize = 0,
	vsync = false,
	limitFps = false,
	maxFps = 120,
	
	multiMouse = false,
	fakeWindows = false,
	fakeWindowTheme = "window_win11",
	focusedInput = false,
	gameScale = 1.0,
	
	background = "0",
	customCursor = "none",
	musicTrack = "jungle",
	startingMonitor = "-1",
	language = "en",
	
	pCoins = true,
	pCoinsVisible = true,
	pSplash = true,
	pBullet = true,
	pBulletPop = true,
	pEnemyPop = true,
	pPiercingTriggers = true,
	pHoming = true,
	pSlimeTarget = true,
	pSlimeTrail = true,
	pEnemyBullet = true,
	pBoss = true,
	pEnemy = true,
}
var save := {
	specialFace = false,
	escaped = false,
	seenSmiley = false,
	seenTimedSmiley = false,
	startedTimedMode = false,
	beatTimedMode = false,
	obliteratedStar = false,
	toggleDisabled = false,
	
	usedBellow = false,
	usedHalt = false,
	usedTorrent = false,
	usedEndure = false,
	usedDeflect = false,
	usedDetach = false,
	usedCrumb = false,
}
func _resetDefaults():
	for g in _defaults:
		if _defaults[g] is Dictionary or _defaults[g] is Array:
			set(g, _defaults[g].duplicate())
		else:
			set(g, _defaults[g])
	if Meta.forceFakeWindows:
		Global.options.fakeWindows = true
	if Meta.focusedInput:
		Global.options.focusedInput = true
	Game.updateMonitorList()
	Game.updateLanguageList()
func _ready():
	print("fuck shit please don't")
	if _defaults.is_empty():
		var gpl = Global.get_script().get_script_property_list()
		for g in gpl:
			if g.name != "_defaults":
				var val = get(g.name)
				if val is Dictionary or val is Array:
					_defaults[g.name] = val.duplicate()
				else:
					_defaults[g.name] = val
  extends Node
func pinch(v):
	if(v < 0.5):
		return -v*v
	else:
		return v*v
func run(x:float, a:float = 0.0, b:float = 0.5, c:float = 0.0) -> float:
	c = pinch(c)
	x = max(0, min(1, x))
	var eps = 0.00001
	var s = exp(a)
	var s2 = 1.0/(s+eps)
	var t = max(0, min(1, b))
	var u = c
	var res = 0
	var c1 = 0
	var c2 = 0
	var c3 = 0
	if(x < t):
		c1 = (t*x)/(x+s*(t-x)+eps)
		c2 = t-pow(1/(t+eps), s2-1)*pow(abs(x-t), s2)
		c3 = pow(1/(t+eps), s-1)*pow(x,s)
	else:
		c1 = (1-t)*(x-1)/(1-x-s*(t-x)+eps)+1
		c2 = pow(1/((1-t)+eps), s2-1)*pow(abs(x-t), s2)+t
		c3 = 1-pow(1/((1-t)+eps), s-1)*pow(1-x,s)
	if(u <= 0):
		res = (-u) * c2 + (1 + u) * c1
	else:
		res = (u) * c3 + (1 - u) * c1
	return res
func smoothCorner(x:float, m:float = 1.0, l:float = 1.0, s:float = 1.0) -> float:
	var s1 = pow(s/10.0, 2.0)
	return 0.5 * ((l*x + m*(1.0 + s1)) - sqrt(pow(abs(l*x - m*(1.0 - s1)), 2.0) + 4.0*m*m*s1))
 extends Node
var playerPool:Array[AudioStreamPlayer] = []
var playerIDs:Array[int] = []
var streamTimers:Dictionary = {}
var volumes := {
	"sfx" = 0.8,
	"ui" = 0.8,
	"music" = 0.7
}
var musicID = -1
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	setup()
func _process(delta):
	for s in streamTimers.keys():
		streamTimers[s] -= 40.0 * delta
func setup():
	playerPool = []
	for i in 32:
		var p = AudioStreamPlayer.new()
		add_child(p)
		playerPool.push_back(p)
		playerIDs.push_back(-1)
func setVolume(bus:String = "sfx", volume := 1.0):
	volume = pow(volume, 2.0)
	if bus == "music":
		volume *= 0.5
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(volume))
	if bus == "sfx":
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ui"), linear_to_db(volume))
func play(stream:AudioStream, pitchLower := 1.0, pitchUpper := 1.0, bus := "sfx", vol := 1.0) -> int:
	if streamTimers.get(stream, 0.0) > 0.0 and bus != "music":
		return -1
	if Global.options.soundVolume <= 0.001 and bus != "music":
		return -1
	for i in playerPool.size():
		var p = playerPool[i]
		if p.playing and not p.stream_paused:
			continue
		streamTimers[stream] = 1.0
		p.stream = stream
		if bus == "music":
			p.pitch_scale = 1.0
		else:
			p.pitch_scale = max(0.1,randf_range(pitchLower, pitchUpper) * Global.timescale)
		p.volume_db = linear_to_db(vol)
		p.bus = bus
		p.play()
		var id = randi()
		playerIDs[i] = id
		if bus == "music":
			musicID = id
			curMusic = stream
		return id
	return -1
func playRandom(streams:Array[AudioStream], pitchLower := 1.0, pitchUpper := 1.0, bus := "sfx", vol := 1.0):
	play(streams.pick_random(), pitchLower, pitchUpper, bus, vol)
func stop(id:int):
	var idx = playerIDs.find(id)
	if idx >= 0 and idx < playerPool.size():
		playerPool[idx].stop()
func stopMusic():
	var idx = playerIDs.find(musicID)
	if idx >= 0 and idx < playerPool.size():
		playerPool[idx].stop()
func stopBus(bus := "sfx"):
	for i in playerPool.size():
		var p = playerPool[i]
		if p.bus == bus:
			p.stop()
func seek(id:int, time:float):
	var idx = playerIDs.find(id)
	if idx >= 0 and idx < playerPool.size():
		playerPool[idx].seek(time)
func pitch(id:int, p:float):
	var idx = playerIDs.find(id)
	if idx >= 0 and idx < playerPool.size():
		playerPool[idx].pitch_scale = max(0.1,p * Global.timescale)
func volume(id:int, v:float):
	var idx = playerIDs.find(id)
	if idx >= 0 and idx < playerPool.size():
		playerPool[idx].volume_db = linear_to_db(v)
func pauseLoops(paused := true):
	for i in playerPool.size():
		if i == playerIDs.find(musicID):
			continue
		if playerPool[i].stream:
			if playerPool[i].stream.loop or playerPool[i].stream.get_length() > 2.0:
				playerPool[i].stream_paused = paused
var curMusic:AudioStream
func changeMusic(track := "jungle", force := false):
	var stream:AudioStream
	var vol := 1.0
	if track == "chill":
		stream = preload("res://src/sounds/musicChill.ogg")
	elif track == "break":
		stream = preload("res://src/sounds/musicBreak.ogg")
		vol = 1.1
	else:
		stream = preload("res://src/sounds/musicJungle.ogg")
	if not force and curMusic == stream:
		return -1
	curMusic = stream
	stop(musicID)
	return Audio.play(stream, 1, 1, "music", vol)
func updateEffect(bus := "music", effect := "lowpass", value = true):
	if effect == "lowpass":
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(bus), 0, value)
	elif effect == "pitch":
		if musicID >= 0 and playerIDs.find(musicID) >= 0:
			playerPool[playerIDs.find(musicID)].pitch_scale = value
func resetEffects():
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("music"), 0, false)
	if musicID >= 0 and playerIDs.find(musicID) >= 0:
		playerPool[playerIDs.find(musicID)].pitch_scale = 1.0
extends Node
var pressed := {}
func _ready():
	for a in InputMap.get_actions():
		pressed[a] = 0.0
func _input(event):
	if event is InputEventKey:
		for a in InputMap.get_actions():
			if InputMap.action_has_event(a, event):
				pressed[a] = 1.0 if event.pressed else 0.0
func releaseEvents():
	for a in InputMap.get_actions():
		Input.action_release(a)
func convertMouseButton(b:int) -> int:
	if b == MOUSE_BUTTON_LEFT: return 0
	if b == MOUSE_BUTTON_MIDDLE: return 1
	if b == MOUSE_BUTTON_RIGHT: return 2
	return -1
func is_action_pressed(action:String, deviceIndex := -1):
	if Meta.focusedInput or Global.options.focusedInput:
		return Input.is_action_pressed(action) or (InputMap.has_action("ct_"+action) and Input.is_action_pressed("ct_"+action))
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			if deviceIndex < 0:
				if DisplayServer.get_key_state(e.physical_keycode):
					return true
			else:
				if DisplayServer.multi_keyboard_get_state(deviceIndex, e.physical_keycode):
					return true
		elif e is InputEventMouseButton:
			var idx = 0
			idx = convertMouseButton(e.button_index)
			if deviceIndex < 0:
				if DisplayServer.get_mouse_state(idx):
					return true
			else:
				if DisplayServer.multi_cursor_get_state(deviceIndex, idx):
					return true
		elif e is InputEventJoypadButton:
			if deviceIndex < 0:
				if (Input.is_action_pressed("ct_"+action) if InputMap.has_action("ct_"+action) else Input.is_action_pressed(action)):
					return true
			else:
				if Input.is_joy_button_pressed(deviceIndex, e.button_index):
					return true
		elif e is InputEventJoypadMotion:
			if deviceIndex < 0:
				if (Input.is_action_pressed("ct_"+action) if InputMap.has_action("ct_"+action) else Input.is_action_pressed(action)):
					return true
			else:
				if abs(Input.get_joy_axis(deviceIndex, e.axis)) > 0.1:
					return true
	return false
func transfer():
	for a in pressed:
		if pressed[a] > 0:
			Input.action_press(a, pressed[a])
		else:
			Input.action_release(a)
		pressed[a] = 0.0
func apply():
	for a in pressed:
		for e in InputMap.action_get_events(a):
			if e is InputEventKey:
				if Input.is_key_pressed(e.physical_keycode):
					Input.action_press(a, 1.0)
				else:
					Input.action_release(a)
func clear():
	for a in pressed:
		Input.action_release(a)
		pressed[a] = 0.0
            extends Nraode
signal bellow(player:Node2D)
var frameLimiter := 0
var world_2d:World2D
var screenIndex := -1
var screenRect:Rect2
var screenRectDeco:Rect2
var realScreenRect:Rect2
var screenRectSafe:Rect2
var mainScreenRect:Rect2
var screenBounds:Rect2
var mainWindow:Window
var fakeWindowTransitioning := false
var inFocus := true
var steamOverlayActive := false
var rtl := false
var languageTextSmall := false
var backingWindow:Window
var backingWindowAlpha := 0.0
var backingWindowColorGradient:Gradient
var backingWindowColorVal := 0.0
var backing_display:Control
var baseTransform:Transform2D
var _fakeWindows := false
var updateTimer := 0.0
var titleTimer := 999.0
var init := true
func _on_overlay_toggled(active: bool, user_initiated: bool, app_id: int):
	steamOverlayActive = active
	if Global.main:
		Global.main.updatePause()
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	mainWindow = get_window()
	world_2d = mainWindow.world_2d
	baseTransform = mainWindow.global_canvas_transform
	screenIndex = int(Global.options.startingMonitor)
	backingWindowColorGradient = preload("res://src/ui/backingWindowGradient.tres")
	backing_display = Utils.place(preload("res://src/ui/backing_display.tscn"), get_tree().root)
	updateScreenRect()
	updateMonitorList()
	updateLanguageList()
	updateLanguage()
	Utils.runLater(1, func():
		updateCursor()
		backingWindowColorVal = Global.options.backingWindowColor
		backingWindowAlpha = Global.options.backingWindowTransparency
		toggleBackingWindow()
		init = false
	)
	Events.bgUpdated.connect(updateWindowBGs)
	Steam.steamInit()
	Steam.overlay_toggled.connect(_on_overlay_toggled)
func updateDisplaySettings():
	Engine.max_fps = Global.options.maxFps if Global.options.limitFps else 0
	DisplayServer.window_set_vsync_mode(Global.options.vsync)
func updateMonitorList():
	var startingMonitor = {
		"-1" = "auto"
	}
	for id in DisplayServer.get_screen_count():
		startingMonitor[str(id)] = str(id)
	Global.optionChoices.startingMonitor = startingMonitor
	if not startingMonitor.has(Global.options.startingMonitor):
		Global.options.startingMonitor = "-1"
		screenIndex = int(Global.options.startingMonitor)
func updateLanguageList():
	var language = {
		"en" = "english"
	}
	var unsorted = {}
	for locale in TranslationServer.get_loaded_locales():
		if locale == "smile":
			continue
		var t = TranslationServer.get_translation_object(locale)
		unsorted[str(locale)] = str(t.get_message("{language}"))
	var sortedVals = unsorted.values()
	sortedVals.sort()
	for v in sortedVals:
		language[str(unsorted.find_key(v))] = v
	language["smile"] = ":)"
	Global.optionChoices.language = language
var smallLanguages = [
	"pl",
	"ru"
]
func updateLanguage(force := false):
	if force:
		TranslationServer.set_locale("en-US")
	TranslationServer.set_locale(Global.options.language)
	rtl = Global.options.language == "ar"
	languageTextSmall = smallLanguages.has(Global.options.language)
	Events.languageChanged.emit()
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			inFocus = true
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			inFocus = false
			if Global.options.focusedInput:
				RawInput.releaseEvents()
var steamTimer := 0.0
func _process(delta):
	Steam.run_callbacks()
	updateTimer += 1.0 * delta
	if updateTimer > 1.0:
		updateTimer = 0.0
		if _fakeWindows:
			setWindowRect(mainWindow, realScreenRect)
		if not Global.inTitle:
			if not Global.paused:
				if Global.options.faceAlwaysOnTop:
					for win in get_tree().get_nodes_in_group("face_window"):
						Game.moveWindowToForeground(win)
			if Global.ultraWin:
				Global.main.reorderWindows()
			coinBufferLimit = clamp((Global.gameTime - 60*16)/60.0, 0, 50)
		for win in topmostWindows:
			if win:
				Game.moveWindowToForeground(win)
	if Global.peer >= 3.0:
		titleTimer += 1.0 * delta
		if titleTimer > 0.05:
			titleTimer = 0.0
			updateWindowTitles()
	if Global.paused:
		for win in windows:
			if win:
				if win.has_meta("pos"):
					win.position = win.get_meta("pos", win.position)
	updateCursorAnim(delta)
var coinDenoms = [
	1,
	3,
	5,
	10,
	25,
	50,
	100,
	500,
	1000,
	5000
]
var coinBuffer := 0
var coinBufferLimit := 0
var coinSplitLimit := 50
func spawnCoins(count:float, pos:Vector2, raw := false, split := 1.0, args := {}):
	if not Global.options.pCoins:
		return
	if not raw:
		count += round(Global.wealth / 3.0 + 0.8 * randf() * Global.wealth)
		count += round(12 * pow(max(0,Global.gameTime-100.0), 0.5) / 160.0)
		count *= 1.0 + 0.5*pow(Global.wealth, 0.6)
		if Global.gameTime > 30.0:
			count += floor(pow(randf(), 2.0) * 3.2)
	count += coinBuffer
	if count < coinBufferLimit:
		coinBuffer = count
		return
	coinBuffer = 0
	if ((split == 1.0 and count < coinSplitLimit) or split > 1.0):
		var buffer = 1.0 * split
		var coins = []
		var total = count
		var remainder = 0
		while total > coinDenoms[1]:
			for i in range(coinDenoms.size()-1, -1, -1):
				if total >= coinDenoms[i] * buffer:
					total -= coinDenoms[i]
					coins.push_back(coinDenoms[i])
					break
		for i in total:
			coins.push_back(1)
		for c in coins:
			var a = {value = c}
			a.merge(args)
			Utils.spawn(preload("res://src/element/coin/coin.tscn"), pos, Global.main.coin_area, a)
	else:
		var a = {value = count}
		a.merge(args)
		Utils.spawn(preload("res://src/element/coin/coin.tscn"), pos, Global.main.coin_area, a)
var bulletPopCount := 0
func checkBulletPop() -> bool:
	if bulletPopCount < 10:
		bulletPopCount += 1
		return true
	return false
var bulletSplashIdx := 0
func checkBulletSplash() -> bool:
	bulletSplashIdx += 1
	if bulletSplashIdx > max(0, Global.multiShot-5.0):
		bulletSplashIdx = 0
		return true
	return false
var windows:Array[Window] = []
var topmostWindows:Array[Window] = []
func registerWindow(win:Window, title := "", setWorld := true, focus := true, keepTopmost := false):
	if windows.has(win):
		return
	win.add_to_group("window")
	windows.push_back(win)
	win.theme_type_variation = Global.options.fakeWindowTheme
	if title == "":
		title = win.title
	if Global.options.windowTitles:
		win.title = title
	win.set_meta("title", title)
	win.always_on_top = Global.options.alwaysOnTop
	if win.transparent:
		win.set_meta("transparent", true)
	elif not win.get_meta("transparent", false):
		if not Global.inTitle:
			win.transparent = int(Global.options.background) == 1
			win.transparent_bg = int(Global.options.background) == 1
	if setWorld:
		win.world_2d = world_2d
	if focus:
		Focus.registerViewport(win)
	if keepTopmost:
		topmostWindows.push_back(win)
func updateWindows():
	verifyWindows()
	var setTitle = Global.options.windowTitles
	for win in windows:
		if win:
			win.title = win.get_meta("title", "") if setTitle else ""
			win.theme_type_variation = Global.options.fakeWindowTheme
func updateWindowTitles():
	var setTitle = Global.options.windowTitles
	for win in windows:
		if win:
			var newTitle = ""
			if setTitle:
				if win.has_meta("health") and Global.peer >= 3:
					newTitle = ("[" + str(ceil(win.get_meta("health") * 100)) + "%] " + tr(win.get_meta("title", "")))
				else:
					newTitle = win.get_meta("title", "")
			if win.title != newTitle:
				win.title = newTitle
func updateWindowBGs():
	if Global.inTitle:
		return
	var transparent = int(Global.options.background) == 1
	for win in windows:
		if win:
			if not win.get_meta("transparent", false):
				win.transparent = transparent
				win.transparent_bg = transparent
func setAlwaysOnTop(value:bool):
	for win in windows:
		if win:
			if win == backingWindow:
				backingWindow.always_on_top = false
				backingWindow.borderless = false
				backingWindow.always_on_top = value
				backingWindow.borderless = true
			else:
				win.always_on_top = value
	get_window().always_on_top = value
	Utils.runLater(10, func():
		if Global.main:
			Global.main.reorderWindows()
		elif Global.inTitle:
			Global.title.relayerWindows(null, true)
	)
func verifyWindows():
	for i in range(windows.size()-1, -1, -1):
		if not windows[i] or not is_instance_valid(windows[i]):
			windows.remove_at(i)
func updateStartingMonitor():
	if Global.main:
		return
	screenIndex = int(Global.options.startingMonitor)
	if screenIndex >= DisplayServer.get_screen_count():
		screenIndex = -1
	var newScreenRect = DisplayServer.screen_get_usable_rect(screenIndex)
	if mainScreenRect:
		var diff = Vector2(newScreenRect.position) - Vector2(mainScreenRect.position)
		for win in windows:
			if win:
				win.position += Vector2i(diff)
	mainScreenRect = newScreenRect
	updateScreenRect()
func updateScreenRectDebounce():
	updateScreenRect()
func updateScreenRect(forceUpdate := false):
	var origPositions = {}
	for win in windows:
		if win:
			origPositions[win] = win.position
	if screenIndex < 0:
		screenIndex = DisplayServer.get_screen_from_rect(mainWindow.rect)
	if not mainScreenRect:
		mainScreenRect = DisplayServer.screen_get_usable_rect(screenIndex)
	var prevRect = screenRect
	screenRect = Rect2(mainScreenRect)
	if not Global.options.clampWindow:
		var fullRect = Rect2()
		for s in DisplayServer.get_screen_count():
			if s == 0:
				fullRect = DisplayServer.screen_get_usable_rect(s)
			else:
				fullRect = fullRect.merge(DisplayServer.screen_get_usable_rect(s))
		screenRect = fullRect
	if Global.options.transparencyFixShrink:
		screenRect = screenRect.grow(-2)
	realScreenRect = screenRect
	var scale = Global.options.gameScale
	if _fakeWindows:
		var t = mainWindow.global_canvas_transform
		t.x = Vector2(scale, 0)
		t.y = Vector2(0, scale)
		screenRect.size = realScreenRect.size / scale
		var newPos = realScreenRect.get_center() - screenRect.size/2.0
		screenRect.position = newPos
		t.origin = -screenRect.position*scale
		mainWindow.global_canvas_transform = t
	else:
		var t = mainWindow.global_canvas_transform
		t.x = Vector2(1.0, 0)
		t.y = Vector2(0, 1.0)
		t.origin = Vector2.ZERO
		mainWindow.global_canvas_transform = t
	var shrink = Global.options.screenBufferSize
	shrink = round(min(shrink, max(0, Utils.minvc(screenRect.size)-900))/2.0)
	screenRect = screenRect.grow(-shrink)
	screenRectSafe = screenRect
	screenRectSafe.position.y += 32
	screenRectSafe.size.y -= 32
	screenRectDeco = screenRect
	screenRectDeco.position.y += 30
	screenRectDeco.size.y -= 30
	if _fakeWindows:
		setWindowRect(mainWindow, realScreenRect)
	for win in windows:
		if win == mainWindow:
			continue
		if win and win.get_meta("static", false):
			continue
		if win:
			win.position = origPositions[win]
	if forceUpdate or screenRect != prevRect:
		Utils.runLater(201, func():
			for win in origPositions.keys():
				if win:
					win.position = origPositions[win]
			
			if _fakeWindows:
				setWindowRect(mainWindow, realScreenRect)
			
			for win in windows:
				if win == mainWindow:
					continue
				if win:
					win.rect = Utils.rectClamp(win.rect, screenRect)
			
			toggleBackingWindow()
		)
	screenBounds = screenRect.grow(100)
	Events.screenRectUpdated.emit()
func updateBackingWindow():
	if backingWindow:
		backingWindow.position = Game.realScreenRect.position
		backingWindow.size = Game.realScreenRect.size
	if Global.options.fakeWindows:
		backing_display.position = Game.realScreenRect.position
		backing_display.size = Game.realScreenRect.size
	else:
		backing_display.position = Vector2.ZERO
		backing_display.size = Game.realScreenRect.size
func toggleBackingWindow(value := true):
	value = Global.options.backingWindow or Players.multiMouse
	backing_display.visible = value
	if Global.options.fakeWindows:
		backing_display.position = Game.realScreenRect.position
		backing_display.size = Game.realScreenRect.size
		backing_display.reparent(Game.mainWindow, false)
	else:
		backing_display.position = Vector2.ZERO
		backing_display.size = Game.realScreenRect.size
		if not backingWindow:
			backingWindow = Window.new()
			backingWindow.borderless = true
			backingWindow.unresizable = true
			backingWindow.always_on_top = Global.options.alwaysOnTop
			backingWindow.unfocusable = true
			backingWindow.transparent = true
			backingWindow.transparent_bg = true
			registerWindow(backingWindow, "", false, false, false)
			backingWindow.set_meta("static", true)
			backingWindow.position = Game.realScreenRect.position
			backingWindow.size = Game.realScreenRect.size
			get_tree().root.add_child(backingWindow)
			backingWindow.focus_entered.connect(func():
				if Global.main:
					Game.moveWindowToForeground(Global.main.window)
					if Global.main.optionsOpen:
						Game.moveWindowToForeground(Global.main.optionsWindow)
			)
		backingWindow.visible = value
		backing_display.reparent(backingWindow, false)
	updateBackingWindow()
	updateBackingColor()
	Utils.runLater(10, func():
		if Global.main:
			if value:
				Global.main.reorderWindows()
		elif Global.inTitle:
			if value:
				Global.title.relayerWindows(null, true)
	)
func updateBackingColor():
	backing_display.backing_color.color = backingWindowColorGradient.sample(backingWindowColorVal)
	backing_display.backing_color.color.a = backingWindowAlpha
func updateFakeWindows():
	if Meta.forceFakeWindows:
		Global.options.fakeWindows = true
	if Players.multiMouse:
		Global.options.fakeWindows = true
	if Global.escaped and not Global.inTitle:
		Global.options.fakeWindows = _fakeWindows
		return
	_fakeWindows = Global.options.fakeWindows
	if Global.button2:
		_fakeWindows = false
	get_window().remove_meta("pos")
	Events.fakeWindowPreUpdate.emit()
	updateScreenRect(true)
	fakeWindowTransitioning = true
	var visibleWindows:Array[Window] = []
	verifyWindows()
	for win in windows:
		if win.visible:
			visibleWindows.push_back(win)
			if not win == mainWindow:
				win.visible = false
	Utils.runLater(10, func():
		for win in visibleWindows:
			if win and is_instance_valid(win):
				if not win == mainWindow:
					win.visible = true
		fakeWindowTransitioning = false
		
		if _fakeWindows:
			mainWindow.rect = screenRect
		
		Events.fakeWindowPostUpdate.emit()
	)
	if _fakeWindows:
		Events.fakeWindowUpdate.emit()
		mainWindow.gui_embed_subwindows = true
		mainWindow.borderless = true
		mainWindow.unresizable = true
		if Global.options.alwaysOnTop:
			mainWindow.always_on_top = true
		mainWindow.rect = realScreenRect
		mainWindow.transparent = true
		mainWindow.transparent_bg = true
		get_tree().set_auto_accept_quit(true)
		if not mainWindow.files_dropped.is_connected(on_files_dropped):
			mainWindow.files_dropped.connect(on_files_dropped)
	else:
		Events.fakeWindowUpdate.emit()
		mainWindow.gui_embed_subwindows = false
		mainWindow.borderless = false
		mainWindow.unresizable = true
		if Global.options.alwaysOnTop:
			mainWindow.always_on_top = true
		mainWindow.transparent = true
		mainWindow.transparent_bg = true
		get_tree().set_auto_accept_quit(false)
	winDecoPosOffset = Vector2.INF
	winDecoSizeOffset = Vector2.INF
	updateWindows()
	if _fakeWindows:
		Utils.runLater(100, func():
			setWindowRect(mainWindow, realScreenRect)
		)
func on_files_dropped(files):
	if _fakeWindows:
		Events.files_dropped.emit(files)
func setWindowSize(window:Window, size:Vector2, limited := false):
	if limited and frameLimiter != 0:
		return
	var dist := 1
	if abs(window.size.x - size.x) > dist or abs(window.size.y - size.y) > dist:
		window.size = size
func setWindowPosition(window:Window, pos:Vector2, limited := false, keepPos := false):
	if limited and frameLimiter != 0:
		return
	var dist := 1
	if abs(window.position.x - pos.x) > dist or abs(window.position.y - pos.y) > dist:
		window.position = pos
	if keepPos:
		window.set_meta("pos", window.position)
func setWindowRect(window, rect, limited := false, keepPos := false):
	if limited and frameLimiter != 0:
		return
	var dist := 1
	var setPos := false
	var setSize := false
	if abs(window.position.x - rect.position.x) > dist or abs(window.position.y - rect.position.y) > dist:
		setPos = true
	if abs(window.size.x - rect.size.x) > dist or abs(window.size.y - rect.size.y) > dist:
		setSize = true
	if setPos and setSize:
		window.rect = rect
	elif setPos:
		window.position = rect.position
	elif setSize:
		window.size = rect.size
	if keepPos:
		window.set_meta("pos", window.position)
func moveWindowToForeground(window:Window):
	window.move_to_foreground()
var winDecoPosOffset := Vector2.INF
var winDecoSizeOffset := Vector2.INF
func updateWindowDecoOffsets(window:Window):
	if true or _fakeWindows:
		winDecoPosOffset = Vector2(-4,-32)
		winDecoSizeOffset = Vector2(8, 32)
	else:
		winDecoPosOffset = window.get_position_with_decorations() - window.position
		winDecoSizeOffset = window.get_size_with_decorations() - window.size
		var rect = Rect2(winDecoPosOffset, winDecoSizeOffset).grow(-8.0)
		winDecoPosOffset = rect.position
		winDecoSizeOffset = rect.size
func getWindowFullRect(window:Window) -> Rect2:
	if winDecoPosOffset == Vector2.INF or winDecoSizeOffset == Vector2.INF:
		updateWindowDecoOffsets(window)
	var rect = Rect2(window.rect)
	rect.position += winDecoPosOffset
	rect.size += winDecoSizeOffset
	return rect
func setWindowFullRect(window:Window, rect:Rect2):
	if winDecoPosOffset == Vector2.INF or winDecoSizeOffset == Vector2.INF:
		updateWindowDecoOffsets(window)
	var baseRect = window.rect
	var newRect = Rect2(rect.position - winDecoPosOffset, rect.size - winDecoSizeOffset)
	setWindowRect(window, newRect)
func getWindowBar(pos:Vector2):
	for win in windows:
		if win:
			var rect = Rect2(Vector2(win.position) - Vector2(0, 30), Vector2(win.size.x, 30))
			if rect.has_point(pos):
				return win
	return null
func checkClosePosition(pos:Vector2, dist := 24.0) -> Window:
	for win in windows:
		if win:
			if win.borderless:
				continue
			var close = Vector2(win.rect.end.x, win.rect.position.y) + Vector2(-23, -16)
			if pos.distance_to(close) < dist:
				return win
	return null
var cursors = {
	"simple" = {
		texture = preload("res://src/ui/cursors/simple.png"),
		center = Vector2(3,3)
	},
	"ring" = {
		texture = preload("res://src/ui/cursors/ring.png"),
		center = Vector2(74,74)
	},
	"ring-color" = {
		texture = preload("res://src/ui/cursors/ring-color.png"),
		center = Vector2(74,74)
	},
	"frame" = {
		texture = preload("res://src/ui/cursors/frame.png"),
		center = Vector2(40,40)
	},
	"frame-color" = {
		texture = preload("res://src/ui/cursors/frame-color.png"),
		center = Vector2(40,40)
	},
	"crosshair" = {
		texture = preload("res://src/ui/cursors/crosshair.png"),
		center = Vector2(100,100)
	},
	"crosshair-color" = {
		texture = preload("res://src/ui/cursors/crosshair-color.png"),
		center = Vector2(100,100)
	},
	"flamesword" = {
		
		texture = preload("res://src/ui/cursors/flamesword/flamesword.tres"),
		textures = [
			preload("res://src/ui/cursors/flamesword/1.png"),
			preload("res://src/ui/cursors/flamesword/2.png"),
			preload("res://src/ui/cursors/flamesword/3.png"),
			preload("res://src/ui/cursors/flamesword/4.png"),
			],
		center = Vector2(22,38)
	},
}
func updateCursor():
	if Global.options.customCursor != "none":
		var cursor = cursors[Global.options.customCursor]
		DisplayServer.cursor_set_custom_image(cursor.texture, DisplayServer.CURSOR_ARROW, cursor.center)
	else:
		DisplayServer.cursor_set_custom_image(null, DisplayServer.CURSOR_ARROW)
var _cursorAnimFrame := 0
var _cursorAnimTimer := 0.0
var _cursorAnimDelay := 0.0
func updateCursorAnim(delta):
	if Input.get_current_cursor_shape() != Input.CURSOR_ARROW:
		_cursorAnimDelay = 0.0
		return
	else:
		_cursorAnimDelay += 1.0 * delta
	if Global.options.customCursor == "flamesword":
		_cursorAnimTimer += 1.0 * delta
		if _cursorAnimTimer > 0.1:
			_cursorAnimTimer = 0.0
			_cursorAnimFrame = posmod(_cursorAnimFrame+1, 4)
			var cursor = cursors[Global.options.customCursor]
			DisplayServer.cursor_set_custom_image(cursor.textures[_cursorAnimFrame], DisplayServer.CURSOR_ARROW, cursor.center)
func randomPlayer(ignoreDead := false):
	if ignoreDead:
		return Global.players.pick_random()
	else:
		var list = []
		for p in Global.players:
			if not p.dead:
				list.push_back(p)
		if list.size() == 0:
			return Global.players.pick_random()
		else:
			return list.pick_random()
func closestPlayer(pos:Vector2) -> Node2D:
	var dist = INF
	var player:Node2D
	for p in Global.players:
		var d = (p.position - pos).length_squared()
		if d < dist:
			dist = d
			player = p
	return player
func closestEnemy(pos:Vector2, maxDist := -1.0, ignore := []) -> Node2D:
	var dist = INF
	var enemy:Node2D
	for e in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(e):
			continue
		if ignore.has(e):
			continue
		if e.get_meta("killed", false):
			continue
		var d = (e.position - pos).length_squared()
		if d < dist:
			dist = d
			enemy = e
	if maxDist <= 0.0 or dist < maxDist*maxDist:
		return enemy
	else:
		return null
	return null
func randomSpawnLocation(radius:float, minDist:float = 0.0) -> Vector2:
	var pos = Vector2(randf_range(screenRect.position.x + radius, screenRect.end.x - radius), randf_range(screenRect.position.y + radius, screenRect.end.y - radius))
	if screenRect.size.x < radius*2:
		pos.x = screenRect.get_center().x
	if screenRect.size.y < radius*2:
		pos.y = screenRect.get_center().y
	if minDist > 0.0:
		var _i := 0
		while (pos - closestPlayer(pos).global_position).length() < minDist and _i < 100:
			var x = randf_range(screenRect.position.x + radius, screenRect.end.x - radius)
			var y = randf_range(screenRect.position.y + radius, screenRect.end.y - radius)
			if screenRect.size.x < radius*2:
				x = screenRect.get_center().x
			if screenRect.size.y < radius*2:
				y = screenRect.get_center().y
			pos = Vector2(x, y)
			_i += 1
	return pos
func randomAvoidLocation(radius:float, minDist:float = 0.0, avoidPoints = []) -> Vector2:
	var pos = Vector2(randf_range(screenRect.position.x + radius, screenRect.end.x - radius), randf_range(screenRect.position.y + radius, screenRect.end.y - radius))
	if minDist > 0.0:
		var _i := 0
		while (pos - Utils.closestPoint(pos, avoidPoints)).length() < minDist and _i < 100:
			pos = Vector2(randf_range(screenRect.position.x + radius, screenRect.end.x - radius), randf_range(screenRect.position.y + radius, screenRect.end.y - radius))
			_i += 1
	return pos
func heal(amount := 1):
	for p in Global.players:
		if p.dead:
			amount -= 1
			p.revive()
		if amount <= 0:
			break
	var allAlive := true
	for p in Global.players:
		if p.dead:
			allAlive = false
	if amount == 0 and allAlive:
		Global.health = 1
		Global.lastStand = false
	elif amount > 0:
		Global.health = min(Global.health + amount, Global.maxHealth)
		Global.lastStand = false
	Events.lastStandUpdated.emit()
func saveData():
	var file = FileAccess.open("user://windowkill_data.res", FileAccess.WRITE)
	var data = {
		options = Global.options,
		
	}
	loadedData = data
	file.store_line(JSON.stringify(data))
	var fileSave = FileAccess.open("user://save.res", FileAccess.WRITE)
	var dataSave = {
		save = Global.save,
	}
	loadedSave = dataSave
	fileSave.store_line(JSON.stringify(dataSave))
	Stats.updateRecords()
	Stats.saveData()
var loadedData := {}
var loadedSave := {}
func loadData(force := false):
	if loadedData and not force:
		return
	var file = FileAccess.open("user://windowkill_data.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_line())
	if data:
		loadedData = data
		if data.has("options"):
			Global.options.merge(data.options, true)
			if Meta.forceFakeWindows:
				Global.options.fakeWindows = true
		if data.has("save"):
			Global.save.merge(data.save, true)
			loadedSave = {save = data.save}
		updateScreenRect()
	var fileSave = FileAccess.open("user://save.res", FileAccess.READ)
	if fileSave:
		var dataSave = JSON.parse_string(fileSave.get_line())
		if dataSave:
			loadedSave = dataSave
			if dataSave.has("save"):
				Global.save.merge(dataSave.save, true)
	Stats.loadData()
func reapplyData():
	if not loadedData.is_empty():
		if loadedData.has("options"):
			Global.options.merge(loadedData.options, true)
	if not loadedSave.is_empty():
		if loadedSave.has("save"):
			Global.save.merge(loadedSave.save, true)
func backupData():
	if not DirAccess.dir_exists_absolute("user://backup"):
		DirAccess.make_dir_absolute("user://backup")
	for file in DirAccess.get_files_at("user://"):
		if file.get_extension().to_lower() == "res":
			DirAccess.copy_absolute("user://".path_join(file), "user://backup".path_join(file))
func initOptions():
	Audio.setVolume("sfx", Global.options.soundVolume)
	Audio.setVolume("music", Global.options.musicVolume)
	if not Global.save.escaped:
		Global.options.preventFullChargeOrb = false
           extends Node
var shaders = [
	preload("res://src/main/bg.gdshader"),
	preload("res://src/element/drain/drain.gdshader"),
	preload("res://src/enemy/boss_slime/outline.gdshader"), 
	preload("res://src/enemy/boss_slime/slimeTrail.gdshader"), 
	preload("res://src/enemy/boss_virus/blink.gdshader"), 
	preload("res://src/enemy/boss_virus/shield.gdshader"), 
	preload("res://src/ui/damage.gdshader"),
	preload("res://src/element/coin/coin.gdshader"),
	preload("res://src/element/slash/slash.gdshader"),
	preload("res://src/enemy/boss_orb/orb.gdshader"),
	preload("res://src/main/bg2.gdshader"),
	preload("res://src/main/bg.gdshader"),
	preload("res://src/main/bgRim.gdshader"),
	preload("res://src/main/halt.gdshader"),
	preload("res://src/player/player_bg.gdshader"),
]
var frames = 3
var sprites = []
var parent
func run(parent:Node, pos := Vector2.ZERO) -> void:
	self.parent = parent
	var tex = PlaceholderTexture2D.new()
	tex.size = Vector2(1, 1)
	var i = 0
	for s in shaders:
		i += 1
		var sprite = Sprite2D.new()
		sprite.texture = tex
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = s
		sprite.position = Vector2(i*1, 2)
		parent.add_child(sprite)
		sprites.push_back(sprite)
	Utils.runLaterFrames(2, func():
		for sprite in sprites:
			if parent.is_ancestor_of(sprite):
				parent.remove_child(sprite)
	)
               extends Node
enum InputType {
	KEYBOARD,
	CONTROLLER,
	MOUSE
}
enum InputEventType {
	KEY,
	MOUSE_BUTTON,
	CONTROLLER_AXIS,
	CONTROLLER_BUTTON
}
enum InputOptionType {
	AIM, 
	MOVE, 
	ACTION 
}
var curInputType := InputType.KEYBOARD
var curAimType := InputType.MOUSE
var inputSets:Dictionary = {}
var defaultInputSets:Dictionary = {}
var controllerButtonLabels := {
	JOY_BUTTON_A: "A",
	JOY_BUTTON_B: "B",
	JOY_BUTTON_X: "X",
	JOY_BUTTON_Y: "Y",
}
func _ready():
	Global.players = []
	loadInputs()
	if inputSets.has(-1):
		assignInputs(-1, inputSets[-1])
	else:
		loadDefaultInputs()
		assignInputs(-1, defaultInputSets[-1])
	pass
func _process(delta):
	pass
func getControlColor(index:int, alt := false) -> Color:
	if alt:
		index += 8
	var hue = fposmod(0.55 + 0.275*index, 1.0)
	return Color.from_hsv(hue, 0.82, 1.0)
func addAction(action:String, event:InputEvent, overwrite := false, isController := false, allDevices := false):
	if allDevices:
		event.device = -1
	if InputMap.has_action(action):
		if overwrite:
			InputMap.action_erase_events(action)
	else:
		InputMap.add_action(action, 0.1)
	InputMap.action_add_event(action, event)
	if InputMap.has_action("ct_"+action):
		if overwrite:
			InputMap.action_erase_events("ct_"+action)
	else:
		if isController:
			InputMap.add_action("ct_"+action, 0.1)
	if isController:
		InputMap.action_add_event("ct_"+action, event)
func addActions(action:String, events:Array, overwrite := false, isController := false, allDevices := false):
	if allDevices:
		for e in events:
			e.device = -1
	if InputMap.has_action(action):
		if overwrite:
			InputMap.action_erase_events(action)
	else:
		InputMap.add_action(action, 0.1)
	if InputMap.has_action(action+"_alt"):
		if overwrite:
			InputMap.action_erase_events(action+"_alt")
	else:
		InputMap.add_action(action+"_alt", 0.1)
	for e in events:
		if e.axis_value < 0:
			InputMap.action_add_event(action+"_alt", e)
		else:
			InputMap.action_add_event(action, e)
	if InputMap.has_action("ct_"+action):
		if overwrite:
			InputMap.action_erase_events("ct_"+action)
	else:
		if isController:
			InputMap.add_action("ct_"+action, 0.1)
	if InputMap.has_action("ct_"+action+"_alt"):
		if overwrite:
			InputMap.action_erase_events("ct_"+action+"_alt")
	else:
		if isController:
			InputMap.add_action("ct_"+action+"_alt", 0.1)
	if isController:
		for e in events:
			if e.axis_value < 0:
				InputMap.action_add_event("ct_"+action+"_alt", e)
			else:
				InputMap.action_add_event("ct_"+action, e)
func assignInputs(playerIndex:int, inputSet:Dictionary):
	inputSets[playerIndex] = inputSet
	var prefix = str(playerIndex) + "|"
	if playerIndex < 0:
		prefix = ""
	var event:InputEvent
	for actionName in inputSet.keys():
		for i in inputSet[actionName].size():
			var io = inputSet[actionName][i]
			if io.inputType < 0:
				continue
			var isController:bool = io.inputType == InputType.CONTROLLER
			if io.type == InputOptionType.AIM:
				if io.inputType == InputType.CONTROLLER or io.inputType == InputType.KEYBOARD:
					addAction(prefix+"aimUp", io.events[0], i==0, isController, playerIndex < 0)
					addAction(prefix+"aimLeft", io.events[1], i==0, isController, playerIndex < 0)
					addAction(prefix+"aimDown", io.events[2], i==0, isController, playerIndex < 0)
					addAction(prefix+"aimRight", io.events[3], i==0, isController, playerIndex < 0)
			elif io.type == InputOptionType.MOVE:
				addAction(prefix+"moveUp", io.events[0], i==0, isController, playerIndex < 0)
				addAction(prefix+"moveLeft", io.events[1], i==0, isController, playerIndex < 0)
				addAction(prefix+"moveDown", io.events[2], i==0, isController, playerIndex < 0)
				addAction(prefix+"moveRight", io.events[3], i==0, isController, playerIndex < 0)
			elif io.type == InputOptionType.ACTION:
				if actionName == "shoot" and io.events[0] is InputEventJoypadMotion \
				and (io.events[0].axis == JOY_AXIS_LEFT_X or io.events[0].axis == JOY_AXIS_LEFT_Y \
				or io.events[0].axis == JOY_AXIS_RIGHT_X or io.events[0].axis == JOY_AXIS_RIGHT_Y):
					var j = [
						InputEventJoypadMotion.new(),
						InputEventJoypadMotion.new(),
						InputEventJoypadMotion.new(),
						InputEventJoypadMotion.new(),
					]
					if io.events[0].axis == JOY_AXIS_LEFT_X or io.events[0].axis == JOY_AXIS_LEFT_Y:
						j[0].axis = JOY_AXIS_LEFT_X
						j[0].axis_value = 1.0
						j[1].axis = JOY_AXIS_LEFT_X
						j[1].axis_value = -1.0
						j[2].axis = JOY_AXIS_LEFT_Y
						j[2].axis_value = 1.0
						j[3].axis = JOY_AXIS_LEFT_Y
						j[3].axis_value = -1.0
					else:
						j[0].axis = JOY_AXIS_RIGHT_X
						j[0].axis_value = 1.0
						j[1].axis = JOY_AXIS_RIGHT_X
						j[1].axis_value = -1.0
						j[2].axis = JOY_AXIS_RIGHT_Y
						j[2].axis_value = 1.0
						j[3].axis = JOY_AXIS_RIGHT_Y
						j[3].axis_value = -1.0
					addActions(prefix+actionName, j, i==0, isController, playerIndex < 0)
				else:
					addAction(prefix+actionName, io.events[0], i==0, isController, playerIndex < 0)
func getInputEventType(event:InputEvent) -> InputEventType:
	if event is InputEventKey:
		return InputEventType.KEY
	if event is InputEventMouseButton:
		return InputEventType.MOUSE_BUTTON
	if event is InputEventJoypadButton:
		return InputEventType.CONTROLLER_BUTTON
	if event is InputEventJoypadMotion:
		return InputEventType.CONTROLLER_AXIS
	return -1
func serializeEvent(event:InputEvent) -> Dictionary:
	var type = getInputEventType(event)
	if event is InputEventMouseButton:
		return {
			type = type,
			button_index = event.button_index
		}
	if event is InputEventKey:
		return {
			type = type,
			keycode = event.keycode,
			physical_keycode = event.physical_keycode,
		}
	if event is InputEventJoypadButton:
		return {
			type = type,
			button_index = event.button_index
		}
	if event is InputEventJoypadMotion:
		return {
			type = type,
			axis = event.axis,
			axis_value = event.axis_value
		}
	return {}
func deserializeEvent(eventData:Dictionary) -> InputEvent:
	if eventData.type == InputEventType.KEY:
		var event = InputEventKey.new()
		event.keycode = eventData.keycode
		event.physical_keycode = eventData.physical_keycode
		return event
	if eventData.type ==  InputEventType.MOUSE_BUTTON:
		var event = InputEventMouseButton.new()
		event.button_index = eventData.button_index
		return event
	if eventData.type ==  InputEventType.CONTROLLER_BUTTON:
		var event = InputEventJoypadButton.new()
		event.button_index = eventData.button_index
		return event
	if eventData.type ==  InputEventType.CONTROLLER_AXIS:
		var event = InputEventJoypadMotion.new()
		event.axis = eventData.axis
		event.axis_value = eventData.axis_value
		return event
	return null
func serializeInputSet(inputSet):
	var data = {}
	for actionName in inputSet.keys():
		var inputSetItems = inputSet[actionName]
		data[actionName] = []
		for inputSetItem in inputSetItems:
			var events = []
			for e in inputSetItem.events:
				events.push_back(serializeEvent(e))
			data[actionName].push_back({
				type = inputSetItem.type,
				inputType = inputSetItem.inputType,
				events = events,
				deviceIndex = inputSetItem.deviceIndex,
			})
	return data
func deserializeInputSet(inputSet):
	var data = {}
	for actionName in inputSet.keys():
		var inputSetItems = inputSet[actionName]
		data[actionName] = []
		for inputSetItem in inputSetItems:
			var events = []
			for e in inputSetItem.events:
				if not e.is_empty():
					events.push_back(deserializeEvent(e))
			data[actionName].push_back({
				type = inputSetItem.type,
				inputType = inputSetItem.inputType,
				events = events,
				deviceIndex = inputSetItem.deviceIndex,
			})
	return data
func saveInputs():
	var file = FileAccess.open("user://controls.res", FileAccess.WRITE)
	var controls = {}
	for k in inputSets.keys():
		controls[k] = serializeInputSet(inputSets[k])
	file.store_line(JSON.stringify(controls))
func loadInputs(force := false):
	if not force and inputSets.size() > 0:
		return
	var file = FileAccess.open("user://controls.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if data:
		for k in data.keys():
			inputSets[int(k)] = deserializeInputSet(data[k])
func loadDefaultInputs(force := false):
	if not force and not defaultInputSets.is_empty():
		return
	var file = FileAccess.open("res://data/default_controls.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if data:
		for k in data.keys():
			defaultInputSets[int(k)] = deserializeInputSet(data[k])
func reset():
	Global.players = []
func addPlayer(node:Node2D) -> int:
	Global.players.push_back(node)
	return Global.players.size()-1
func checkMissingDevices():
	var keyboards = []
	var mice = []
	for inputSet in inputSets.values():
		for action in inputSet.values():
			if action[0].inputType == InputType.KEYBOARD:
				if action[0].deviceIndex < 0:
					continue
				if not keyboards.has(action[0].deviceIndex):
					keyboards.push_back(action[0].deviceIndex)
			if action[0].inputType == InputType.MOUSE:
				if action[0].deviceIndex < 0:
					continue
				if not mice.has(action[0].deviceIndex):
					mice.push_back(action[0].deviceIndex)
	if (keyboards.size() > DisplayServer.multi_keyboard_get_count()) or (mice.size() > DisplayServer.multi_cursor_get_count()):
		return ({
			keyboards = keyboards,
			mice = mice
		})
	else:
		return null
func getActionStrength(action:String, index:int) -> float:
	var val := 0.0
	if index < 0:
		val += Input.get_action_strength(action)
	else:
		if not inputSets.has(index) or not inputSets[index].has(action):
			return false
		var prefix = str(index) + "|"
		if inputSets[index][action][0].inputType == InputType.KEYBOARD:
			if RawInput.is_action_pressed(prefix+action, inputSets[index][action][0].deviceIndex if Players.multiMouse else -1):
				val += 1
		elif inputSets[index][action][0].inputType == InputType.MOUSE:
			if RawInput.is_action_pressed(prefix+action, inputSets[index][action][0].deviceIndex):
				val += 1
		elif inputSets[index][action][0].inputType == InputType.CONTROLLER:
			var e = InputMap.action_get_events(prefix)[0]
			val += Input.get_joy_axis(index, e.axis) * e.axis_value
	return val
func isActionPressed(action:String, index:int) -> bool:
	var val := false
	if index < 0:
		if RawInput.is_action_pressed(action):
			val = true
		if action == "shoot" and RawInput.is_action_pressed(action+"_alt"):
			val = true
	else:
		if not inputSets.has(index) or not inputSets[index].has(action):
			return false
		var prefix = str(index) + "|"
		if inputSets[index][action][0].inputType == InputType.KEYBOARD:
			if RawInput.is_action_pressed(prefix+action, inputSets[index][action][0].deviceIndex if Players.multiMouse else -1):
				val = true
		elif inputSets[index][action][0].inputType == InputType.MOUSE:
			if RawInput.is_action_pressed(prefix+action, inputSets[index][action][0].deviceIndex if Players.multiMouse else -1):
				val = true
		elif inputSets[index][action][0].inputType == InputType.CONTROLLER:
			if RawInput.is_action_pressed(prefix+action):
				val = true
	return val
func getAimVector(index:int):
	var prefix = ""
	var vector = Vector2.ZERO
	if index < 0:
		if curAimType == InputType.MOUSE:
			if Global.main:
				vector = (Global.main.get_global_mouse_position() - Global.player.position)
			else:
				vector = (Global.player.get_global_mouse_position() - Global.player.position)
		elif curAimType == InputType.CONTROLLER:
			vector = Input.get_vector(prefix+"aimLeft", prefix+"aimRight", prefix+"aimUp", prefix+"aimDown")
	else:
		prefix = str(index) + "|"
		if inputSets[index]["aim"][0].inputType == InputType.MOUSE:
			if Players.multiMouse:
				vector = (DisplayServer.multi_cursor_get_position(inputSets[index]["aim"][0].deviceIndex) - Global.players[index].position)
			else:
				vector = (Global.main.get_global_mouse_position() - Global.players[index].position)
		elif inputSets[index]["aim"][0].inputType == InputType.KEYBOARD:
			if RawInput.is_action_pressed(prefix+"aimLeft", inputSets[index]["aim"][0].deviceIndex if Players.multiMouse else -1):
				vector.x -= 1.0
			if RawInput.is_action_pressed(prefix+"aimRight", inputSets[index]["aim"][0].deviceIndex if Players.multiMouse else -1):
				vector.x += 1.0
			if RawInput.is_action_pressed(prefix+"aimUp", inputSets[index]["aim"][0].deviceIndex if Players.multiMouse else -1):
				vector.y -= 1.0
			if RawInput.is_action_pressed(prefix+"aimDown", inputSets[index]["aim"][0].deviceIndex if Players.multiMouse else -1):
				vector.y += 1.0
		elif inputSets[index]["aim"][0].inputType == InputType.CONTROLLER:
			vector = Input.get_vector(prefix+"aimLeft", prefix+"aimRight", prefix+"aimUp", prefix+"aimDown")
	if vector.length() < 0.08:
		vector = Vector2.ZERO
	return vector
func getMoveVector(index:int) -> Vector2:
	var vector := Vector2.ZERO
	if index < 0:
		if curInputType == InputType.CONTROLLER:
			vector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		else:
			if RawInput.is_action_pressed("moveLeft"):
				vector.x -= 1
			if RawInput.is_action_pressed("moveRight"):
				vector.x += 1
			if RawInput.is_action_pressed("moveUp"):
				vector.y -= 1
			if RawInput.is_action_pressed("moveDown"):
				vector.y += 1
	else:
		if not inputSets.has(index) or not inputSets[index].has("move"):
			return Vector2.ZERO
		var prefix = str(index) + "|"
		if inputSets[index]["move"][0].inputType == InputType.KEYBOARD:
			if RawInput.is_action_pressed(prefix+"moveLeft", inputSets[index]["move"][0].deviceIndex if Players.multiMouse else -1):
				vector.x -= 1
			if RawInput.is_action_pressed(prefix+"moveRight", inputSets[index]["move"][0].deviceIndex if Players.multiMouse else -1):
				vector.x += 1
			if RawInput.is_action_pressed(prefix+"moveUp", inputSets[index]["move"][0].deviceIndex if Players.multiMouse else -1):
				vector.y -= 1
			if RawInput.is_action_pressed(prefix+"moveDown", inputSets[index]["move"][0].deviceIndex if Players.multiMouse else -1):
				vector.y += 1
		elif inputSets[index]["move"][0].inputType == InputType.CONTROLLER:
			vector = Input.get_vector(prefix+"moveLeft", prefix+"moveRight", prefix+"moveUp", prefix+"moveDown")
	if vector.length() < 0.08:
		vector = Vector2.ZERO
	return vector
 extends Node
signal mpInputOptionActivate(option:Control)
signal mpUpdatePlayers()
signal updatePlayer()
signal updateControls()
signal optionsOpen()
signal optionChanged()
signal unlock(key:String)
signal pUpdate()
signal fakeWindowPreUpdate()
signal fakeWindowUpdate()
signal fakeWindowPostUpdate()
signal screenRectUpdated()
signal bgUpdated()
signal languageChanged()
signal files_dropped(files)
signal titleCharColor()
signal titleCharColorState()
signal titleCharSkin()
signal titleReturn()
signal abilityActivated()
signal abilityDeactivated()
signal obliterated()
signal lastStandUpdated()
signal pauseUpdated(state:bool)
signal bossVirusUpdated()
extends Node
enum Char {
	BASIC,
	MAGE,
	LASER,
	MELEE,
	AOE,
	POINTER,
	CHEAT,
}
var charList := [
	Char.BASIC,
	Char.MAGE,
	Char.LASER,
	Char.MELEE,
	
	Char.POINTER,
	Char.CHEAT,
]
var charNames := {
	Char.BASIC: "basic",
	Char.MAGE: "mage",
	Char.LASER: "laser",
	Char.MELEE: "melee",
	Char.AOE: "aoe",
	Char.POINTER: "pointer",
	Char.CHEAT: "cheat",
}
var unlockedCharList := []
enum Ability {
	bellow,
	halt,
	torrent,
	endure,
	deflect,
	detach,
	crumb,
}
var charData := {
	Char.BASIC: {
		internalName = "basic",
		displayName = "epsilon",
		ability = Ability.bellow,
		wallShrinkSpeed = 1.0,
		wallResistance = 1.0,
		spawnRate = preload("res://src/player/basic/spawnRate.tres"),
		priceScale = 1.0,
		skins = [""],
		unlocked = false,
	},
	Char.MAGE: {
		internalName = "mage",
		displayName = "nyx",
		ability = Ability.halt,
		wallShrinkSpeed = 0.5,
		wallResistance = 0.9,
		spawnRate = preload("res://src/player/mage/spawnRate.tres"),
		priceScale = 1.0,
		skins = [""],
		unlocked = false,
	},
	Char.LASER: {
		internalName = "laser",
		displayName = "bastion",
		ability = Ability.torrent,
		wallShrinkSpeed = 0.95,
		wallResistance = 0.95,
		spawnRate = preload("res://src/player/laser/spawnRate.tres"),
		priceScale = 1.0/(0.65),
		skins = [""],
		unlocked = false,
	},
	Char.MELEE: {
		internalName = "melee",
		displayName = "zephyr",
		ability = Ability.endure,
		wallShrinkSpeed = 1.0,
		wallResistance = 0.966,
		spawnRate = preload("res://src/player/melee/spawnRate.tres"),
		priceScale = 1.0/(0.5),
		skins = [""],
		unlocked = false,
	},
	Char.AOE: {
		internalName = "aoe",
		displayName = "???",
		ability = Ability.deflect,
		wallShrinkSpeed = 1.0,
		wallResistance = 1.0,
		spawnRate = preload("res://src/player/basic/spawnRate.tres"),
		priceScale = 1.0,
		skins = [""],
		unlocked = false,
	},
	Char.POINTER: {
		internalName = "pointer",
		displayName = ":)",
		ability = Ability.detach,
		wallShrinkSpeed = 0.35,
		wallResistance = 0.92,
		spawnRate = preload("res://src/player/pointer/spawnRate.tres"),
		priceScale = 1.0,
		skins = [""],
		unlocked = false,
	},
	Char.CHEAT: {
		internalName = "cheat",
		displayName = "blip",
		ability = Ability.crumb,
		wallShrinkSpeed = 1.0,
		wallResistance = 1.0,
		spawnRate = preload("res://src/player/cheat/spawnRate.tres"),
		priceScale = 1.0/0.1,
		skins = [""],
		unlocked = false,
	},
}
var details:Array[Dictionary] = []
var singleDetails:Dictionary = {
	char = Char.BASIC,
	color = Color.WHITE,
	bgColor = Color.TRANSPARENT,
	colorState = 0,
	skin = "",
}
var unique:Array[int] = []
var inMultiplayer := false
var playerCount := 1
var multiMouse := false
var timedMode := false
var hasCheat := false
func _ready():
	Events.mpUpdatePlayers.connect(saveData)
	Events.updatePlayer.connect(func():
		saveData(true)
	)
	Unlocks.loadData()
	Unlocks.sUnlocked.connect(func(item):
		updateUnlocks()
	)
	updateUnlocks()
func updateUnlocks():
	unlockedCharList = []
	charData[Char.BASIC].unlocked = true
	unlockedCharList.push_back(Char.BASIC)
	if Unlocks.items.charMage.unlocked:
		charData[Char.MAGE].unlocked = true
		unlockedCharList.push_back(Char.MAGE)
		if Unlocks.items.skinHector.unlocked:
			charData[Char.MAGE].skins.push_back("skinHector")
	if Unlocks.items.charLaser.unlocked:
		charData[Char.LASER].unlocked = true
		unlockedCharList.push_back(Char.LASER)
	if Unlocks.items.charMelee.unlocked:
		charData[Char.MELEE].unlocked = true
		unlockedCharList.push_back(Char.MELEE)
	if Unlocks.items.charPointer.unlocked:
		charData[Char.POINTER].unlocked = true
		unlockedCharList.push_back(Char.POINTER)
	if Unlocks.items.charCheat.unlocked:
		charData[Char.CHEAT].unlocked = true
		unlockedCharList.push_back(Char.CHEAT)
	if Unlocks.items.skinCrown.unlocked:
		for char in charList:
			charData[char].skins.push_back("skinCrown")
func reset():
	details = []
	unique = []
	hasCheat = false
func addPlayer(deets:Dictionary = {}):
	var d = {
		char = deets.get("char", Char.BASIC),
		color = deets.get("color", Color.WHITE),
		bgColor = deets.get("bgColor", Color.TRANSPARENT),
		colorState = deets.get("colorState", 0),
		skin = "",
	}
	details.push_back(d)
	if d.char == Char.CHEAT:
		hasCheat = true
func removePlayer(index:int):
	details.remove_at(index)
func getUniqueChars():
	if unique.size() == 0:
		for d in details:
			if not unique.has(d.char):
				unique.push_back(d.char)
	return unique
func charName(char:int):
	return
func saveData(single := false):
	var file = FileAccess.open("user://player.res" if single else "user://players.res", FileAccess.WRITE)
	var data = {
		details = []
	}
	for d in details:
		data.details.push_back({
			char = d.char,
			color = d.color.to_html(),
			bgColor = d.bgColor.to_html(),
			colorState = d.colorState,
			skin = d.skin,
		})
	loadedData = data
	file.store_line(JSON.stringify(data))
var loadedData := {}
func loadData(single := false, force := false):
	if loadedData and not force:
		return
	var file = FileAccess.open("user://player.res" if single else "user://players.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_line())
	if data:
		loadedData = data
		if data.has("details"):
			for d in data.details:
				if single:
					singleDetails = {
						char = int(d.get("char", Char.BASIC)),
						color = Color.from_string(d.get("color"), Color.WHITE),
						bgColor = Color.from_string(d.get("bgColor"), Color.WHITE),
						colorState = int(d.get("colorState", 0)),
						skin = str(d.get("skin", "")),
					}
				else:
					details.push_back({
						char = int(d.get("char", Char.BASIC)),
						color = Color.from_string(d.get("color"), Color.WHITE),
						bgColor = Color.from_string(d.get("bgColor"), Color.WHITE),
						colorState = int(d.get("colorState", 0)),
						skin = str(d.get("skin", "")),
					})
       extends Node2D
signal sActivate(control:Control)
signal sFocusChanged(control:Control)
signal sFindNextFocus(dir:int)
signal sChoiceButtonOpen(control:Control)
var usingMouse := false
var outline:Node2D
var focusedControl:Control
var focusNext := false
var curViewport:Viewport
var inputViewport:Viewport
var isolated := false
var finishing := false
var delayTimer := 0.0
var delayInputControl:Control
var prevDummy:Control
var acceptAll := true
var handled := []
@onready var root = get_tree().root
func _ready():
	outline = Utils.spawn(preload("res://src/ui/focus_outline.tscn"), Vector2.ZERO, self)
	outline.disable()
	var vp = get_viewport()
	registerViewport(vp)
	changeViewport(self, vp)
	tree_exiting.connect(func():
		(func():
			if not is_inside_tree():
				outline.disable()
				reparent(root)
		).call_deferred()
		
	)
func registerViewport(viewport:Viewport):
	if not viewport.gui_focus_changed.is_connected(_on_focus_changed):
		viewport.gui_focus_changed.connect(_on_focus_changed)
	if viewport is Window:
		viewport.window_input.connect(func(event):
			inputViewport = viewport
			on_input(event)
		)
func disable():
	outline.disable()
func delayInput(time := 1.0):
	delayTimer = time
	delayInputControl = focusedControl if focusedControl else prevDummy
	get_tree().root.set_process_input(false)
func focus(control:Control):
	control.grab_focus()
	outline.enable()
	_on_focus_changed(control)
func unfocus():
	focusedControl = null
	outline.disable()
	sFocusChanged.emit(null)
func getWindowFocusControl(win:Window) -> Control:
	if win.get_child_count() <= 0:
		return
	var cpath = win.get_meta("focus_control", false)
	var c:Node
	if cpath:
		c = win.get_node(cpath)
	else:
		c = win.get_child(0)
		var i := 1
		while i < win.get_child_count() and (not c is Control or c.focus_mode == Control.FOCUS_NONE):
			c = win.get_child(i)
			i += 1
	if c is Control:
		if c.focus_mode == Control.FOCUS_NONE:
			var c2 = Focus.findNextControlFocus(c)
			if c2 is Control and not c2.focus_mode == Control.FOCUS_NONE:
				return c2
		else:
			return c
	return null
func windowFocus(win:Window):
	win.grab_focus()
	windowFocused(win)
func windowFocused(win:Window):
	var control = getWindowFocusControl(win)
	if control:
		control.grab_focus()
		_on_focus_changed(control)
func changeViewport(control:Node, viewport:Viewport):
	if viewport is Window:
		viewport.grab_focus()
	if viewport != get_viewport():
		curViewport = viewport
		outline.disable()
		reparent.call_deferred(viewport)
		for n in control.get_tree().get_nodes_in_group("focus_dummy"):
			n.focus_mode = Control.FOCUS_ALL
func _process(delta):
	if delayTimer > 0.0:
		delayTimer -= 1.0 * delta
		if delayInputControl and not delayInputControl.has_focus() and delayInputControl.is_inside_tree():
			delayInputControl.focus_mode = Control.FOCUS_ALL
			delayInputControl.grab_focus()
	if prevDummy and prevDummy.is_inside_tree() and not is_instance_valid(focusedControl):
		prevDummy.focus_mode = Control.FOCUS_ALL
		prevDummy.grab_focus()
	handled.clear()
func isolate(control:Control):
	if not isolated:
		if focusedControl:
			focusedControl.release_focus()
		isolated = true
		outline.isolate(control)
		focusedControl = control
func endIsolate():
	finishing = true
	Utils.runLater(1, func():
		finishing = false
		isolated = false
		outline.endIsolate()
		if focusedControl:
			focusedControl.grab_focus()
	)
func _on_focus_changed(control:Control):
	if Input.is_action_just_pressed("click"):
		usingMouse = true
	elif Input.is_action_just_pressed("controllerInput") or Input.is_action_just_pressed("keyboardInput"):
		usingMouse = false
	if control == null:
		outline.disable()
	elif control == focusedControl:
		return
	if isolated:
		focusedControl.grab_focus()
		return
	if focusedControl and focusedControl.get_viewport() and focusedControl.get_viewport().get_meta("restrict_focus", false) and control.get_viewport() != focusedControl.get_viewport():
		return
	else:
		changeViewport(control, control.get_viewport())
		if control.is_in_group("focus_dummy"):
			focusedControl = null
			prevDummy = control
			outline.disable()
		else:
			if Input.is_action_just_pressed("ui_left") \
			or Input.is_action_just_pressed("ui_right") \
			or Input.is_action_just_pressed("ui_up") \
			or Input.is_action_just_pressed("ui_down") \
			or Input.is_action_just_pressed("uiAccept") \
			or Input.is_action_just_pressed("uiCancel"):
				focusNext = true
			focusedControl = control
			outline.focus(control)
			sFocusChanged.emit(control)
			if focusNext:
				focusNext = false
				outline.enable.call_deferred()
			if prevDummy:
				prevDummy.focus_mode = Control.FOCUS_NONE
func findNextFocus(dir := 0):
	if isolated:
		return
	sFindNextFocus.emit(dir)
func findNextControlFocus(start:Control):
	var c = start.find_next_valid_focus()
	while c and c.focus_mode == Control.FOCUS_NONE:
		c = c.find_next_valid_focus()
	return c
func on_input(event):
	if delayTimer > 0.0:
		return
	if handled.has(event):
		return
	else:
		handled.push_back(event)
	if curViewport and not curViewport.get_meta("restrict_focus", false):
		if focusedControl and focusedControl.get_meta("keep_focus", false):
			pass
		else:
			if Input.is_action_just_pressed("ui_left") \
			or Input.is_action_just_pressed("ui_right") \
			or Input.is_action_just_pressed("ui_up") \
			or Input.is_action_just_pressed("ui_down"):
				if Global.inTitle:
					Audio.play(preload("res://src/sounds/focus.ogg"), 0.8, 1.2)
				var prev := focusedControl
				Utils.runLater(1, func():
					if focusedControl == prev:
						var dir := 0
						if Input.is_action_just_pressed("ui_down"): dir = 1
						elif Input.is_action_just_pressed("ui_left"): dir = 2
						elif Input.is_action_just_pressed("ui_up"): dir = 3
						focusNext = true
						findNextFocus(dir)
					else:
						if not Global.inTitle:
							Audio.play(preload("res://src/sounds/focus.ogg"), 0.8, 1.2)
				)
	if finishing:
		return
	focusNext = false
	if isolated:
		if Input.is_action_just_pressed("uiCancel"):
			if focusedControl and "cancelInput" in focusedControl:
				focusedControl.cancelInput()
			outline.endIsolate()
		else:
			if event is InputEventKey \
			or event is InputEventMouseButton \
			or event is InputEventJoypadButton \
			or event is InputEventJoypadMotion:
				if focusedControl and "passIsolatedInput" in focusedControl:
					focusedControl.passIsolatedInput(event)
		if focusedControl:
			focusedControl.grab_focus()
	else:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not inputViewport.get_mouse_position().x > inputViewport.get_window().size.x - 12:
				unfocus()
		elif Input.is_action_just_pressed("uiAcceptAll" if acceptAll else "uiAccept"):
			if focusedControl:
				if "activate" in focusedControl:
					focusedControl.activate()
				sActivate.emit(focusedControl)
		elif Input.is_action_just_pressed("uiCancel"):
			unfocus()
		if focusedControl and "passInput" in focusedControl:
			focusedControl.passInput(event)
      extends Node
signal sUnlocked(item:String)
var prevCheck := {}
var items := {
	timedMode = {
		title = (func():
			return "game mode: timed run"
			),
		description = (func():
			return "survive for 20 minutes"
			),
		icon = preload("res://src/ui/unlocks/icons/timedMode.svg"),
		unlocked = false,
		attemptValue = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("all"):
					return Stats.records.totalTime.all
			return 0
			),
		attemptText = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("all"):
					return "(" + tr("best") + ": " + Utils.hms(Stats.records.totalTime.all, 2) + ")"
			return "(" + tr("best") + ": " + Utils.hms(0, 2) + ")"
			),
		check = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("all"):
					return Stats.records.totalTime.all >= 60 * 20 
			return false
			)
	},
	charMage = {
		title = (func():
			return "character: nyx"
			),
		description = (func():
			return "get lv. 8 multishot"
			),
		icon = preload("res://src/ui/unlocks/icons/charMage.svg"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestMultiShot
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestMultiShot) + ")"
			),
		check = (func():
			return Stats.metaStats.highestMultiShot >= 8
			)
	},
	charLaser = {
		title = (func():
			return "character: bastion"
			),
		description = (func():
			return "kill 10 spikers"
			),
		icon = preload("res://src/ui/unlocks/icons/charLaser.svg"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalSpikersKilled
			),
		attemptText = (func():
			return "(" + tr("current") + ": " + str(Stats.metaStats.totalSpikersKilled) + ")"
			),
		check = (func():
			return Stats.metaStats.totalSpikersKilled >= 10
			)
	},
	charMelee = {
		title = (func():
			return "character: zephyr"
			),
		description = (func():
			return "have 50 health"
			),
		icon = preload("res://src/ui/unlocks/icons/charMelee.svg"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestHealth
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestHealth) + ")"
			),
		check = (func():
			return Stats.metaStats.highestHealth >= 50
			)
	},
	charPointer = {
		title = (func():
			return "character: :)"
			),
		description = (func():
			return "kill ???"
			),
		icon = preload("res://src/ui/unlocks/icons/charPointer.svg"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalUltraSmileysKilled
			),
		attemptText = (func():
			return ""
			),
		check = (func():
			return Stats.metaStats.totalUltraSmileysKilled >= 1
			)
	},
	musicChill = {
		title = (func():
			return "music track: windowchill"
			),
		description = (func():
			return "reach the end of timed mode"
			),
		icon = preload("res://src/ui/unlocks/icons/musicChill.svg"),
		unlocked = false,
		attemptValue = (func():
			return min(Stats.metaStats.bestTimedModeTime, Global.timedModeLimit)
			),
		attemptText = (func():
			return "(" + tr("best time") + ": " + str(Utils.hms(min(Stats.metaStats.bestTimedModeTime, Global.timedModeLimit), 2.0)) + ")"
			),
		check = (func():
			return Global.save.beatTimedMode
			)
	},
	musicBreak = {
		title = (func():
			return "music track: windowbreaker"
			),
		description = (func():
			return "get a x4 multiplier"
			),
		icon = preload("res://src/ui/unlocks/icons/musicBreak.svg"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestMultiplier
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestMultiplier + 1) + ")"
			),
		check = (func():
			return Stats.metaStats.highestMultiplier >= 3
			)
	},
	bgTransparent = {
		title = (func():
			return "background: transparent"
			),
		description = (func():
			return "kill every boss"
			),
		icon = preload("res://src/ui/unlocks/icons/bgTransparent.png"),
		unlocked = false,
		attemptValue = (func():
			var val = 5
			if Stats.metaStats.totalSpikersKilled > 0: val -= 1
			if Stats.metaStats.totalWyrmsKilled > 0: val -= 1
			if Stats.metaStats.totalSlimesKilled > 0: val -= 1
			if Stats.metaStats.totalSmileysKilled > 0: val -= 1
			if Stats.metaStats.totalOrbsKilled > 0: val -= 1
			return val
			),
		attemptText = (func():
			var val = 5
			if Stats.metaStats.totalSpikersKilled > 0: val -= 1
			if Stats.metaStats.totalWyrmsKilled > 0: val -= 1
			if Stats.metaStats.totalSlimesKilled > 0: val -= 1
			if Stats.metaStats.totalSmileysKilled > 0: val -= 1
			if Stats.metaStats.totalOrbsKilled > 0: val -= 1
			return "(" + tr("remaining") + ": " + str(val) + ")"
			),
		check = (func():
			var val = 5
			if Stats.metaStats.totalSpikersKilled > 0: val -= 1
			if Stats.metaStats.totalWyrmsKilled > 0: val -= 1
			if Stats.metaStats.totalSlimesKilled > 0: val -= 1
			if Stats.metaStats.totalSmileysKilled > 0: val -= 1
			if Stats.metaStats.totalOrbsKilled > 0: val -= 1
			return val <= 0
			)
	},
	bgStars = {
		title = (func():
			return "background: stars"
			),
		description = (func():
			return "hold 8 stars at once"
			),
		icon = preload("res://src/ui/unlocks/icons/bgStars.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestTokens
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestTokens) + ")"
			),
		check = (func():
			return Stats.metaStats.highestTokens >= 8
			)
	},
	bgGrid = {
		title = (func():
			return "background: grid"
			),
		description = (func():
			return "get 40,000 coins in one run"
			),
		icon = preload("res://src/ui/unlocks/icons/bgGrid.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestTotalCoins
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestTotalCoins) + ")"
			),
		check = (func():
			return Stats.metaStats.highestTotalCoins >= 40000
			)
	},
	bgCells = {
		title = (func():
			return "background: cells"
			),
		description = (func():
			return "buy 100 shop items"
			),
		icon = preload("res://src/ui/unlocks/icons/bgCells.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalShopPurchases
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.totalShopPurchases) + ")"
			),
		check = (func():
			return Stats.metaStats.totalShopPurchases >= 100
			)
	},
	bgSoup = { 
		title = (func():
			return "background: soup"
			),
		description = (func():
			return "obliterate a star"
			),
		icon = preload("res://src/ui/unlocks/icons/bgSoup.png"),
		unlocked = false,
		attemptValue = (func():
			return 0
			),
		attemptText = (func():
			return ""
			),
		check = (func():
			return Global.save.obliteratedStar
			)
	},
	bgRipple = {
		title = (func():
			return "background: ripple"
			),
		description = (func():
			return "collect a 1000+ value coin"
			),
		icon = preload("res://src/ui/unlocks/icons/bgRipple.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestValueCoin
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestValueCoin) + ")"
			),
		check = (func():
			return Stats.metaStats.highestValueCoin >= 1000
			)
	},
	skinHector = {
		title = (func():
			return "nyx skin: hector"
			),
		description = (func():
			return "get lv. 4 halt"
			),
		icon = preload("res://src/ui/unlocks/icons/skinHector.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.highestHalt
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.highestHalt) + ")"
			),
		check = (func():
			return Stats.metaStats.highestHalt >= 4
			)
	},
	cursorSword = {
		title = (func():
			return "custom cursor: flame sword"
			),
		description = (func():
			
			return "kill an orb array as zephyr"
			),
		icon = preload("res://src/ui/unlocks/icons/cursorSword.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalZephyrOrbKills
			),
		attemptText = (func():
			return ""
			),
		check = (func():
			return Stats.metaStats.totalZephyrOrbKills >= 1
			)
	},
	windowWin98 = {
		title = (func():
			return "window theme: windows 98"
			),
		description = (func():
			return "kill 98 bosses"
			),
		icon = preload("res://src/ui/unlocks/icons/windowWin98.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalBossesKilled
			),
		attemptText = (func():
			return "(" + tr("current") + ": " + str(Stats.metaStats.totalBossesKilled) + ")"
			),
		check = (func():
			return Stats.metaStats.totalBossesKilled >= 98
			)
	},
	windowWinXP = {
		title = (func():
			return "window theme: windows xp"
			),
		description = (func():
			return "manifest 50 items"
			),
		icon = preload("res://src/ui/unlocks/icons/windowWinXP.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.totalManifests
			),
		attemptText = (func():
			return "(" + tr("current") + ": " + str(Stats.metaStats.totalManifests) + ")"
			),
		check = (func():
			return Stats.metaStats.totalManifests >= 50
			)
	},
	windowVaporwave = {
		title = (func():
			return "window theme: vaporwave"
			),
		description = (func():
			
			return "reach the end of timed mode as :)"
			),
		icon = preload("res://src/ui/unlocks/icons/windowVaporwave.png"),
		unlocked = false,
		attemptValue = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("timed"):
					if Stats.records.totalTime.timed.has(Players.charNames[Players.Char.POINTER]):
						return Stats.records.totalTime.timed[Players.charNames[Players.Char.POINTER]]
			return 0
			),
		attemptText = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("timed"):
					if Stats.records.totalTime.timed.has(Players.charNames[Players.Char.POINTER]):
						return "(" + tr("best time") + ": " + Utils.hms(Stats.records.totalTime.timed[Players.charNames[Players.Char.POINTER]], 2) + ")"
			return "(" + tr("best time") + ": " + Utils.hms(0, 2) + ")"
			),
		check = (func():
			if Stats.records.has("totalTime"):
				if Stats.records.totalTime.has("timed"):
					if Stats.records.totalTime.timed.has(Players.charNames[Players.Char.POINTER]):
						return Stats.records.totalTime.timed[Players.charNames[Players.Char.POINTER]] >= Global.timedModeLimit - 0.1
			return false
			)
	},
	windowCute = {
		title = (func():
			return "window theme: cute"
			),
		description = (func():
			
			return "survive for 2 minutes without shooting the window as bastion"
			),
		icon = preload("res://src/ui/unlocks/icons/windowCute.png"),
		unlocked = false,
		attemptValue = (func():
			return Stats.metaStats.bestBastionChallengeTime
			),
		attemptText = (func():
			return "(" + tr("best time") + ": " + Utils.hms(Stats.metaStats.bestBastionChallengeTime, 2) + ")"
			),
		check = (func():
			return Stats.metaStats.bestBastionChallengeTime >= 60*2
			)
	},
	skinCrown = {
		title = (func():
			return "crown"
			),
		description = (func():
			return "unlock everything"
			),
		icon = preload("res://src/ui/unlocks/icons/skinCrown.png"),
		unlocked = false,
		attemptValue = (func():
			return 0
			),
		attemptText = (func():
			return ""
			),
		check = (func():
			var unlockedAll := true
			for item in items.values():
				if item == items.skinCrown:
					continue
				if not item.unlocked and not item.get("hidden", false):
					unlockedAll = false
					break
			return unlockedAll
			)
	},
	friend = {
		title = (func():
			return "friend"
			),
		description = (func():
			return "kill ??? without taking damage"
			),
		icon = preload("res://src/ui/unlocks/icons/unknown.svg"),
		unlocked = false,
		hidden = true,
		attemptValue = (func():
			if Stats.metaStats.lowestUltraSmileyDamage is String and Stats.metaStats.lowestUltraSmileyDamage == Stats._INF:
				return INF
			return Stats.metaStats.lowestUltraSmileyDamage
			),
		attemptText = (func():
			return "(" + tr("best") + ": " + str(Stats.metaStats.lowestUltraSmileyDamage) + ")"
			),
		check = (func():
			if Stats.metaStats.lowestUltraSmileyDamage is String and Stats.metaStats.lowestUltraSmileyDamage == Stats._INF:
				return false
			return Stats.metaStats.lowestUltraSmileyDamage <= 0
			)
	},
	charCheat = {
		title = (func():
			return "character: blip"
			),
		description = (func():
			return "unravel the secret..."
			),
		icon = preload("res://src/ui/unlocks/icons/charCheat.svg"),
		unlocked = false,
		hidden = true,
		
			
				
			
			
		
			
			
		
			
				
			
			
		attemptValue = (func():
			return 0
			),
		attemptText = (func():
			return ""
			),
		check = (func():
			
				
			return Global.save.get("cheaty", false)
			)
	},
}
var timer := 0.0
var loaded := false
func _init():
	loadData()
	process_mode = Node.PROCESS_MODE_ALWAYS
	for key in items.keys():
		prevCheck[key] = items[key].unlocked
	loaded = true
func update():
	if loaded:
		for key in items.keys():
			if items[key].unlocked:
				continue
			items[key].unlocked = items[key].check.call()
			if (not prevCheck[key]) and items[key].unlocked == true:
				prevCheck[key] = true
				sUnlocked.emit(key)
				saveData()
				Steam.setAchievement(key)
				Audio.play(preload("res://src/sounds/unlock.ogg"), 1.0, 1.0)
				Utils.place(preload("res://src/ui/unlocks/unlock_popup.tscn"), Global.ui.unlocks_container, {title=items[key].title, hidden=items[key].get("hidden", false)})
	Utils.runLater(4000, func():
		Steam.storeStats()
	)
func checkOption(option:String, choice:String) -> bool:
	if option == "background" and choice == "1" and not Unlocks.items.bgTransparent.unlocked:
		return false
	if option == "background" and choice == "2" and not Unlocks.items.bgGrid.unlocked:
		return false
	if option == "background" and choice == "3" and not Unlocks.items.bgCells.unlocked:
		return false
	if option == "background" and choice == "4" and not Unlocks.items.bgStars.unlocked:
		return false
	if option == "background" and choice == "5" and not Unlocks.items.bgSoup.unlocked:
		return false
	if option == "background" and choice == "6" and not Unlocks.items.bgRipple.unlocked:
		return false
	if option == "musicTrack" and choice == "chill" and not Unlocks.items.musicChill.unlocked:
		return false
	if option == "musicTrack" and choice == "break" and not Unlocks.items.musicBreak.unlocked:
		return false
	if option == "fakeWindowTheme" and choice == "window_win98" and not Unlocks.items.windowWin98.unlocked:
		return false
	if option == "fakeWindowTheme" and choice == "window_winxp" and not Unlocks.items.windowWinXP.unlocked:
		return false
	if option == "fakeWindowTheme" and choice == "window_vaporwave" and not Unlocks.items.windowVaporwave.unlocked:
		return false
	if option == "fakeWindowTheme" and choice == "window_cute" and not Unlocks.items.windowCute.unlocked:
		return false
	if option == "customCursor" and choice == "flamesword" and not Unlocks.items.cursorSword.unlocked:
		return false
	return true
func saveData():
	var file = FileAccess.open("user://unlocks.res", FileAccess.WRITE)
	var data = {}
	for key in items.keys():
		if items[key].unlocked:
			data[key] = items[key].unlocked
	file.store_line(JSON.stringify(data))
var loadedData := {}
func loadData(force := false):
	if loadedData:
		return
	var file = FileAccess.open("user://unlocks.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_line())
	if data:
		loadedData = data
		for key in data.keys():
			if items.has(key):
				items[key].unlocked = data[key]
func _process(delta):
	if Global.inTitle:
		return
	timer += delta
	if timer > 0.05:
		Stats.updateRecords()
		update()
           extends Node
var updateTimer := 0.0
var superscript = [
	"¹",
	"²",
	"³",
	"⁴",
	"⁵",
	"⁶",
	"⁷",
	"⁸",
	"⁹",
	"⁹⁺",
]
var smileyEmojis = {
	left = ["👈", "🤛", "🫷", "✋", "🫲", ],
	right = ["👉", "🤜", "🫸", "🤚", "🫱", "👇", "👆", ],
	face = ["🙂", "☺", "😀", "😃", "😄", "😁", "😠", "😵", "😖", "🙃", "😋" ],
	faceUltra = ["😡", "😈", "🫥", "👽", "💀", ],
}
var curSmileyEmoji := ""
var curUltraSmileyEmoji := ""
var bossList = {}
func _ready():
	DiscordSDK.app_id = 1196222994784198818
	process_mode = Node.PROCESS_MODE_ALWAYS
	update()
func _process(delta):
	updateTimer -= 1.0 * delta
	if updateTimer <= 0.0:
		updateTimer = 3.0
		update()
func update():
	var detailText = ""
	var stateText = ""
	if Global.inTitle:
		detailText = "In menu"
	else:
		bossList.clear()
		for b in get_tree().get_nodes_in_group("boss_main"):
			var bossName = b.get_meta("boss_name", "")
			var emoji = b.get_meta("emoji", "")
			if bossName != "":
				if not bossList.has(bossName):
					bossList[bossName] = {count=0, emoji=emoji}
				bossList[bossName].count += 1
		var hasSmiley := false
		var hasUltraSmiley := false
		for bossName in bossList.keys():
			var entry = bossList[bossName]
			if entry.emoji != "":
				var num = ""
				var emoji = entry.emoji
				if bossName == "smiley":
					hasSmiley = true
					if curSmileyEmoji == "":
						curSmileyEmoji = smileyEmojis.left.pick_random() + smileyEmojis.face.pick_random() + smileyEmojis.right.pick_random()
					emoji = curSmileyEmoji
				elif bossName == "ultra smiley":
					hasUltraSmiley = true
					if curUltraSmileyEmoji == "":
						curUltraSmileyEmoji = smileyEmojis.left.pick_random() + smileyEmojis.faceUltra.pick_random() + smileyEmojis.right.pick_random()
					emoji = curUltraSmileyEmoji
				if entry.count > 1:
					if entry.count > 9:
						num = superscript.back()
					else:
						num = superscript[entry.count-1]
				detailText += emoji + num + " "
		if not hasSmiley:
			curSmileyEmoji = ""
		if not hasUltraSmiley:
			curUltraSmileyEmoji = ""
		stateText += "🟣" + str(floor(Global.coins))
		stateText += " ✨" + str(floor(Global.tokens))
		if Players.hasCheat:
			stateText += (" 💚" if Global.health > 0 else " ☠️") + str(floor(Global.health))
		else:
			stateText += (" 💚" if Global.health > 0 else " ☠️") + str(floor(Global.health)) + "/" + str(floor(Global.maxHealth))
		stateText += " 【" + str(floor(Global.peer)) + " " + str(floor(Global.drain)) + " " + str(floor(Global.abilityCount)) + "】"
	DiscordSDK.details = detailText
	DiscordSDK.state = stateText
	DiscordSDK.large_image = "cover5"
	if not Global.inTitle:
		var char = Players.charData[Players.details[0].char]
		DiscordSDK.small_image = char.internalName
		DiscordSDK.small_image_text = char.displayName
		if Players.timedMode:
			DiscordSDK.end_timestamp = int(Time.get_unix_time_from_system() - Global.gameTime + Global.timedModeLimit)
		else:
			DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system() - Global.gameTime)
	if (DiscordSDK.get_is_discord_working()):
		DiscordSDK.refresh()
          extends Node
func _ready() -> void:
	pass
func  _process(_delta) -> void:
	DiscordSDK.run_callbacks()
          extends Node
enum Type {
	int,
	float,
	time
}
const _INF = "N/A"
var _defaultStats := {}
var stats := {
	totalCoins = 0,
	totalTokens = 0,
	totalTime = 0.0,
	totalBulletsFired = 0,
	totalEnemiesKilled = 0,
	totalBossesKilled = 0,
	totalDamageTaken = 0,
	totalShopPurchases = 0,
	totalShopItems = 0,
	totalManifests = 0,
	
	totalAttempts = 0,
	
	ultraSmileyDamage = 0,
	winTime = _INF,
	bastionChallengeTime = 0,
}
var metaStats := {
	totalCoins = 0,
	totalTokens = 0,
	totalTime = 0.0,
	totalBulletsFired = 0,
	totalEnemiesKilled = 0,
	totalBossesKilled = 0,
	totalDamageTaken = 0,
	totalShopPurchases = 0,
	totalShopItems = 0,
	totalManifests = 0,
	
	totalAttempts = 0,
	
	totalSpikersKilled = 0,
	totalWyrmsKilled = 0,
	totalSlimesKilled = 0,
	totalSmileysKilled = 0,
	totalUltraSmileysKilled = 0,
	totalOrbsKilled = 0,
	
	highestMultiShot = 0,
	highestHalt = 0,
	highestHealth = 0,
	highestTotalCoins = 0,
	highestTokens = 0,
	highestMultiplier = 0,
	
	bestTimedModeTime = 0.0,
	bestBastionChallengeTime = 0.0,
	totalZephyrOrbKills = 0,
	highestValueCoin = 0,
	totalMimicsCollected = 0,
	lowestUltraSmileyDamage = _INF,
}
var records := {}
var statData := {
	totalTime = {
		type = Type.time,
	},
	winTime = {
		type = Type.time,
		dir = -1,
		default = _INF,
		requirement = (func():
			return Global.ultraWin
			)
	},
	ultraSmileyDamage = {
		dir = -1,
		default = _INF,
		requirement = (func():
			return Global.ultraWin
			)
	},
}
var defaultStatData := {
	type = Type.float,
	dir = 1,
	default = 0
}
func _ready():
	if _defaultStats.is_empty():
		for s in stats.keys():
			_defaultStats[s] = stats[s]
func _resetStats():
	stats = _defaultStats.duplicate()
func getRecord(statName:String, criteria := {}):
	if not records.has(statName):
		return 0
	var record = records[statName]
	var val = 0
	var dir = 1
	if statData.has(statName):
		if statData[statName].has("default"):
			val = statData[statName].default
		if statData[statName].has("dir"):
			dir = statData[statName].dir
	if criteria.has("mode") and criteria.has("char"):
		var charName = Players.charNames[criteria.char]
		if record.has(criteria.mode) and record[criteria.mode].has(charName):
			return record[criteria.mode][charName]
		else:
			return val
	elif criteria.has("mode"):
		if record.has(criteria.mode):
			var modeRecord = record[criteria.mode]
			for charName in modeRecord.keys():
				if statName == "totalAttempts":
					val += modeRecord[charName]
				else:
					if modeRecord[charName] is String and modeRecord[charName] == _INF:
						pass
					elif val is String and val == _INF:
						val = modeRecord[charName]
					else:
						val = Utils.maxDir(val, modeRecord[charName], dir)
		return val
	elif criteria.has("char"):
		var charName = Players.charNames[criteria.char]
		if record.has("timed"):
			if record["timed"].has(charName):
				if val is String and val == _INF:
					val = record["timed"][charName]
				else:
					val = Utils.maxDir(val, record["timed"][charName], dir)
		if record.has("endless"):
			if record["endless"].has(charName):
				if val is String and val == _INF:
					val = record["endless"][charName]
				else:
					val = Utils.maxDir(val, record["endless"][charName], dir)
		return val
	return record.all
func getRecordString(statName:String, criteria := {}):
	var type = Type.float
	var default = 0
	var data = defaultStatData.duplicate()
	if statData.has(statName):
		data.merge(statData.get(statName, {}), true)
		type = data.type
		default = data.default
	if not records.has(statName):
		return str(default)
	var val = getRecord(statName, criteria)
	if type == Type.time and not val is String:
		return Utils.hms(val, 2)
	return str(val)
func hasStat(statName:String, meta := false):
	if meta:
		return metaStats.has(statName)
	else:
		return stats.has(statName)
func getStatString(statName:String, meta := false):
	var val = 0
	if meta:
		if not metaStats.has(statName):
			return "0"
		val = metaStats[statName]
	else:
		if not stats.has(statName):
			return "0"
		val = stats[statName]
	var type = Type.float
	if statData.has(statName):
		if statData[statName].has("type"):
			type = statData[statName].type
	if type == Type.time and not val is String:
		return Utils.hms(val, 2)
	return str(val)
func updateRecords():
	updateMetaStats()
	for statName in stats.keys():
		var data = defaultStatData.duplicate()
		data.merge(statData.get(statName, {}), true)
		var record:Dictionary = records.get_or_add(statName, {
			all = data.default
		})
		if data.has("requirement"):
			if not data.requirement.call():
				continue
		var mode := "timed" if Players.timedMode else "endless"
		var modeRecord = record.get_or_add(mode, {})
		var char = "multiplayer" if Players.inMultiplayer else Players.charNames[Players.details[0].char]
		var curRecord = modeRecord.get_or_add(char, stats[statName])
		if statName == "totalAttempts":
			modeRecord[char] += Global.attemptCounter
			record.all += Global.attemptCounter
			Global.attemptCounter = 0
		else:
			if curRecord is String and curRecord == _INF:
				pass
			elif record.all is String and record.all == _INF:
				modeRecord[char] = stats[statName]
				record.all = stats[statName]
			else:
				if data.dir > 0:
					modeRecord[char] = max(curRecord, stats[statName])
					record.all = max(record.all, stats[statName])
				else:
					modeRecord[char] = min(curRecord, stats[statName])
					record.all = min(record.all, stats[statName])
func updateMetaStats():
	metaStats.highestMultiShot = max(metaStats.highestMultiShot, Global.multiShot)
	metaStats.highestHalt = max(metaStats.highestHalt, Global.halt)
	metaStats.highestHealth = max(metaStats.highestHealth, Global.health)
	metaStats.highestTotalCoins = max(metaStats.highestTotalCoins, stats.totalCoins)
	metaStats.highestTokens = max(metaStats.highestTokens, Global.tokens)
	metaStats.highestMultiplier = max(metaStats.highestMultiplier, Global.multiplyStack)
	if Global.ultraWin:
		if metaStats.lowestUltraSmileyDamage is String and metaStats.lowestUltraSmileyDamage == _INF:
			metaStats.lowestUltraSmileyDamage = stats.ultraSmileyDamage
		else:
			metaStats.lowestUltraSmileyDamage = min(metaStats.lowestUltraSmileyDamage, stats.ultraSmileyDamage)
	if Players.timedMode:
		metaStats.bestTimedModeTime = max(metaStats.bestTimedModeTime, Global.gameTime)
	metaStats.bestBastionChallengeTime = max(metaStats.bestBastionChallengeTime, stats.bastionChallengeTime)
var loadedData := {}
func saveData():
	var file = FileAccess.open("user://stats.res", FileAccess.WRITE)
	var data = {
		stats = stats,
		metaStats = metaStats,
		records = records,
	}
	loadedData = data
	file.store_line(JSON.stringify(data))
func loadData(force := false):
	if loadedData and not force:
		return
	var file = FileAccess.open("user://stats.res", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_line())
	if data:
		loadedData = data
		if data.has("records"):
			records.merge(data.records, true)
		if data.has("metaStats"):
			metaStats.merge(data.metaStats, true)
    extends Node
var linux := false
var safeMode := false
var forceFakeWindows := false
var focusedInput := false
  list=Array[Dictionary]([{
"base": &"Node",
"class": &"DiscordSDKTutorial",
"icon": "",
"language": &"GDScript",
"path": "res://addons/discord-sdk-gd/example.gd"
}, {
"base": &"RefCounted",
"class": &"JSONSchema",
"icon": "",
"language": &"GDScript",
"path": "res://addons/JSON_Schema_Validator/json_schema_validator.gd"
}, {
"base": &"Resource",
"class": &"ModConfig",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/mod_config.gd"
}, {
"base": &"Resource",
"class": &"ModData",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/mod_data.gd"
}, {
"base": &"Object",
"class": &"ModLoaderConfig",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/config.gd"
}, {
"base": &"Resource",
"class": &"ModLoaderCurrentOptions",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/options_current.gd"
}, {
"base": &"Node",
"class": &"ModLoaderDeprecated",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/deprecated.gd"
}, {
"base": &"Node",
"class": &"ModLoaderLog",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/log.gd"
}, {
"base": &"Object",
"class": &"ModLoaderMod",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/mod.gd"
}, {
"base": &"RefCounted",
"class": &"ModLoaderModManager",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/mod_manager.gd"
}, {
"base": &"Resource",
"class": &"ModLoaderOptionsProfile",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/options_profile.gd"
}, {
"base": &"RefCounted",
"class": &"ModLoaderSetupLog",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/setup/setup_log.gd"
}, {
"base": &"RefCounted",
"class": &"ModLoaderSetupUtils",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/setup/setup_utils.gd"
}, {
"base": &"Object",
"class": &"ModLoaderUserProfile",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/api/profile.gd"
}, {
"base": &"Node",
"class": &"ModLoaderUtils",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/mod_loader_utils.gd"
}, {
"base": &"Resource",
"class": &"ModManifest",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/mod_manifest.gd"
}, {
"base": &"Resource",
"class": &"ModUserProfile",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/resources/mod_user_profile.gd"
}, {
"base": &"Window",
"class": &"TitleWindow",
"icon": "",
"language": &"GDScript",
"path": "res://src/title/panel/TitleWindow.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderCLI",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/cli.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderCache",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/cache.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderDependency",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/dependency.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderFile",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/file.gd"
}, {
"base": &"Object",
"class": &"_ModLoaderGodot",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/godot.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderPath",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/path.gd"
}, {
"base": &"RefCounted",
"class": &"_ModLoaderScriptExtension",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/script_extension.gd"
}, {
"base": &"Node",
"class": &"_ModLoaderSteam",
"icon": "",
"language": &"GDScript",
"path": "res://addons/mod_loader/internal/third_party/steam.gd"
}])
  <svg width="44" height="44" viewBox="0 0 44 44" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_367_178)">
<path d="M22 38C30.8366 38 38 30.8366 38 22C38 13.1634 30.8366 6 22 6C13.1634 6 6 13.1634 6 22C6 30.8366 13.1634 38 22 38Z" stroke="black" stroke-width="12"/>
<path d="M22 38C30.8366 38 38 30.8366 38 22C38 13.1634 30.8366 6 22 6C13.1634 6 6 13.1634 6 22C6 30.8366 13.1634 38 22 38Z" stroke="white" stroke-width="4"/>
</g>
<defs>
<clipPath id="clip0_367_178">
<rect width="44" height="44" fill="white"/>
</clipPath>
</defs>
</svg>
              7  v�5�"T-   res://addons/discord-sdk-gd/Logo_V2_No_Bg.png�,��q�((   res://modded/coolmod/sprinter/curve.tres{�aJ�=�&*   res://modded/coolmod/sprinter/sprinter.pngM7J��M+   res://modded/coolmod/sprinter/sprinter.tscn�3a�~�8   res://modres/OMenemy_example_01/enemies/ghost/curve.tres��j�JY^7   res://modres/OMenemy_example_01/enemies/ghost/ghost.scnP�o��qwd7   res://modres/OMenemy_example_01/enemies/ghost/ghost.svg�'v��?=   res://modres/OMenemy_example_01/enemies/ghost/ghost_white.png�I%�jn2?   res://modres/OMenemy_example_01/enemies/star_shooter/curve.tres/bFc�z=   res://modres/OMenemy_example_01/enemies/star_shooter/star.svg*Ww�E   res://modres/OMenemy_example_01/enemies/star_shooter/star_shooter.scn�ؔ��J�/%   res://modded/example_enemies/icon.png56��[<   res://modded/modUtils/icon.png󽸴;v[/   res://modded/testmod/cursors/epic-crosshair.png[ڸ1��YD'   res://modded/testmod/shooter/curve.tres���V�;^(   res://modded/testmod/shooter/shooter.pngƌ~��mM)   res://modded/testmod/shooter/shooter.tscn>՞�B�@   res://modres/OMenemy_example_01/bosses/starco/star/Risorsa 9.svg��%����EB   res://modres/OMenemy_example_01/bosses/starco/star/starco_star.scn��ت�E<   res://modres/OMenemy_example_01/bosses/starco/Risorsa 10.svgr���-�q8   res://modres/OMenemy_example_01/bosses/starco/starco.scnI}?���U@   res://modres/OMenemy_example_01/characters/mod-archer/archer.scn�'�ᢀ>   res://modres/OMenemy_example_01/characters/mod-archer/back.png�CL���j@   res://modres/OMenemy_example_01/characters/mod-archer/curve.tres��v���c=   res://modres/OMenemy_example_01/characters/mod-archer/top.png��I+N�+    res://src/element/coin/coin.tscnFV} �aN'   res://src/element/drain/drainShield.png+ij`�)   res://src/element/drain/img.png�L!ɅD$   res://src/element/enemy_worm/img.png�k)��2   res://src/element/goal/sun.pngBT�]�(-   res://src/element/power_token/powerToken.tscng�N.��dY    res://src/enemy/boss1/boss1.tscn�9	��>0   res://src/enemy/boss_snake/bossSnakeSegment.tscnAZL�+   res://src/enemy/boss_virus/angry_shadow.png�vbn�� |*   res://src/enemy/boss_virus/dead_shadow.png
{(��**   res://src/enemy/boss_virus/fist_shadow.pngێ ��6*   res://src/enemy/boss_virus/grin_shadow.png�v����E**   res://src/enemy/boss_virus/halt_shadow.png<v�и��'+   res://src/enemy/boss_virus/happy_shadow.png>��p~�*   res://src/enemy/boss_virus/hurt_shadow.png�UO 3
y*   res://src/enemy/boss_virus/palm_shadow.png-z��i!�l+   res://src/enemy/boss_virus/point_shadow.png]�5)�0+   res://src/enemy/boss_virus/smile_shadow.png�o��e$   res://src/enemy/hexagon/hexagon.tscn^k4�M�v&   res://src/enemy/triangle/triangle.tscn-��]�	I1(   res://src/enemy/tunneller/tunneller.tscn�<'��LA   res://src/main/main.tscn�d&>4!   res://src/particle/ring/glow2.png�N_p�B?b    res://src/particle/ring/glow.png#������q!   res://src/particle/ring/ring2.png� ��"?!   res://src/particle/ring/ring3.png��8 n(!   res://src/particle/ring/ring4.pngg�`;tw    res://src/particle/ring/ring.png#����m�A(   res://src/particle/scorch/scorchLine.pngT���>+   res://src/particle/scorch/scorchLineBig.png�}�Y�m8~!   res://src/player/basic/basic.tscn��M_/PD%   res://src/player/basic/spawnRate.tresO�q$��x   res://src/player/mage/ring.png�!X��5�#   res://src/player/mage/ringCrowd.png4M�ПF�N!   res://src/player/pointer/area.pngڡ8�<h#   res://src/player/pointer/finger.png�i�	=�;&   res://src/player/skins/crown/crown.png�"q���1-   res://src/player/skins/hector/lineTexture.pngSE9�G�R)   res://src/player/skins/hector/preview.pngMi��΄U'   res://src/player/bubbleBig.png�Y���*�/    res://src/player/bubbleSmall.pngf�xm�3K   res://src/player/teehee.pngu鎁�:   res://src/sounds/absorb.oggߺ�dL�R   res://src/sounds/bellow.ogg38����`G!   res://src/sounds/bellowWhoosh.ogg1��\u�   res://src/sounds/bossDie.ogg��dV��!   res://src/sounds/breakWindow2.ogg�ya�
y    res://src/sounds/breakWindow.ogg��!���   res://src/sounds/bubble.ogg�����?�
!   res://src/sounds/buttonHover2.ogg�<��?m    res://src/sounds/buttonHover.ogg��!����~#   res://src/sounds/buttonUnhover2.ogg�F�F��8-"   res://src/sounds/buttonUnhover.ogg�7����   res://src/sounds/buy.oggvǖ�'n�"   res://src/sounds/camera.ogg^9�~�p�k!   res://src/sounds/chargeAttach.ogg��Z��D7{    res://src/sounds/chargeDrill.ogg�BUJ"�`S   res://src/sounds/chargeFire.oggQ^�K_dK   res://src/sounds/chargeMax.oggrC!L<=>p   res://src/sounds/chargeUp.ogg)��yW�R   res://src/sounds/click2.oggA�����    res://src/sounds/clickOff.ogg�吣gfl%   res://src/sounds/clickOn.ogg�ST�;�	   res://src/sounds/coin1.ogge��~�^q   res://src/sounds/coin2.ogg�j*���}o   res://src/sounds/coin3.ogg;Ǐ0��S   res://src/sounds/coin4.ogg��e�ݤd   res://src/sounds/coin5.ogg[<�w)3.   res://src/sounds/danger.ogg���U�%   res://src/sounds/ding.ogg"�}y!?   res://src/sounds/enemyDie.ogg��;L�C�    res://src/sounds/enemyShoot2.oggd�NGvx1~    res://src/sounds/enemyShoot3.ogg�n�a��    res://src/sounds/enemyShoot4.ogg���D�S    res://src/sounds/enemyShoot5.ogg�����>   res://src/sounds/enemyShoot.ogg��`�k�!   res://src/sounds/finalBossHit.ogg�=��^ �"   res://src/sounds/finalBossKill.ogg�M��uIw'   res://src/sounds/focus.ogg
-u�^_�T   res://src/sounds/heal.ogg�L^��H�S   res://src/sounds/hit3.ogg��=J�+   res://src/sounds/hitWall2.ogg�Y���%   res://src/sounds/hitWall.ogg5��j�2   res://src/sounds/jackpot.ogg5�Q��Z;   res://src/sounds/knock.oggqDE�X��p   res://src/sounds/laser.ogg?���d4�T   res://src/sounds/laserBlink.oggO��%�&   res://src/sounds/laserLoop.ogg�a�ǹv6!   res://src/sounds/laserLoopEnd.ogg(�^@b{VY   res://src/sounds/musicBreak.ogg:��+{"f   res://src/sounds/musicChill.ogg�#�pG��&    res://src/sounds/musicJungle.oggn�F���qy   res://src/sounds/musicMenu.ogg|H`��=$   res://src/sounds/obliterate.ogg⏒vX��   res://src/sounds/peer.ogg���x\�E   res://src/sounds/playerHit.ogg��+\y�B   res://src/sounds/poison.ogg�+��X��Y   res://src/sounds/pop.ogg0�]1�J�t   res://src/sounds/pound.oggj{+�[
   res://src/sounds/refresh.oggIe_���"   res://src/sounds/refreshSingle.oggu3غ:[@   res://src/sounds/restock.ogg$)���zz   res://src/sounds/rumble.ogg+$ ��R�n   res://src/sounds/shoot2.ogg��}�S�Z   res://src/sounds/shopClose.ogg����Rs   res://src/sounds/shopOpen.ogg��;�(�h    res://src/sounds/shuffleDown.ogge�-Dp��a   res://src/sounds/shuffleUp.ogg\���:   res://src/sounds/slime1.oggƁ]��(   res://src/sounds/slime2.ogg��k�mh   res://src/sounds/slime3.ogg��%{���!   res://src/sounds/slimeBounce1.ogg�,{��9R!   res://src/sounds/slimeBounce2.ogg�8 �+O?k!   res://src/sounds/slimeBounce3.ogg(�����B    res://src/sounds/slimeBounce.oggZ�6�l\�b   res://src/sounds/token.ogg�ڲ���41    res://src/sounds/tokenBounce.ogg��2��u   res://src/sounds/unlock.oggV��HJf�5   res://src/sounds/upgrade.oggv{��D�+b   res://src/sounds/virusClick.ogg�K�Kz�a   res://src/sounds/virusHurt.ogg��9�VC%    res://src/sounds/virusShield.ogg���*���2#   res://src/sounds/virusShieldOff.oggI�T�6]n   res://src/sounds/whoosh2.ogg��@
$1Q\   res://src/sounds/win.ogg���tŒ)!   res://src/sounds/windowBounce.ogg��:��<{    res://src/sounds/windowClose.ogg�g�����   res://src/sounds/windowOpen.oggѥ����W    res://src/sounds/windowPunch.oggm,��d	    res://src/sounds/windowThrow.oggbcm�'p;    res://src/sounds/windowWind2.ogg��HfLv\   res://src/sounds/windowWind.oggo���"h�   res://src/sounds/windowZip.ogg��hZJ�"   res://src/sounds/winError.oggK}�\W   res://src/sounds/wormWalk.oggܶk>-p"   res://src/title/bg_icons/blank.png�YK:��	    res://src/title/panel/blank.tscncϑ{���
$   res://src/title/panel/character.tscnk�JW5�8"   res://src/title/panel/endless.tscns^*y�K"   res://src/title/panel/options.tscn�o.½�q   res://src/title/title.tscn�����   res://src/ui/button/button.tscn����9G�1"   res://src/ui/button/colorFrame.png��i��~+U&   res://src/ui/button/colorFrameFull.png��BBB;xp-   res://src/ui/coin_count/powerTokenIconBig.png��`M�z=    res://src/ui/control/slider.tscn7IR�g�W&   res://src/ui/control/toggleButton.tscnWC#s�{�/%   res://src/ui/cursors/flamesword/1.png ��N���*%   res://src/ui/cursors/flamesword/2.png������{%   res://src/ui/cursors/flamesword/3.png{��i���"%   res://src/ui/cursors/flamesword/4.pngB.rt���l.   res://src/ui/cursors/flamesword/flamesword.pngU��3OY(   res://src/ui/cursors/crosshair-color.png�&x���!"   res://src/ui/cursors/crosshair.png������s$   res://src/ui/cursors/frame-color.png�!��A�|   res://src/ui/cursors/frame.png�Z��9�#   res://src/ui/cursors/ring-color.pngÆ�{�(   res://src/ui/cursors/ring.png�4�_6�x   res://src/ui/cursors/simple.pngW�T��L9   res://src/ui/multiplayer/input_option/conflictOutline.pngj0�V��z>   res://src/ui/multiplayer/input_option/conflictOutlineSmall.pngU��/��
1   res://src/ui/multiplayer/input_option/waiting.png=�:F��S%   res://src/ui/options/tab/display.tscn�Ff�|w>%   res://src/ui/options/tab/general.tscnc�Ql�I�G    res://src/ui/options/option.tscn�'�ղɊ!   res://src/ui/options/options.tscnlN��[   res://src/ui/shop/echoFrame.png���   res://src/ui/shop/shop.tscn��Ko�x   res://src/ui/shop/shopArrow.png�T�-�$�>&   res://src/ui/unlocks/icons/bgCells.png�l�/��X%   res://src/ui/unlocks/icons/bgGrid.png�wcԚ+'   res://src/ui/unlocks/icons/bgRipple.pngcO\OB��v%   res://src/ui/unlocks/icons/bgSoup.png`L	q#��`&   res://src/ui/unlocks/icons/bgStars.pngeTzZn,   res://src/ui/unlocks/icons/bgTransparent.png�����͆*   res://src/ui/unlocks/icons/cursorSword.pngo�7"|nR(   res://src/ui/unlocks/icons/skinCrown.png�~�a�_)   res://src/ui/unlocks/icons/skinHector.png��\�L��n)   res://src/ui/unlocks/icons/windowCute.pngC	��^.   res://src/ui/unlocks/icons/windowVaporwave.png��)��r}*   res://src/ui/unlocks/icons/windowWin98.png��@��*   res://src/ui/unlocks/icons/windowWinXP.png0؆�}   res://src/ui/unlocks/censor.pngؾ���{%.   res://src/ui/upgrade_shop/upgradeShopItem.tscnf��zɏ�/   res://src/ui/window_themes/cute/windowClose.png���P9�34   res://src/ui/window_themes/cute/windowClosePress.png��e0�G2   res://src/ui/window_themes/cute/windowControls.png5�%Q��./   res://src/ui/window_themes/cute/windowFrame.png��P	�F4   res://src/ui/window_themes/cute/windowFrameFocus.png�v��g})   res://src/ui/window_themes/torc/title.ttf`v��"�Z/   res://src/ui/window_themes/torc/windowClose.png��>Sq4   res://src/ui/window_themes/torc/windowClosePress.png���3�i�22   res://src/ui/window_themes/torc/windowControls.png�1�g6.   res://src/ui/window_themes/torc/windowIcon.png��5���@1   res://src/ui/window_themes/ubuntu/windowClose.pngn���-'6   res://src/ui/window_themes/ubuntu/windowClosePress.png�ǧ� �o4   res://src/ui/window_themes/ubuntu/windowControls.pngMB���Y	1   res://src/ui/window_themes/ubuntu/windowFrame.png�9�( >0   res://src/ui/window_themes/ubuntu/windowIcon.pngn�^��K44   res://src/ui/window_themes/vaporwave/windowClose.png_���&P�b9   res://src/ui/window_themes/vaporwave/windowClosePress.png�H��ˤ�R7   res://src/ui/window_themes/vaporwave/windowControls.png���>�)4   res://src/ui/window_themes/vaporwave/windowFrame.png����=   res://src/ui/window_themes/vaporwave/windowFrameUnfocused.pngZ�I�D�F/   res://src/ui/window_themes/win7/windowClose.png���Eesm6   res://src/ui/window_themes/win7/windowClosePressed.png+?:=G2   res://src/ui/window_themes/win7/windowControls.png��d�gqd.   res://src/ui/window_themes/win7/windowIcon.pngw�7� /   res://src/ui/window_themes/win8/windowClose.pngZ����qq4   res://src/ui/window_themes/win8/windowClosePress.png�z���3�2   res://src/ui/window_themes/win8/windowControls.pngR�k xU�).   res://src/ui/window_themes/win8/windowIcon.png*!�a`="0   res://src/ui/window_themes/win10/windowClose.png9!�f5   res://src/ui/window_themes/win10/windowClosePress.png��ORv��M3   res://src/ui/window_themes/win10/windowControls.png����q�Lx*   res://src/ui/window_themes/win11/title.ttf�V����Ey0   res://src/ui/window_themes/win11/windowClose.png=^�a1D5   res://src/ui/window_themes/win11/windowClosePress.png�|����33   res://src/ui/window_themes/win11/windowControls.png~{��}��y0   res://src/ui/window_themes/win98/windowClose.png�f岂�)5   res://src/ui/window_themes/win98/windowClosePress.pngoy��Y3   res://src/ui/window_themes/win98/windowControls.pngO���n�}0   res://src/ui/window_themes/win98/windowFrame.png�%\ށ�~,9   res://src/ui/window_themes/win98/windowFrameUnfocused.png�)�jE0   res://src/ui/window_themes/winxp/windowClose.png��US"5   res://src/ui/window_themes/winxp/windowClosePress.png��D��83   res://src/ui/window_themes/winxp/windowControls.png�Q�����T1   res://src/ui/window_themes/winxp/windowFrame2.pngq�7���f0   res://src/ui/window_themes/winxp/windowFrame.pngl�Je� =)   res://src/ui/window_themes/windowIcon.png�HM8��l   res://src/ui/arialbd.ttf�2����#   res://src/ui/Baloo-Bhaijaan-2.woff2m4V3�I�;$   res://src/ui/blogger-sans.medium.ttf�f���Jm\   res://src/ui/comfortaa-bold.ttf%8���K'   res://src/ui/Jiangcheng-Yuanti-600W.ttf#9�$�h##   res://src/ui/NanumSquareRoundEB.ttf�}��ޏh   res://src/ui/Quicksand-Bold.ttfc�D��O   res://src/ui/round-fallback.ttf'8���a�8   res://src/ui/SEGOEUIB.TTF�2���<   res://src/ui/theme.tres��F���=   res://src/ui/timer.png^����B!   res://src/1px.pngC�ᦂ��}   res://src/2px.png���9&�9   res://src/iconicon.svgܱ7�vt3   res://src/iconicon_raw.svg��qӋ��4   res://src/iconsmile.svgI��:   res://src/img.png���Ǐr�T%   res://translation/base.ar.translation�}�ֵ��%   res://translation/base.bg.translation��%   res://translation/base.cs.translationJ�O�%   res://translation/base.de.translationc�.�BL%   res://translation/base.en.translationҖ�KE�p%   res://translation/base.es.translation�]C��f�(   res://translation/base.es_MX.translation�@��X��9&   res://translation/base.fil.translation*�l��=%   res://translation/base.fr.translation� �/�%   res://translation/base.hu.translationw<��&,%   res://translation/base.it.translation�-	W%   res://translation/base.ja.translation�|�N�L%   res://translation/base.ko.translation	3]L.�{%   res://translation/base.nl.translation�B��	��A%   res://translation/base.pl.translation�o����-%   res://translation/base.pt.translation`׫��t7(   res://translation/base.pt_BR.translation�hZ�NS,%   res://translation/base.ru.translation�!�u39�%   res://translation/base.si.translationaѵX�T %   res://translation/base.sl.translation���#�q(   res://translation/base.smile.translation|T�U0�X%   res://translation/base.vi.translationTt=�駄](   res://translation/base.zh_CN.translation��)�Չ(   res://translation/base.zh_TW.translationɃ�e}�e   res://default_bus_layout.tres&��5>�8   res://src/player/player.tscnv�5�"T-   res://addons/discord-sdk-gd/Logo_V2_No_Bg.png�3a�~�8   res://modres/OMenemy_example_01/enemies/ghost/curve.tres��j�JY^7   res://modres/OMenemy_example_01/enemies/ghost/ghost.scnP�o��qwd7   res://modres/OMenemy_example_01/enemies/ghost/ghost.svg�'v��?=   res://modres/OMenemy_example_01/enemies/ghost/ghost_white.png�I%�jn2?   res://modres/OMenemy_example_01/enemies/star_shooter/curve.tres/bFc�z=   res://modres/OMenemy_example_01/enemies/star_shooter/star.svg*Ww�E   res://modres/OMenemy_example_01/enemies/star_shooter/star_shooter.scnI}?���U<   res://modres/OMenemy_example_01/characters/archer/archer.scn�'�ᢀ:   res://modres/OMenemy_example_01/characters/archer/back.png�CL���j<   res://modres/OMenemy_example_01/characters/archer/curve.tres��v���c9   res://modres/OMenemy_example_01/characters/archer/top.png�-	W%   res://translation/base.ja.translation     res://addons/discord-sdk-gd/bin/discord-rpc-gd.gdextension
res://addons/godotsteam/godotsteam.gdextension
      ECFGn      application/config/name      
   windowkill     application/config/version         3.1.2a     application/run/main_scene$         res://src/title/title.tscn     application/config/features$   "         4.3    Forward Plus        application/boot_splash/bg_color                    �?   application/config/icon          res://src/iconicon.svg     autoload/Utils$         *res://src/autoload/utils.gd   autoload/Global(         *res://src/autoload/global.gd      autoload/TorCurve(         *res://src/autoload/torCurve.gd    autoload/Audio$         *res://src/autoload/audio.gd   autoload/RawInput(         *res://src/autoload/rawInput.gd    autoload/Game$         *res://src/autoload/game.gd    autoload/ShaderPreload,      $   *res://src/autoload/shaderPreload.gd   autoload/Controls(         *res://src/autoload/controls.gd    autoload/Events(         *res://src/autoload/events.gd      autoload/Players(         *res://src/autoload/players.gd     autoload/Focus$         *res://src/autoload/focus.gd   autoload/Unlocks(         *res://src/autoload/unlocks.gd     autoload/DiscordRpc,      "   *res://src/autoload/discord_rpc.gd     autoload/DiscordSDKLoader@      6   *res://addons/discord-sdk-gd/nodes/discord_autoload.gd     autoload/Stats$         *res://src/autoload/stats.gd   autoload/Meta$         *res://src/autoload/meta.gd    debug/settings/stdout/print_fps         "   display/window/size/viewport_width      h  #   display/window/size/viewport_height      h  )   display/window/size/initial_position_type         *   display/window/subwindows/embed_subwindows          -   display/window/per_pixel_transparency/allowed            display/window/vsync/vsync_mode             editor_plugins/enabled�   "      '   res://addons/discord-sdk-gd/plugin.cfg  .   res://addons/gdscript_preprocessor/plugin.cfg   $   res://addons/paste_image/plugin.cfg    gui/theme/custom          res://src/ui/theme.tres    input/ui_select�              deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed           script            InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           location          echo          script         input/ui_left@              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed           script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       ��   script         input/ui_right@              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed           script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       �?   script         input/ui_up@              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed           script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script         input/ui_down@              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed           script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/moveLeft\              deadzone  �������?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/ct_moveLeft�              deadzone  �������?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       ��   script         input/moveRight\              deadzone  �������?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/ct_moveRight�              deadzone  �������?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       �?   script         input/moveUp\              deadzone  �������?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/ct_moveUp�              deadzone  �������?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script         input/moveDown\              deadzone  �������?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/ct_moveDown�              deadzone  �������?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/shoot�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     	C  �A   global_position      C  �B   factor       �?   button_index         canceled          pressed          double_click          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   
      pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   	      pressure          pressed          script         input/ct_shoot�              deadzone      ?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   	      pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   
      pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script         input/reload�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   R   	   key_label             unicode    r      location          echo          script         input/debugVal�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   `   	   key_label             unicode           location          echo          script         input/rightclick�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     �C  �A   global_position      �C  �B   factor       �?   button_index         canceled          pressed          double_click          script         input/actionp              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     �C  PA   global_position      �C  TB   factor       �?   button_index         canceled          pressed          double_click          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/ct_action               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script      
   input/shop�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/perksx              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/options�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/debug�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   P   	   key_label             unicode           location          echo          script         input/debug1�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   I   	   key_label             unicode           location          echo          script         input/debug2�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   O   	   key_label             unicode           location          echo          script         input/ct_aimLeft�               deadzone  �������?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script         input/ct_aimRight�               deadzone  �������?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/ct_aimUp�               deadzone  �������?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script         input/ct_aimDown�               deadzone  �������?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script         input/keyboardInputH              deadzone      ?      events     	         InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/controllerInput�              deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       ��   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   	      pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index   
      pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script      
   input/walkX              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode    @ 	   key_label       @    unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/debugSpawn�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          button_mask          position     �C  �A   global_position      �C  �B   factor       �?   button_index         canceled          pressed          double_click          script         input/debugUltra�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   U   	   key_label             unicode           location          echo          script         input/debugInvlun�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   Y   	   key_label             unicode           location          echo          script         input/debugBoss�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   L   	   key_label             unicode           location          echo          script         input/debugSpeedup�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     -C  �?   global_position      1C  $B   factor       �?   button_index         canceled          pressed          double_click          script         input/debugClick�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   1   	   key_label             unicode    1      location          echo          script         input/debugClick2�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   2   	   key_label             unicode    2      location          echo          script         input/debugCrash�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   0   	   key_label             unicode           location          echo          script         input/uiAcceptAll               deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script         input/uiAccept�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script         input/uiCancel�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/shopLock�              deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/reorderWindows�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script         input/uiDenyX              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           location          echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/click�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     +C  �A   global_position      /C  xB   factor       �?   button_index         canceled          pressed          double_click          script         input/debug3�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed          shift_pressed            ctrl_pressed         meta_pressed          pressed           keycode           physical_keycode   T   	   key_label             unicode           location          echo          script         input/debug4�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed            ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   6   	   key_label             unicode    ^      location          echo          script         input/mouseInput�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     <C  �A   global_position      @C  tB   factor       �?   button_index         canceled          pressed          double_click          script         input/testest�              deadzone      ?      events              InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script      .   internationalization/locale/translation_remaps          (   internationalization/locale/translations�  "      &   res://translation/base.en.translation   &   res://translation/base.ar.translation   &   res://translation/base.bg.translation   &   res://translation/base.cs.translation   &   res://translation/base.de.translation   &   res://translation/base.es.translation   &   res://translation/base.fr.translation   &   res://translation/base.it.translation   &   res://translation/base.ja.translation   &   res://translation/base.ko.translation   &   res://translation/base.nl.translation   &   res://translation/base.pl.translation   &   res://translation/base.pt.translation   )   res://translation/base.pt_BR.translation    &   res://translation/base.ru.translation   )   res://translation/base.zh_CN.translation    )   res://translation/base.zh_TW.translation    '   res://translation/base.fil.translation  )   res://translation/base.smile.translation    &   res://translation/base.si.translation   &   res://translation/base.hu.translation   &   res://translation/base.vi.translation   .   internationalization/locale/locale_filter_mode          +   internationalization/locale/language_filter               ru  *   internationalization/locale/country_filter             layer_names/2d_physics/layer_1         wallCollide    layer_names/2d_physics/layer_2      
   wallDetect     layer_names/2d_physics/layer_3         pickup     layer_names/2d_physics/layer_5         player     layer_names/2d_physics/layer_6         bullet     layer_names/2d_physics/layer_7         enemyDetect    layer_names/2d_physics/layer_8         enemyCollide   layer_names/2d_physics/layer_9         wallEnemyDetect    layer_names/2d_physics/layer_10         wallEnemyCollide   layer_names/2d_physics/layer_11         enemyBullet    layer_names/2d_physics/layer_12         hazard     layer_names/2d_physics/layer_13         playerDetect   layer_names/2d_physics/layer_14         drainDetect    layer_names/2d_physics/layer_15      	   bossSlime      layer_names/2d_physics/layer_16      
   playerArea     layer_names/2d_physics/layer_17      
   playerPush     layer_names/2d_physics/layer_18      
   bulletKill  ,   rendering/gl_compatibility/fallback_to_angle          *   rendering/environment/ssao/adaptive_target        �?2   rendering/environment/defaults/default_clear_color                      )   rendering/viewport/transparent_background            shader_globals/GAME_TIME<               type      float         value                