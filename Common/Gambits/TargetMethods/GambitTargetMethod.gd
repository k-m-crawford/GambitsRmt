class_name GambitTargetMethod
extends Resource

# returns a copy of entities list, sorted based
# on the heuristic defined by Sorter class,
# Sorter overidden and defined in subclasses
# i.e., closest, highest HP, etc.
func sort_targets(source, entities):
		var sorter = Sorter.new()
		sorter.source = source
		entities.sort_custom(Callable(sorter,"do_sort"))
		return entities


class Sorter:
	var source:Entity
	func do_sort(_e1:Entity, _e2:Entity):
		pass
