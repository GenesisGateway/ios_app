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

extension Optional {

    func unwrap(error: @autoclosure () -> String? = nil,
                 file: StaticString = #file,
                 line: UInt = #line) -> Wrapped {
        guard let unwrapped = self else {
            var message = "Value was nil in \(file) at line \(line)"
            if let errorMessage = error() {
                message.append(". Error: \(errorMessage)")
            }
            NSException(name: .invalidArgumentException, reason: message, userInfo: nil).raise()
            preconditionFailure(message)
        }
        return unwrapped
    }
}
