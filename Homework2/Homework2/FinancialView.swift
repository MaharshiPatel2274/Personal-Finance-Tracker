//
//  FinanceView.swift
//  Homework2
//
//  Created by mpate125 on 4/3/25.
//

import SwiftUI
import Charts
import SwiftData

struct FinancialView: View {
    @ObservedObject var viewModel: FinanceViewModel
    
    var body: some View {
        TabView {
            DataEntryView(viewModel: viewModel)
                .tabItem {
                    Label("Enter Data", systemImage: "square.and.pencil")
                }
            
            FinanceSummaryView(viewModel: viewModel)
                .tabItem {
                    Label("My Finances", systemImage: "chart.bar.doc.horizontal")
                }
            
            InsightsView(viewModel: viewModel)
                .tabItem {
                    Label("Insights", systemImage: "lightbulb")
                }
        }
    }
}

// MARK: DataEntryView
struct DataEntryView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: FinanceViewModel
    
    @State private var selectedDate = Date() // user picks date
    @State private var incomeText = ""
    @State private var expensesText = ""
    @State private var savingsText = ""
    @State private var category: ExpenseCategory = .food
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("DAILY FINANCE").font(.subheadline).foregroundColor(.gray)) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    
                    TextField("Income", text: $incomeText)
                        .keyboardType(.decimalPad)
                    
                    TextField("Expenses", text: $expensesText)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases) { cat in
                            Text(cat.rawValue)
                                .foregroundColor(.gray)
                                .tag(cat)
                        }
                    }
                    
                    TextField("Savings", text: $savingsText)
                        .keyboardType(.decimalPad)
                    
                    Button("Add Entry") {
                        addEntry()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
            }
            .navigationTitle("Enter Financial Data")
        }
    }
    
    private func addEntry() {
        guard let inc = Double(incomeText),
              let exp = Double(expensesText),
              let sav = Double(savingsText)
        else {
            // Possibly show an alert for invalid input
            return
        }
        // Insert into SwiftData
        viewModel.addEntry(date: selectedDate,
                           income: inc,
                           expenses: exp,
                           category: category,
                           savings: sav,
                           context: context)
        
        // Clear fields
        selectedDate = Date()
        incomeText = ""
        expensesText = ""
        savingsText = ""
        category = .food
    }
}

// MARK: FinanceSummaryView
struct FinanceSummaryView: View {
    @ObservedObject var viewModel: FinanceViewModel
    
    // Query all FinanceEntry from SwiftData
    @Query var allEntries: [FinanceEntry]
    
    init(viewModel: FinanceViewModel) {
        self.viewModel = viewModel
        self._allEntries = Query(filter: #Predicate<FinanceEntry> { _ in true })
    }
    
    var body: some View {
        NavigationStack {
            // Filter last 7 days by date
            let last7 = viewModel.last7DaysEntries(allEntries: allEntries)
            
            VStack(spacing: 10) {
                Text("Last 7 Days")
                    .font(.headline)
                    .padding(.top, 8)
                
                if last7.isEmpty {
                    Text("No data. Please add some entries!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Show Chart if iOS 16+
                    if #available(iOS 16.0, *) {
                        Chart(last7) { entry in
                            BarMark(
                                x: .value("Date", entry.date, unit: .day),
                                y: .value("Expense", entry.expenses)
                            )
                            .foregroundStyle(by: .value("Category", entry.category.rawValue))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    } else {
                        Text("Charts require iOS 16+")
                            .italic()
                            .padding(.horizontal)
                    }
                    
                    List {
                        ForEach(last7) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.date, style: .date)
                                    .font(.headline)
                                
                                Text("Income: $\(entry.income, specifier: "%.2f")")
                                Text("Expenses: $\(entry.expenses, specifier: "%.2f") – \(entry.category.rawValue)")
                                Text("Savings: $\(entry.savings, specifier: "%.2f")")
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("My Finances")
        }
    }
}

// MARK: InsightsView
struct InsightsView: View {
    @ObservedObject var viewModel: FinanceViewModel
    
    // Query all entries from SwiftData
    @Query var allEntries: [FinanceEntry]
    
    init(viewModel: FinanceViewModel) {
        self.viewModel = viewModel
        self._allEntries = Query(filter: #Predicate<FinanceEntry> { _ in true })
    }
    
    var body: some View {
        NavigationStack {
            let last7 = viewModel.last7DaysEntries(allEntries: allEntries)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("How Am I Doing?")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                    
                    if last7.isEmpty {
                        Text("No data. Add some entries!")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        // Totals for last 7 days
                        let totalInc = viewModel.totalIncome(in: last7)
                        let totalExp = viewModel.totalExpenses(in: last7)
                        let totalSav = viewModel.totalSavings(in: last7)
                        
                        VStack(spacing: 8) {
                            Text("Total Income: $\(totalInc, specifier: "%.2f")")
                            Text("Total Expenses: $\(totalExp, specifier: "%.2f")")
                            Text("Total Savings: $\(totalSav, specifier: "%.2f")")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                        
                        Divider().padding(.horizontal)
                        
                        let analysisText = viewModel.spendingAnalysis(last7)
                        Text(analysisText)
                            .font(.headline)
                            .foregroundColor(colorForAnalysis(analysisText))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemBackground).opacity(0.9))
                            .cornerRadius(8)
                            .shadow(radius: 1)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Insights")
        }
    }
    
    private func colorForAnalysis(_ text: String) -> Color {
        switch text {
        case "You are overspending!":
            return .red
        case "You have a balanced budget!":
            return .orange
        case "You are saving well!":
            return .green
        default:
            return .blue
        }
    }
}
