class_name RecipeResource
extends Resource

@export var name: String
@export var ingredients: Array[IngredientResource]
@export var pickup_scene: PackedScene

func has_ingredient(ingredient: IngredientResource) -> bool:
	return ingredients.has(ingredient) 
