//
//  Card.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import SwiftUI
import UIKit
struct CardView: View {
    @State var dateResponse: DateResponse?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    @StateObject var imageDownloaderVM: ImageDownloaderViewModel = ImageDownloaderViewModel()
    @Binding var showShareSheet: Bool
    @Binding var imageToShow: UIImage?
    @Binding var shareText: String
    var body: some View {
        VStack( spacing: 0){
            if let image = imageDownloaderVM.downloadedImage{
                if let dateResponse = dateResponse , let iLink = dateResponse.dzImageUrl, let title = dateResponse.themeTitle{
                    HStack{
                        Text(title)
                            .font(.inter(.bold, relativeTo: .headline))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#EBEBF5") : Color(hex: "#3C3C43"))
                            .padding(.leading)
                        Spacer()
                    }
                    .frame(height: 22)
                    .padding(.vertical, 10)
                    .padding(.leading, 5)
                    Rectangle()
                        .frame(width: 343, height: 1)
                        .foregroundColor(colorScheme != .dark ? Color(hex: "#C6C6C8") : Color(hex: "#38383A"))
                    ImageViewer(imageURL: URL(string: iLink), viewModel: imageDownloaderVM)
                        .environmentObject(imageDownloaderVM)
                    if let dzType = dateResponse.dzType{
                        
                        HStack{
                            if dzType == "read"{
                                Button(action: {
                                    if let articleURLString = dateResponse.articleUrl, let articleURL = URL(string: articleURLString){
                                        openURL(articleURL)
                                    }
                                }, label: {
                                    Image(colorScheme == .dark ? "readPostDark" : "readPostLight")
                                        .resizable()
                                        .frame(width: 155, height: 34)
                                })
                            }
                            if dzType == "send" || dzType == "share" || dzType == "add_affn" || dzType == "read"{
                                Button(action: {
                                    showShareSheet = true
                                    imageToShow = imageDownloaderVM.downloadedImage
                                    print("made true")
                                    shareText = ("\"" + (dateResponse.sharePrefix ?? " ") + "\" ") + (dateResponse.articleUrl ?? " ")
                                }, label: {
                                    Image(colorScheme == .dark ? "shareIconDark" : "shareIconLight")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                })
                            }
                            
                            //TODO: Save Button Logic
                            HStack{
                                Image(colorScheme == .dark ? "saveIconDark" : "saveIconLight")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 10, trailing: 0))
                    }
                    
                }
            }
            else{
                ImageViewer(imageURL: nil, viewModel: imageDownloaderVM)
                    .frame(width: 343, height: 343)
            }
            Spacer()
        }
        .padding(.horizontal, 5)
        .frame(width: 343, height: 438)
        .background(colorScheme == .dark ? Color(hex: "#1C1C1E") : Color(hex: "#FFFFFF"))
        .cornerRadius(15)
        .onAppear {
            if imageDownloaderVM.downloadedImage == nil {
                if let imageURLString = dateResponse?.dzImageUrl, let imageURL = URL(string: imageURLString) {
                    imageDownloaderVM.downloadImage(fromURL: imageURL) { _ in
                    }
                }
            }
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(dataResponse: DateResponse())
//    }
//}
