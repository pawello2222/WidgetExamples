// The MIT License (MIT)
//
// Copyright (c) 2020-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let modelName = "DataModel"
        container = NSPersistentContainer(name: modelName)
        let storeURL = if inMemory {
            URL(fileURLWithPath: "/dev/null")
        } else {
            FileManager.appGroupContainerURL.appendingPathComponent("\(modelName).sqlite")
        }
        container.persistentStoreDescriptions = [.init(url: storeURL)]
        container.loadPersistentStores { _, error in
            if let nsError = error as NSError? {
                print(nsError)
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Main Context

extension PersistenceController {
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Working Context

extension PersistenceController {
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }

    func saveWorkingContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            saveContext()
        } catch {
            print(error)
        }
    }
}

// MARK: - Convenience

extension NSManagedObjectContext {
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for _ in 0 ..< 10 {
            _ = Document(context: viewContext)
        }
        try? viewContext.save()
        return controller
    }()
}
