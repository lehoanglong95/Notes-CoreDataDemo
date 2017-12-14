//
//  Note.swift
//  Notes
//
//  Created by LongLH on 12/14/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import Foundation

extension Note {
    var updatedAtAsDate: Date {
        guard let updatedAt = updatedAt else {
            return Date()
        }
        return Date(timeIntervalSince1970: updatedAt.timeIntervalSince1970)
    }
    
    var cratedAtAsDate: Date {
        guard let createdAt = createdAt else {
            return Date()
        }
        return Date(timeIntervalSince1970: createdAt.timeIntervalSince1970)
    }
}
