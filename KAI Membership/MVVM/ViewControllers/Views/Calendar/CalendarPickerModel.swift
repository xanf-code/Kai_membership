//
//  CalendarPickerModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/03/2021.
//

import Foundation

enum CalendarDataError: Error {
    case metadataGeneration
}

struct Day {
    let date: Date
    let number: String
    let isNow: Bool
    let isSelected: Bool
    let isSunday: Bool
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
}
