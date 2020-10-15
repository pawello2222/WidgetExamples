//
//  ContentView.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage(UserDefaults.Keys.luckyNumber.rawValue, store: UserDefaults.appGroup) var luckyNumber = 1

    var body: some View {
        VStack {
            Text("Lucky number: \(luckyNumber)")
            Button("Generate new lucky number") {
                luckyNumber = Int.random(in: 1...99)
                WidgetCenter.shared.reloadTimelines(ofKind: "AppGroupWidget")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
