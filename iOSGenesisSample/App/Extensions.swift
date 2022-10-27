//
//  Extensions.swift
//  iOSGenesisSample
//
//  Created by Ivaylo Hadzhiev on 21.10.22.
//

import Foundation

extension Date {

    var calendar: Calendar {
        Calendar(identifier: Calendar.current.identifier)
    }

    func dateByAdding(_ value: Int, to component: Calendar.Component = .second) -> Date? {
        var components = DateComponents()
        components.setValue(abs(value), for: component)
        return calendar.date(byAdding: components, to: self)
    }

    func dateBySubstracting(_ value: Int, from component: Calendar.Component = .second) -> Date? {
        var components = DateComponents()
        components.setValue(-abs(value), for: component)
        return calendar.date(byAdding: components, to: self)
    }
}
