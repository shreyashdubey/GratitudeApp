//
//  CustomShareSheet.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/25/23.
//

import SwiftUI
import UIKit
import MobileCoreServices
struct CustomShareSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @State var imageToShow: UIImage?
    @Binding var showShareSheet: Bool
    @Binding var shareText: String
    @State var copiedText: String = ""
    @State var didCopy: Bool = false
    @State private var documentInteractionController: UIDocumentInteractionController?
       
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text("Inspire Your Friends")
                    .font(.inter(.bold, relativeTo: .headline))
                    .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                    .padding(.leading)
                Spacer()
                Image(colorScheme == .dark ? "crossButtonDark" : "crossButtonLight")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
                    .onTapGesture {
                        showShareSheet.toggle()
                    }
            }
            .frame(height: 22)
            .padding(.vertical, 20)
            .padding(.leading, 5)
            if let image = imageToShow {
                // Display the downloaded image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 343, height: 343)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(colorScheme != .dark ? Color(hex: "#3C3C4399") : Color(hex: "#FAF9F6"))
                    )
            }
            
            HStack{
                Text(shareText)
                    .multilineTextAlignment(.leading)
                    .font(.inter(.Medium, relativeTo: .headline))
                    .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                    .frame(height: 21)
                    .padding(.leading, 6)
                
                Button(action: {
                    copyTextToClipboard(text: shareText)
                    didCopy = true
                }, label: {
                    HStack {
                        Text(didCopy ? "Copied" : "Copy")
                            .font(.inter(.Medium, relativeTo: .headline))
                        .foregroundColor(!didCopy ? Color(hex: "#FFFFFF") : Color(hex: "#EA436B"))
                    }
                    .frame(width: (didCopy ? 80 : 65), height: 34)
                    .background(didCopy ? Color(hex: "#EA436B26").opacity(0.15) : Color(hex: "#EA436B"))
                    .cornerRadius(48)
                    .padding(.trailing, 6)
                })
            }
            .frame(width: 343, height: 48)
            .background(colorScheme == .dark ? Color(hex: "#2C2C2E") : Color(hex: "#F2F2F7"))
            .cornerRadius(50)
            .padding(.vertical)
            
            Rectangle()
                .frame(width: 343, height: 1)
                .foregroundColor(colorScheme != .dark ? Color(hex: "#C6C6C8") : Color(hex: "#38383A"))
                .padding(.vertical)
            
            HStack{
                Text("Share to")
                    .font(.inter(.bold, relativeTo: .headline))
                    .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                    .padding(.leading)
                Spacer()
            }
            .padding(.bottom)
            HStack{
                if checkIfWhatsAppInstalled(){
                    VStack {
                        Image("whatsappIcon")
                            .resizable()
                        .frame(width: 44,height: 44)
                        Text("Whatsapp")
                            .font(.inter(.bold, relativeTo: .caption))
                            .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                    }
                    .frame(width: 65)
                    .onTapGesture {
                        shareOnWhatsApp(text: "Test", image: imageToShow)
                    }
                }
                
                VStack {
                    Image("instagramIcon")
                        .resizable()
                    .frame(width: 44,height: 44)
                    Text("Instagram")
                        .font(.inter(.bold, relativeTo: .caption))
                        .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                }
                .frame(width: 65)
                .onTapGesture {
                    shareImageToInstagramStories(image: imageToShow!)
                }
                VStack {
                    Image("facebookIcon")
                        .resizable()
                    .frame(width: 44,height: 44)
                    Text("Facebook")
                        .font(.inter(.bold, relativeTo: .caption))
                        .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                }
                .frame(width: 65)
                .onTapGesture {
                    shareImage(image: imageToShow!)
                }
                VStack {
                    Image(colorScheme == .dark ? "downloadIconDark" : "downloadIconLight")
                        .resizable()
                    .frame(width: 44,height: 44)
                    Text("Download")
                        .font(.inter(.bold, relativeTo: .caption))
                        .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                }
                .frame(width: 65)
                VStack {
                    Image(colorScheme == .dark ? "moreIconDark" : "moreIconLight")
                        .resizable()
                    .frame(width: 44,height: 44)
                    Text("More")
                        .font(.inter(.bold, relativeTo: .caption))
                        .foregroundColor((colorScheme) == .dark ? Color.white : Color.black)
                }
                .frame(width: 65)
                .onTapGesture{
                    shareImage(image: imageToShow!)
                }
            }
            
        }
        .onAppear(){
            print("cc",colorScheme)
        }
    }
    func checkIfWhatsAppInstalled() -> Bool {
            return UIApplication.shared.canOpenURL(URL(string: "whatsapp://")!)
        }
    
    //
        func shareOnWhatsApp(text: String, image: UIImage?) {
            if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
                let tempFileURL = saveImageToDocumentsDirectory(imageData: imageData)
                let whatsappURL = URL(string: "whatsapp://send?text=mmm") // You can add the phone number here
    
                if let url = whatsappURL, UIApplication.shared.canOpenURL(url) {
                    documentInteractionController = UIDocumentInteractionController(url: tempFileURL)
                    documentInteractionController?.uti = "net.whatsapp.image"
                    documentInteractionController?.presentOpenInMenu(from: CGRect.zero, in: UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(), animated: true)
                } else {
                    print("WhatsApp is not installed.")
                }
            } else {
                print("Image not found.")
            }
        }
    
        func saveImageToDocumentsDirectory(imageData: Data) -> URL {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("tempImage.jpg")
    
            try? imageData.write(to: fileURL)
    
            return fileURL
        }
    
    
    func copyTextToClipboard(text: String) {
           // Create a UIPasteboard instance for the general pasteboard
           let pasteboard = UIPasteboard.general
           // Set the text you want to copy to the clipboard
           pasteboard.string = text
           // Update the @State variable to reflect the copied text
           copiedText = text
       }
    
    func shareImageToInstagramStories( image: UIImage) {
        guard let instagramStoriesUrl = URL(string: "instagram-stories://share?source_application=your-app-bundle-identifier") else {
            return
        }
        
        if let imageData = image.pngData() {
            let pasteboardItem = ["com.instagram.sharedSticker.backgroundImage": imageData]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
            
            UIPasteboard.general.setItems([pasteboardItem], options: pasteboardOptions)
            
            UIApplication.shared.open(instagramStoriesUrl, options: [:], completionHandler: nil)
        } else {
            print("🙈 Image data not available.")
        }
    }
    
    func shareImage( image: UIImage) {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    
    }
//struct CustomShareSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomShareSheet(showShareSheet: .constant(false), shareText: .constant("test"))
//    }
//}





