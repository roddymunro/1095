//
//  NSManagedObjectContext+Ext.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-10.
//

import CoreData

extension NSManagedObjectContext {
	func saveContext() {
		do {
			try save()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

	func delete(_ entries: [TravelEntry]) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TravelEntry")
		request.predicate = NSPredicate(format: "id IN %@", entries.map { $0.id?.uuidString })
		do {
			let results = (try fetch(request) as? [TravelEntry]) ?? []
			results.forEach { delete($0) }
		} catch {
			print("Failed removing provided objects")
			return
		}
		saveContext()
	}
}
