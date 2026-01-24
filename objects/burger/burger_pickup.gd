extends Area3D

@export var bun_top_visual: Node3D
@export var cheese_visual: Node3D
@export var meat_visual: Node3D
@export var bun_bottom_visual: Node3D

@export var burger_recipe: RecipeResource


var can_pickup := false

var has_ingredient_list: Dictionary [String, bool] = {}

func _ready() -> void:
	for i in burger_recipe.ingredients:
		has_ingredient_list[i.name] = false
		
func place_ingredient(ingredient: IngredientResource) -> void:
	if burger_recipe.has_ingredient(ingredient):
		has_ingredient_list[ingredient.name] = true

	if all_true():
		can_pickup = true
		$InteractionComponent.context = "Pickup " + burger_recipe.name

func all_true() -> bool:
	for k in has_ingredient_list:
		if !has_ingredient_list[k]:
			return false
	return true
