//
//  ImageViewer.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/24/23.
//

import SwiftUI


struct ImageViewer: View {
    @ObservedObject var viewModel: ImageDownloaderViewModel
    let imageURL: URL?
    
    init(imageURL: URL?, viewModel: ImageDownloaderViewModel) {
        self.imageURL = imageURL
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            if let imageURL = imageURL {
                if let image = viewModel.downloadedImage {
                    // Display the downloaded image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 343, height: 343)
                } else {
                    // Use the provided placeholder while loading
                    VStack(spacing: 0) {
                        Image("mountain")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 120)
                            .onAppear {
                                    viewModel.downloadImage(fromURL: imageURL, completion: {_ in
                                        
                                    })
                                
                            }
                        
                        Text("Content is loading...")
                            .font(.inter(.bold, relativeTo: .headline))
                            .foregroundColor(Color(hex: "#5B5B5B"))
                            .padding()
                    }
                    .frame(width: 343, height: 343)
                    .background(Color(hex: "#CCCCCC"))
                }
            } else {
                // Display a placeholder for no image URL
                VStack(spacing: 0) {
                    Image("mountain")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 120)
                    
                    Text("Content is loading...")
                        .font(.inter(.bold, relativeTo: .headline))
                        .foregroundColor(Color(hex: "#5B5B5B"))
                        .padding()
                }
                .frame(width: 343, height: 343)
                .background(Color(hex: "#CCCCCC"))
            }
        }
    }
}


//struct ImageViewer_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageViewer(imageURL: URL(string: "https://d3ez3n6m1z7158.cloudfront.net/exp/quote_976.png")!, viewModel: <#ImageDownloaderViewModel#>)
//    }
//}
