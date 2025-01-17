//
//  BookReqBox.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 08/05/24.
//

import SwiftUI

struct BookReqBox: View {
    
    @State var bookRequestData: Loan
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        if bookRequestData.loanStatus == "Requested" {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("requestCard"))
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    .frame(maxHeight: 125)
                HStack{
                    AsyncImage(url: URL(string: bookRequestData.bookImageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle().fill(Color(.systemGray4))
                        .frame(width: 60, height: 100)
                    }
                    .frame(width: 60,height: 100)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 5){
                        Spacer()
                        
                        Text("\(bookRequestData.bookName)")
                            .multilineTextAlignment(.leading)
                            .font(.callout)
                            .lineLimit(2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                        
                        Text(bookRequestData.loanStatus)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundColor(Color(.systemGray))
                        
                        HStack{
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text(formatDate(bookRequestData.createdOn))
                                .font(.caption)
                        }
                    }
                    .frame(width: 120)
                    .padding(5)
                    
                    Spacer()
                }
                .padding(10)
                .cornerRadius(8)
                
            }
            .padding(.leading)
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yy"
            return dateFormatterOutput.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

