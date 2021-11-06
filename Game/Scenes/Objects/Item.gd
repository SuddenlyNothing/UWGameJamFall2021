extends Area2D
class_name Item

export(String) var item_name : String = ""
export(Texture) var item_empty_icon : Texture
export(Texture) var item_icon : Texture

onready var item_info = {
	"item_name" : item_name,
	"item_empty_icon" : item_empty_icon,
	"item_icon" : item_icon
}

# Tell the player what items it needs so that it can display in the HUD
func _ready() -> void:
	get_tree().call_group("hud", "add_item", item_info)

# Frees this node and returns the item's info
func collect() -> Dictionary:
	queue_free()
	return item_info
