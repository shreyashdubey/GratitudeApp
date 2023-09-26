//
//  DailyZenTab.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import SwiftUI
import Combine

struct DailyZenTab1: View {
    @StateObject var dateBar_VM: DateBarViewModel = DateBarViewModel()
    @State var imageArray: [String : UIImage?] = [:]
    @State var dateResponseArray: [DateResponse] = []
    @State var currentDateChangeObeserver: AnyCancellable?
    @Environment(\.colorScheme) var colorScheme
    @State var showShareSheet = false
    @State var imageToShow: UIImage?
    @State var shareText: String = ""
    var body: some View {
        ZStack{
            //Color.black.ignoresSafeArea()
            VStack {
                DateBarView(viewModel: dateBar_VM)
                    .padding(.bottom)
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            if dateResponseArray.count != 0{
                                VStack{
                                    ForEach(dateResponseArray){ chunk in
                                        CardView(dateResponse: chunk, showShareSheet: Binding(
                                                                    get: { showShareSheet },
                                                                    set: { newValue in
                                                                        showShareSheet = newValue
                                                                    }
                                                                ), imageToShow: $imageToShow, shareText: $shareText)
                                                                .padding(.bottom)
                                    }
                                }
                            }
                            else{
                                CardView(dateResponse: nil, showShareSheet: .constant(false), imageToShow: .constant(nil), shareText: .constant("nil"))
                                    .padding(.bottom, 400)
                            }
                            
                            VStack{
                                Image("girlHead")
                                    .resizable()
                                    .frame(width: 127, height: 128)
                                    .padding(.bottom)
                                HStack{
                                    Text("That’s the Zen for today!\nSee you tomorrow :)")
                                        .font(.inter(.regular, relativeTo: .headline))
                                        .foregroundColor(Color(hex: "#847374"))
                                        .multilineTextAlignment(.center)
                                }
                            }
                                .padding(.bottom, 70)
                                .padding(.top, 70)
                        }
                        .onAppear(){
                            proxy.scrollTo(0)
                        }
                    }
                    
                }
            }
            BottomSheet(isShowing: $showShareSheet, content: AnyView(CustomShareSheet(imageToShow: imageToShow, showShareSheet: $showShareSheet, shareText: $shareText)))
        }
        .background(colorScheme != .dark ? Color(hex: "#FAF9F6") : Color.black)
        .onAppear(){
            self.currentDateChangeObeserver = dateBar_VM.$currentDate.sink(receiveValue: { updateValue in
                dateResponseArray = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let currentQueryString =  dateFormatter.string(from: updateValue)
                APIService().callAPI(callURl: "https://m67m0xe4oj.execute-api.us-east-1.amazonaws.com/prod/dailyzen/?version=2&date=\(currentQueryString)", completionHandler: {
                    jsonResponse, error, code in
                    print(jsonResponse)
                    if let apiResponseModel = APIService.decode([DateResponse].self, from: jsonResponse ?? ""){
                        print("\n\n\n",apiResponseModel.count)
                        dateResponseArray = []
                        dateResponseArray = []
                        for i in apiResponseModel{
                            dateResponseArray.append(i)
                        }
                    }
                    else{
                        print("ERRORR")
                    }
                })
            })
        }
    }
        
}

//struct DailyZenTab_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyZenTab()
//    }
//}




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
                self.dateResponseArray = apiResponseModel // Update the property directly
            } else {
                print("ERRORR")
            }
        })
    }
}


import SwiftUI

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
//        .background(Color(uiColor: viewModel.colorScheme == .dark ? UIColor.black : UIColor(hex: "#FAF9F6")))
//        .background(viewModel.colorScheme != .dark ? Color(hex: "#FAF9F6") : Color.black)
    }
}
