//
//  CardViewModel.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation
import SwiftUI
class CardViewModel: ObservableObject {
    @Published var title: String
    @Published var isLoading: Bool
    @Published var isPreviousAvailble: Bool = true
    @Published var image: UIImage
    @Published var postURL: URL
    private let calendar = Calendar.current
    
    init(title: String, isLoading: Bool, isPreviousAvailble: Bool, image: UIImage, postURL: URL) {
        self.title = title
        self.isLoading = isLoading
        self.isPreviousAvailble = isPreviousAvailble
        self.image = image
        self.postURL = postURL
    }
}
