#Author: Hearto Lazor
#Replaces a color with another one using a mask.
#Tool page: https://github.com/HeartoLazor/godot_palette_swap
#Tested in Godot 3.0.3, Requires Godot >= 3.x
#If an inconsistency appears between Intel and Amd/Nvidia GPU, feel free to fix it and commit, 
#but take this as a warning for production use
extends AnimatedSprite
export(SpriteFrames) var color_mask = null
export(SpriteFrames) var palettes = null
export(int) var palette_index = 0 setget _set_palette_index
var palette_size = 0 setget _set_palette_size
var _shader_animation
var _label_fps
var _label_info

func _ready():
	_shader_animation = get_node("shader_animations")
	_label_fps = get_node("../hud/label_fps")
	_label_info = get_node("../hud/label_info")
	#StreamTexture doesn't have set_data method, so Change it to ImageTexture, used by random colors (last button)
	var image_texture = ImageTexture.new()
	var image = palettes.get_frame("default", 4).get_data()
	image_texture.create_from_image(image,0)
	image_texture.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	palettes.set_frame("default", 4, image_texture)
	var palette_reference = get_node("../hud/button_random_palette/palette_reference")
	palette_reference.texture = image_texture
	self.set_process(true)
	pass

#When the frame change, change the mask reference on the shader too
func _on_AnimatedSprite_frame_changed():
	if(color_mask != null && get_frame() < color_mask.get_frame_count("default")):
		get_material().set_shader_param("mask",color_mask.get_frame("default", get_frame()))

#If the palette index change, reflect the change on the shader and update the width of the new palette
func _set_palette_index(value):
	if(palettes != null && palette_index < palettes.get_frame_count("default")  && palette_index != value):
		palette_index = value
		var frame_mask = palettes.get_frame("default", palette_index)
		get_material().set_shader_param("palette",frame_mask)
		self.palette_size = frame_mask.get_width()

#Update the width of the palette
func _set_palette_size(value):
	if(palette_size != value):
		palette_size = value
		get_material().set_shader_param("palette_size",palette_size)

#From here code for demo UI management and animation
func _process(delta):
	_label_fps.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) )
	if(palettes != null):
		_label_info.set_text("PALETTE INDEX: " + str(palette_index) + " PALETTE ACTIVE TEXTURE: " + str(palettes.get_frame("default", palette_index)) + " | " + str(palette_size))

func _on_button_megaman_pressed():
	_shader_animation.play("megaman")

func _on_button_rush_pressed():
	_shader_animation.play("rush")


func _on_button_megaman_charged_pressed():
	_shader_animation.play("megaman_charged")


func _on_button_rush_charged_pressed():
	_shader_animation.play("rush_charged")

func _on_button_random_palette_pressed():
	var frame_mask = palettes.get_frame("default", 4)
	var image = frame_mask.get_data()
	image.lock()
	image.set_pixel(0,0,Color(randf(),randf(),randf()))
	image.set_pixel(1,0,Color(randf(),randf(),randf()))
	image.set_pixel(2,0,Color(randf(),randf(),randf()))
	image.unlock()
	frame_mask.set_data(image)
	_shader_animation.play("random")

