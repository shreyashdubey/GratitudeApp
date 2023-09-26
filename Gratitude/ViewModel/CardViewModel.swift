//
//  CardViewModel.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import SwiftUI
class CardViewModel: ObservableObject {
    @Published var title: String
    @Published var isLoading: Bool
    @Published var image: UIImage
    
    init(title: String, isLoading: Bool, isPreviousAvailble: Bool, image: UIImage, postURL: URL) {
        self.title = title
        self.isLoading = isLoading
        self.image = image
    }
}
