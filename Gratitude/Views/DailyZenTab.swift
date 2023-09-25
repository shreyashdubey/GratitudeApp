//
//  DailyZenTab.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation
import SwiftUI
import Combine

struct DailyZenTab: View {
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
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    DateBarView(viewModel: dateBar_VM)
                        .padding(.bottom)
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
                .background(colorScheme != .dark ? Color(hex: "#FAF9F6") : Color.black)
            }
            BottomSheet(isShowing: $showShareSheet, content: AnyView(CustomShareSheet(imageToShow: imageToShow, showShareSheet: $showShareSheet, shareText: $shareText)))
        }
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
        .onAppear{
            print("ZenTab onapp")
        }
    }
        
}

//struct DailyZenTab_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyZenTab()
//    }
//}
