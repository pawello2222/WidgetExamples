//
//  PreviewWidgetView.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import SwiftUI
import WidgetKit

struct PreviewWidgetEntryView: View {
    var entry: PreviewWidgetEntry

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.blue
                Circle()
                    .fill(Color.yellow)
                    .padding()
                Image(systemName: entry.systemImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 2)
            }
        }
    }
}
