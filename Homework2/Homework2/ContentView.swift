//
//  ContentView.swift
//  Homework2
//
//  Created by mpate125 on 4/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = FinanceViewModel()
    
    var body: some View {
        FinancialView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

