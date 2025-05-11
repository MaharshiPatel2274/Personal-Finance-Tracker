//
//  FinanceEntry.swift
//  Homework2
//
//  Created by mpate125 on 4/3/25.
//
import SwiftUI
import SwiftData

/// Categories for user expenses
enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case food = "Food"
    case entertainment = "Entertainment"
    case transportation = "Transportation"
    case rent = "Rent/Mortgage"
    case miscellaneous = "Misc."

    var id: String { self.rawValue }
}

/// SwiftData model class
@Model
class FinanceEntry {
    var date: Date
    var income: Double
    var expenses: Double
    var category: ExpenseCategory
    var savings: Double
    
    init(date: Date,
         income: Double,
         expenses: Double,
         category: ExpenseCategory,
         savings: Double) {
        self.date = date
        self.income = income
        self.expenses = expenses
        self.category = category
        self.savings = savings
    }
}
