class_name GambitTargetClosest
extends GambitTargetMethod

func find_targets(source, entities, sort=false):
	
	if sort:
		var sorter = Sorter.new()
		sorter.source = source
		entities.sort_custom(Callable(sorter,"do_sort"))
		return entities
	
	var closest = source.position.distance_to(entities[0].position)
	var cl_entity = entities[0]
	
	for e in entities:
		var dist = source.position.distance_to(e.position)
		if dist < closest: 
			closest = dist
			cl_entity = e
	
	return [cl_entity]
	
class Sorter:
	var source
	func do_sort(e1, e2):
		
		if e1.position.distance_to(source.position) < e2.position.distance_to(source.position):
			return true
		return false
