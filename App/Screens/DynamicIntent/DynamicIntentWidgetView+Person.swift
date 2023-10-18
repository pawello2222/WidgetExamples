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

import SwiftUI

extension DynamicIntentWidgetView {
    struct PersonView: View {
        @Binding var person: Person

        var body: some View {
            Grid(alignment: .leading) {
                headerView
                contentView
            }
        }
    }
}

// MARK: - Header

extension DynamicIntentWidgetView.PersonView {
    private var headerView: some View {
        GridRow {
            nameHeaderView
            dateOfBirthHeaderView
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var nameHeaderView: some View {
        HStack {
            Image(systemName: "person")
            Text("Name")
        }
    }

    private var dateOfBirthHeaderView: some View {
        HStack {
            Image(systemName: "calendar")
            Text("Date of birth")
        }
    }
}

// MARK: - Content

extension DynamicIntentWidgetView.PersonView {
    private var contentView: some View {
        GridRow {
            nameView
            dateOfBirthView
        }
    }

    private var nameView: some View {
        TextField("", text: $person.name)
    }

    private var dateOfBirthView: some View {
        HStack {
            DatePicker(selection: $person.dateOfBirth, displayedComponents: .date) {
                EmptyView()
            }
            .fixedSize()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DynamicIntentWidgetView.PersonView(person: .constant(.friend1))
    }
}
