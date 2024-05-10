//
//  CheckInView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 05/05/24.
//

import SwiftUI

struct CheckInDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var checkInDetails: Loan
    @ObservedObject var LibViewModel: LibrarianViewModel
    @State private var authViewModel = AuthViewModel()
    @State var showAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Member Details")) {
                
                HStack{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .padding(5)
                    
                    VStack(alignment: .leading){
                        Text(checkInDetails.bookIssuedToName)
                            .fontWeight(.semibold)
                        if !LibViewModel.currentMember.isEmpty {
                                Text(LibViewModel.currentMember[0].email)
                            }
                    }
                }
            }
            
            Section(header: Text("Book Information")) {
                
                HStack{
                    Text("Title: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(checkInDetails.bookName)
                }
                
                HStack{
                    Text("Issued on: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDate(checkInDetails.bookIssuedOn))
                }
                
                HStack{
                    Text("Expected return: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDate(checkInDetails.bookExpectedReturnOn))
                }
                
                HStack{
                    Text("Status: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(checkInDetails.loanStatus)
                }
            }
            //Spacer()
            Section(header: Text("Fine Information")) {
                HStack{
                    Text("Overdue Days: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(checkInDetails.fineCalculatedDays)")
                }
                HStack{
                    Text("Total Fine: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(checkInDetails.loanFine)")
                }
            }
        }
        .alert(isPresented: $showAlert) { () -> Alert in
                                let button = Alert.Button.default(Text("OK")) {
                                    print("OK Button Pressed")
                                }
                                return Alert(title: Text("Confirmation"), message: Text("Book Checked In successfully."), dismissButton: button)
                     }
        .task {
            do{
                LibViewModel.fetchUserData(userID: checkInDetails.bookIssuedTo)
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
        .navigationBarTitle("Checkin details", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showAlert = true
            Task {
                do {
                    try await LibViewModel.checkInBook(loanId: checkInDetails.loanId, bookId: checkInDetails.bookId, userId: checkInDetails.bookIssuedTo, userFines: LibViewModel.currentMember[0].activeFine, loanFine: checkInDetails.loanFine, userPenalty: LibViewModel.currentMember[0].penaltiesCount)
                    // Handle success
                } catch {
                    // Handle error
                }
            }
        }, label: {
            Text("CheckIn")
        }))
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yy"
            return dateFormatterOutput.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

struct CIDVPrev: View {
    
    @State var LibViewModel = LibrarianViewModel()
    let loan = Loan(loanId: "1",
                    bookId: "123",
                    bookName: "Sample Book", bookImageURL: "https://books.google.com/books/content?id=vlkqAAAAYAAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                    bookIssuedTo: "John Doe",
                    bookIssuedToName: "John Doe",
                    bookIssuedOn: "05/01/2024, 10:00 AM",
                    bookExpectedReturnOn: "05/15/2024, 10:00 AM",
                    bookReturnedOn: "05/12/2024, 10:00 AM",
                    loanStatus: "Returned",
                    loanReminderStatus: "None", fineCalculatedDays: 0, loanFine: 0,
                    createdOn: "05/01/2024, 10:00 AM",
                    updatedOn: "05/12/2024, 10:00 AM",
                    timeStamp: 1620202800)
    
    var body: some View {
        CheckInDetailsView(checkInDetails: loan, LibViewModel: LibViewModel)
    }
}

#Preview {
    CIDVPrev()
}


