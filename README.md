# 💰 Personal Finance Tracker App – SwiftData/Firebase with MVVM

Developed as part of **CSE 335 - Homework #2**, this iOS application helps users track and analyze their daily finances using persistent storage via **SwiftData** or **Firebase**. It extends Homework #1 by integrating data persistence while maintaining all core functionalities.

🔗 Visit my portfolio: [maharshi-patel.com](https://maharshi-patel.com)

## 📱 App Overview

**Personal Finance Tracker** empowers users to:
- Log income, expenses (with categories), savings, and date
- Review financial data from the last 7 days
- Gain personalized insights on their financial habits

Built using **SwiftUI** and **MVVM** architecture, this app supports data storage via SwiftData or Firebase and optionally uses charts for enhanced visualization.

## 🎯 Key Features

### 1. ✅ Enter Financial Data
- Input fields for:
  - Income
  - Expense and Expense Category (e.g., Food, Entertainment, Transportation, Rent, Misc)
  - Savings
  - Date (MM/DD/YYYY)
- All entries are stored using **SwiftData** or **Firebase**

### 2. 📊 View My Finances
- Display a summary of financial activity from the last 7 days
- Organized list view showing each day’s inputs
- *(Optional)* SwiftUI Charts for visual summaries

### 3. 📈 How Am I Doing?
Analyze the last 7 days of data:
- If **avg. daily expenses > 30% of income** → “You are overspending!”
- If **avg. daily savings is 10–30% of income** → “You have a balanced budget!”
- If **avg. daily savings > 30% of income** → “You are saving well!”

## 🧱 Architecture

Follows **MVVM**:
- `Model`: Represents daily financial data
- `ViewModel`: Manages logic, insights, and database interactions
- `View`: SwiftUI interface with navigation, inputs, and charts

## 📦 Installation Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/MaharshiPatel2274/Personal-Finance-Tracker
   ```

2. Open in **Xcode** and run (iOS 15+)

3. If using **Firebase**, configure `GoogleService-Info.plist` and setup project accordingly

## 🖼️ Suggested Project Structure

```
Personal-Finance-Tracker/
├── Models/
│   └── FinanceEntry.swift
├── ViewModels/
│   └── FinanceTrackerViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── AddEntryView.swift
│   ├── SummaryView.swift
│   └── InsightView.swift
└── Resources/
    └── ChartHelpers.swift (if charts used)
```

**Author:** Maharshi Niraj Patel  
[Portfolio](https://maharshi-patel.com) • [GitHub](https://github.com/MaharshiPatel2274)
