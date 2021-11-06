extends CanvasLayer

const ItemDisplay := preload("res://Scenes/Characters/Player/ItemDisplay.tscn")

var items_to_node : Array = []

onready var item_display_parent := $M/H

# Returns true if the player has collected the given item_name.
func has_item(item_name : String) -> bool:
	for i in items_to_node:
		if i[0] == item_name and i[2]:
			return true
	return false

# Returns true if the player has collected all the items.
func has_all_items() -> bool:
	for i in items_to_node:
		if not i[2]:
			return false
	return true

# Adds item to HUD.
func add_item(item_data : Dictionary) -> void:
	var item_display = ItemDisplay.instance()
	item_display_parent.add_child(item_display)
	item_display.init(item_data.item_name, item_data.item_empty_icon, item_data.item_icon)
	items_to_node.append([item_data.item_name, item_display, false])

# Marks the given item_name as collected.
# Returns false if the given item_name is not in the HUD.
func collect_item(item_name : String) -> bool:
	for i in items_to_node:
		if i[0] == item_name and not i[2]:
			i[1].collect()
			i[2] = true
			return true
	return false

# Marks the given item_name as uncollected
# Returns false if the given item_name is not in the HUD.
func uncollect_item(item_name : String) -> bool:
	for i in items_to_node:
		if i[0] == item_name and i[2]:
			i[1].uncollect()
			i[2] = false
			return true
	return false
