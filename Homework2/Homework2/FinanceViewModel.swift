//
//  FinanceViewModel.swift
//  Homework2
//
//  Created by mpate125 on 4/3/25.
//

import SwiftUI
import SwiftData

class FinanceViewModel: ObservableObject {
    
    /// Insert a new entry into SwiftData
    func addEntry(date: Date,
                  income: Double,
                  expenses: Double,
                  category: ExpenseCategory,
                  savings: Double,
                  context: ModelContext) {
        let newEntry = FinanceEntry(
            date: date,
            income: income,
            expenses: expenses,
            category: category,
            savings: savings
        )
        context.insert(newEntry)
        // If you want only 7 total items, you'd fetch & delete older ones.
        // If you want 7 days by date, see the logic below.
    }

    // Filter last 7 days by date
    func last7DaysEntries(allEntries: [FinanceEntry]) -> [FinanceEntry] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return allEntries.filter { $0.date >= sevenDaysAgo }
    }
    
    // Summations
    func totalIncome(in entries: [FinanceEntry]) -> Double {
        entries.reduce(0) { $0 + $1.income }
    }
    func totalExpenses(in entries: [FinanceEntry]) -> Double {
        entries.reduce(0) { $0 + $1.expenses }
    }
    func totalSavings(in entries: [FinanceEntry]) -> Double {
        entries.reduce(0) { $0 + $1.savings }
    }
    
    // 7-day analysis
    func spendingAnalysis(_ last7: [FinanceEntry]) -> String {
        guard !last7.isEmpty else { return "No data yet." }

        let totalInc = totalIncome(in: last7)
        let totalExp = totalExpenses(in: last7)
        let totalSav = totalSavings(in: last7)
        let count = Double(last7.count)
        
        let avgInc = totalInc / count
        let avgExp = totalExp / count
        let avgSav = totalSav / count
        
        if avgExp > avgInc * 0.3 {
            return "You are overspending!"
        } else if avgSav > avgInc * 0.3 {
            return "You are saving well!"
        } else if avgSav >= avgInc * 0.1 &&
                  avgSav <= avgInc * 0.3 {
            return "You have a balanced budget!"
        } else {
            return "Keep tracking your finances!"
        }
    }
}
