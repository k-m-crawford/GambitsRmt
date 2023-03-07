class_name GambitTargetClosest
extends GambitTargetMethod

class Sorter:
	var source
	func do_sort(e1, e2):
		
		if e1.position.distance_to(source.position) < e2.position.distance_to(source.position):
			return true
		return false
