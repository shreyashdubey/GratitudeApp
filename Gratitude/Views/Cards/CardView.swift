//
//  Card.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
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
                                showShareSheet.toggle()
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
                    .padding(5)
                    
                    
                    
                }
                
            }
            else{
                ImageViewer(imageURL: nil, viewModel: imageDownloaderVM)
            }
            Spacer()
            
           // InstagramShareView()
        }
        .padding(.horizontal, 5)
        .frame(width: 343, height: 438)
        .background(colorScheme == .dark ? Color(hex: "#1C1C1E") : Color(hex: "#FFFFFF"))
        .cornerRadius(15)
        .onAppear{
            print("Card onapp")
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(dataResponse: DateResponse())
//    }
//}




import Foundation
import SwiftUI // You can import UIKit instead if you like, both will work.
import UIKit

struct InstagramSharingUtils {

  // Returns a URL if Instagram Stories can be opened, otherwise returns nil.
  private static var instagramStoriesUrl: URL? {
    if let url = URL(string: "instagram-stories://share?source_application=your-app-bundle-identifier") {
      if UIApplication.shared.canOpenURL(url) {
        return url
      }
    }
    return nil
  }

  // Convenience wrapper to return a boolean for `instagramStoriesUrl`
  static var canOpenInstagramStories: Bool {
    return instagramStoriesUrl != nil
  }

  // If Instagram Stories is available, writes the image to the pasteboard and
  // then opens Instagram.
  static func shareToInstagramStories(_ image: UIImage) {

    // Check that Instagram Stories is available.
    guard let instagramStoriesUrl = instagramStoriesUrl else {
      return
    }

    // Convert the image to data that can be written to the pasteboard.
    let imageDataOrNil = UIImage.pngData(image)
    guard let imageData = imageDataOrNil() else {
      print("🙈 Image data not available.")
      return
    }
    let pasteboardItem = ["com.instagram.sharedSticker.backgroundImage": imageData]
    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]

    // Add the image to the pasteboard. Instagram will read the image from the pasteboard when it's opened.
    UIPasteboard.general.setItems([pasteboardItem], options: pasteboardOptions)

    // Open Instagram.
    UIApplication.shared.open(instagramStoriesUrl, options: [:], completionHandler: nil)
  }
}

import SwiftUI

struct InstagramShareView: View {

  var imageToShare: Image {
    // An image defined in your app's asset catalogue.
      return Image(uiImage: UIImage(systemName: "heart.fill")!)
  }

  var body: some View {
    VStack {

      // Display the image that will be shared to Instagram.
      imageToShare

      if InstagramSharingUtils.canOpenInstagramStories {
        Button(action: {
            InstagramSharingUtils.shareToInstagramStories(UIImage(systemName: "heart.fill")!)
        }) {
          Text("Share to Instagram Stories")
        }
      } else {
        Text("Instagram is not available.")
      }
    }
  }
}



//func shareImageWithCaptionOnWhatsApp(image: UIImage, caption: String) {
//    let imageEncoded = image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
//    let captionEncoded = caption.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//
//    let urlString = "whatsapp://send?text=&source&data=image/jpeg;base64,\(imageEncoded)&caption=\(captionEncoded)"
//
//    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    } else {
//        print("WhatsApp is not installed.")
//    }
//}


func shareImageWithCaptionOnWhatsApp(image: UIImage, caption: String) {
    let textToShare = caption
    let items: [Any] = [image, textToShare]
    
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    // Exclude all activities except WhatsApp
    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
    
    if let viewController = UIApplication.shared.windows.first?.rootViewController {
        viewController.present(activityViewController, animated: true, completion: nil)
    } else {
        print("Unable to present UIActivityViewController.")
    }
}

//func shareOnWhatsApp3(caption: String, image: UIImage?) {
//        if let whatsappURL = URL(string: "whatsapp://app") {
//            if UIApplication.shared.canOpenURL(whatsappURL) {
//                if let imageData = image?.jpegData(compressionQuality: 1.0) {
//                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let photoURL = documentDirectory.appendingPathComponent("tempImage2.jpg")
//
//                    do {
//                        try imageData.write(to: photoURL)
//                    } catch {
//                        // Handle error if needed
//                    }
//
//                    let contentCaption = "\(caption), shared from MYAPP"
//
//                    if let encodedCaption = contentCaption.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                        let encodedPhotoURL = photoURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//                        if let whatsappURL = URL(string: "whatsapp://send?text=\(encodedCaption)&image=\(encodedPhotoURL)") {
//                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
//func shareOnWhatsApp3(caption: String, image: UIImage?) {
//       if let image = image {
//           let items: [Any] = [image, caption]
//
//           let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
//
//           // Exclude all activities except WhatsApp
//           activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
//
//           if let viewController = UIApplication.shared.windows.first?.rootViewController {
//               viewController.present(activityViewController, animated: true, completion: nil)
//           } else {
//               print("Unable to present UIActivityViewController.")
//           }
//       } else {
//           print("Image not found.")
//       }
//   }
//func shareOnWhatsApp3(text: String, image: UIImage?) {
//        if let image = image, let imagePNGData = image.pngData() {
//            let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempImage.png")
//
//            do {
//                try imagePNGData.write(to: tempFileURL)
//
//                let shareIntent = UIActivityViewController(activityItems: [text, tempFileURL], applicationActivities: nil)
//                shareIntent.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
//
//                if let viewController = UIApplication.shared.windows.first?.rootViewController {
//                    viewController.present(shareIntent, animated: true, completion: nil)
//                } else {
//                    print("Unable to present UIActivityViewController.")
//                }
//            } catch {
//                print("Error while writing image data: \(error)")
//            }
//        } else {
//            print("Image not found.")
//        }
//    }


//
  
//
//func shareOnWhatsApp3(caption: String, image: UIImage?) {
//       if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
//           let tempFileURL = saveImageToDocumentsDirectory(imageData: imageData)
//           let textAndImage = "\(caption) %0A %0A \(tempFileURL.absoluteString)"
//           let whatsappURL = URL(string: "whatsapp://send?text=hmm") // You can add the phone number here
//
//           if let url = whatsappURL, UIApplication.shared.canOpenURL(url) {
//               documentInteractionController = UIDocumentInteractionController(url: tempFileURL)
//               documentInteractionController?.uti = "net.whatsapp.image"
//               documentInteractionController?.presentOpenInMenu(from: CGRect.zero, in: UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(), animated: true)
//           } else {
//               print("WhatsApp is not installed.")
//           }
//       } else {
//           print("Image not found.")
//       }
//   }
//
//   func saveImageToDocumentsDirectory(imageData: Data) -> URL {
//       let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//       let fileURL = documentsDirectory.appendingPathComponent("tempImage.jpg")
//
//       try? imageData.write(to: fileURL)
//
//       return fileURL
//   }
//
//@State var textToShare: String = "teri maa"
//func shareToWhatsApp() {
//       if let whatsappURL = URL(string: "whatsapp://app") {
//           if UIApplication.shared.canOpenURL(whatsappURL) {
//               // WhatsApp is installed, prepare the message to share
//               let textToShare = "Check out this amazing content: \(self.textToShare)"
//               let items: [Any] = [textToShare]
//
//               let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
//               UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//           } else {
//               // WhatsApp is not installed, handle accordingly (e.g., show an alert)
//           }
//       }
//   }
