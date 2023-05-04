//
//  Helpers.swift
//  Based
//
//  Created by antuan.khoanh on 30/04/2023.
//

import Foundation

infix operator ?= : AssignmentPrecedence

extension Optional {
    public static func ?= (lhs: inout Wrapped, rhs: inout Wrapped?) {
        guard let value = rhs else {
            return
        }
        lhs = value
    }
}
