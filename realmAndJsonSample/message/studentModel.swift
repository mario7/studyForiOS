//
//  studentModel.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/06/14.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation

enum SortOrder
{
    case ascending
    case descending
}

extension Sequence
{
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, order: SortOrder = .ascending) -> [Element] {
        return sorted { a, b in
            switch order
            {
            case .ascending:
                return a[keyPath: keyPath] < b[keyPath: keyPath]
            case .descending:
                return a[keyPath: keyPath] > b[keyPath: keyPath]
            }
        }
    }
}

struct StudentModel {
    var studentId = "0"
    var name = "new"
    var age = "0"
}
