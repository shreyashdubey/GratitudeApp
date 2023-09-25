//
//  BottomSheet.swift
//  Gratitude
//
//  Created by Shreyash on 9/25/23.
//

import Foundation
import SwiftUI
struct BottomSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isShowing: Bool
    var content: AnyView
    var bottomPadding: CGFloat = 42
    
    var viewClosedByTappingOutside: (()-> Void)?
    
    var stopOutsideDismiss: Bool = false
    
    init(isShowing: Binding<Bool>, content: AnyView, bottomPadding: CGFloat = 42, stopOutsideDismiss: Bool = false) {
        _isShowing = isShowing
        self.content = content
        self.bottomPadding = bottomPadding
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewClosedByTappingOutside?()
                        if(stopOutsideDismiss == false){
                            isShowing.toggle()
                        }
                    }
                content
                    .padding(.bottom, bottomPadding)
                    .transition(.move(edge: .bottom))
                    .background(
                        colorScheme != .dark ? Color(hex: "#FFFFFF") : Color(hex: "#1C1C1E")
                        
                    )
                    .cornerRadius(16, corners: [.topLeft, .topRight])
            }
        }
        .background(.black.opacity(0.4))
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        
        .animation(.easeInOut, value: isShowing)
    }
}
