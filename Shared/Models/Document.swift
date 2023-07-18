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
import Foundation

@objc(Document)
class Document: NSManagedObject, Identifiable {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Document> {
        NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged var name: String
    @NSManaged var creationDate: Date

    @available(*, unavailable)
    init() {
        fatalError("\(#function) not implemented")
    }

    @available(*, unavailable)
    convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }

    init(
        context: NSManagedObjectContext,
        name: String = "Document \(Int.random(in: 1 ... 99))",
        creationDate: Date = .now
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Document", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.creationDate = creationDate
    }

    @objc override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
