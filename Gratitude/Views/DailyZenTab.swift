//
//  DailyZenTab.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import SwiftUI
import Combine

struct DailyZenTab: View {
    @StateObject var viewModel = DailyZenTabViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                DateBarView(viewModel: viewModel.dateBarViewModel)
                    .padding(.bottom)
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        if viewModel.dateResponseArray.isEmpty {
                            CardView(dateResponse: nil, showShareSheet: $viewModel.showShareSheet, imageToShow: $viewModel.imageToShow, shareText: $viewModel.shareText)
                                .padding(.bottom, 400)
                        } else {
                            ForEach(viewModel.dateResponseArray) { chunk in
                                CardView(dateResponse: chunk, showShareSheet: $viewModel.showShareSheet, imageToShow: $viewModel.imageToShow, shareText: $viewModel.shareText)
                                    .padding(.bottom)
                            }
                        }
                        
                        VStack {
                            Image("girlHead")
                                .resizable()
                                .frame(width: 127, height: 128)
                                .padding(.bottom)
                            Text("That’s the Zen for today!\nSee you tomorrow :)")
                                .font(.inter(.regular, relativeTo: .headline))
                                .foregroundColor(Color(hex: "#847374"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 70)
                        .padding(.top, 70)
                    }
                    .onAppear {
                        proxy.scrollTo(0)
                    }
                }
            }
            BottomSheet(isShowing: $viewModel.showShareSheet, content: AnyView(CustomShareSheet(imageToShow: viewModel.imageToShow, showShareSheet: $viewModel.showShareSheet, shareText: $viewModel.shareText)))
        }
        .background(colorScheme == .dark ? Color.black : Color(hex: "#FAF9F6"))
    }
}
