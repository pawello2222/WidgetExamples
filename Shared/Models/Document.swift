//
//  Document.swift
//  Widget Examples
//
//  Created by Pawel Wiszenko on 18/07/2023.
//  Copyright © 2023 Tersacore. All rights reserved.
//

import CoreData
import Foundation

@objc(Document)
public class Document: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String
    @NSManaged public var creationDate: Date

    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }

    @available(*, unavailable)
    public convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }

    public init(
        context: NSManagedObjectContext,
        name: String = "Document \(Int.random(in: 1 ... 99))",
        creationDate: Date = .now
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Document", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.creationDate = creationDate
    }

    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
