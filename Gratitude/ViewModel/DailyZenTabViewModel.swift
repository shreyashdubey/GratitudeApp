//
//  DailyZenTabViewModel.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/26/23.
//

import Foundation
import Combine
import SwiftUI

class DailyZenTabViewModel: ObservableObject {
    @Published var dateBarViewModel = DateBarViewModel()
    @Published var dateResponseArray: [DateResponse] = []
    @Published var showShareSheet = false
    @Published var imageToShow: UIImage?
    @Published var shareText: String = ""
    
    private var currentDateChangeObserver: AnyCancellable?
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        currentDateChangeObserver = dateBarViewModel.$currentDate.sink {[weak self] updateValue in
            self?.fetchData(for: updateValue)
        }
    }
    
    private func fetchData(for date: Date) {
        dateResponseArray = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentQueryString = dateFormatter.string(from: date)
        
        APIService().callAPI(callURl: "https://m67m0xe4oj.execute-api.us-east-1.amazonaws.com/prod/dailyzen/?version=2&date=\(currentQueryString)", completionHandler: { jsonResponse, error, code in
            print(jsonResponse)
            if let apiResponseModel = APIService.decode([DateResponse].self, from: jsonResponse ?? "") {
                print("\n\n\n", apiResponseModel.count)
                self.dateResponseArray = apiResponseModel
            } else {
                print("ERRORR")
            }
        })
    }
}
