//
//  DateBarView.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import SwiftUI

struct DateBarView: View {
    @ObservedObject var viewModel: DateBarViewModel
    var body: some View {
        VStack {
            ZStack {
                
                HStack{
                    Text(viewModel.formattedDate().uppercased())
                    .font(.inter(.bold, relativeTo: .headline))
                                
                }
                
                
                HStack{
                    
                    if viewModel.isPreviousAvailble{
                        Button(action: {
                            viewModel.previousButtonTapped()
                        }) {
                            HStack {
                                Image("previousArrow")
                                    .resizable()
                                    .frame(width: 16, height: 28)
                                Text("Previous")
                                    .font(.inter(.regular, relativeTo: .headline))
                                    .foregroundColor(Color(hex: "#EA436B"))
                                    .onAppear {
                                           let font = Font.inter(.bold, relativeTo: .headline)
                                           print("--my font",font)
                                       }
                            
                            }
                        }
                        .padding(.leading, 5)
                    }
                    
                    Spacer()
                    
                    if viewModel.isNextAvailble{
                        Button(action: {
                            viewModel.nextButtonTapped()
                        }) {
                            HStack {
                                Text("Next")
                                    .foregroundColor(Color(hex: "#EA436B"))
                                    .font(.inter(.regular, relativeTo: .headline))
                                Image("previousArrow")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: 180))
                                    .frame(width: 16, height: 28)
                                
                            }
                        }
                        .padding(.trailing, 5)
                    }
                }
                
            }
        }
    }
}

struct DateBarView_Previews: PreviewProvider {
    static var previews: some View {
        DateBarView(viewModel: DateBarViewModel())
    }
}
