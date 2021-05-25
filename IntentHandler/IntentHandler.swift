//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by Pawel Wiszenko on 03.11.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Intents

class IntentHandler: INExtension, DynamicPersonSelectionIntentHandling {
    func providePersonOptionsCollection(
        for intent: DynamicPersonSelectionIntent,
        with completion: @escaping (INObjectCollection<Person>?, Error?) -> Void
    ) {
        let persons = Contact.getAll()
            .map { Person(identifier: $0.id, display: $0.name) }
        let collection = INObjectCollection(items: persons)
        completion(collection, nil)
    }
}
