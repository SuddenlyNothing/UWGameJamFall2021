extends VBoxContainer

var empty_icon : Texture
var icon : Texture

onready var item_label := $ItemLabel
onready var item_texture := $ItemTexture

# Sets the label and icon
func init(item_name : String, item_empty_icon : Texture, item_icon : Texture) -> void:
	empty_icon = item_empty_icon
	icon = item_icon
	item_label.text = item_name
	item_texture.texture = item_empty_icon
	item_texture.modulate = Color.darkgray
	item_texture.modulate.a = 0.5

# Switches to item_icon
func collect() -> void:
	item_texture.modulate = Color.white
	item_texture.texture = icon
	item_texture.modulate.a = 1

# Switches to item_empty_icon
func uncollect() -> void:
	item_texture.modulate = Color.darkgray
	item_texture.texture = empty_icon
	item_texture.modulate.a = 0.5
