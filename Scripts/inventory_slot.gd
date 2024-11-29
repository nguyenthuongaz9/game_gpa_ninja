extends VBoxContainer

class_name InventorySlot

signal equip_item

var is_empty = true
var is_selected = true

@export var single_button_press = false
@export var starting_texture:Texture
@export var start_label:String

@onready var texture_rect = $NinePatchRect/MenuButton/CenterContainer/TextureRect
@onready var name_label = $NameLabel
@onready var stack_label = $NinePatchRect/StackLabel
@onready var on_click_button = $NinePatchRect/OnClickButton
@onready var price_label = $PriceLabel
@onready var menu_button = $NinePatchRect/MenuButton
var slot_to_equip = "NotEquipable"


func _ready() -> void:
	if starting_texture != null:
		texture_rect.texture = starting_texture
		
	if start_label != null:
		name_label.text = start_label
		
	menu_button.disabled = single_button_press
	on_click_button.disabled = !single_button_press
	on_click_button.visible = single_button_press
	
	
	var popup_menu = menu_button.get_popup()
	popup_menu.id_pressed.connect(on_popup_menu_item_pressed)
	
func on_popup_menu_item_pressed(id: int):
	var pressed_menu_item = menu_button.get_popup().get_item_text(id)
	if pressed_menu_item == "Drop":
		print_debug("Drop")
	elif pressed_menu_item.contains("Equip") && slot_to_equip != "NotEquipable":
		equip_item.emit(slot_to_equip)
	
	
	
func add_item(item:InventoryItem):
	if item.slot_type != "NotEquipable":
		var popup_menu = menu_button.get_popup()
		var equip_slot_name_array = item.slot_type.to_lower().split("_")
		var equip_slot_name = " ".join(equip_slot_name_array)
		slot_to_equip = item.slot_type
		popup_menu.set_item_text(0, "Equip to " + equip_slot_name)
	
	is_empty = false
	menu_button.disabled = false
	texture_rect.texture = item.texture
	name_label.text = item.name
	if item.stacks < 2:
		return
	stack_label.text = str(item.stacks)
	
