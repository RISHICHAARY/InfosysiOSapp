//
//  UserBooksModel.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 27/04/24.
//

import SwiftUI

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserBooksModel: ObservableObject{
    
    let dbInstance = Firestore.firestore()
    
    @Published var responseStatus = 0
    @Published var responseMessage = ""
    
    @Published var currentBook: [Book] = []
    @Published var allBooks: [Book] = []
    
    func getBook(bookId: String){
        
        self.responseStatus = 0
        self.responseMessage = ""
        
        self.dbInstance.collection("Books").document(bookId).getDocument { (document, error) in
            if error == nil{
                if (document != nil && document!.exists){
                    
                    guard let bookHistoryDictArray = document!["bookHistory"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }
                    
                    var bookHistoryArray: [History] = []
                    for bookHistoryDict in bookHistoryDictArray {
                        guard let userId = bookHistoryDict["userId"] as? String,
                              let userName = bookHistoryDict["userName"] as? String,
                              let issuedOn = bookHistoryDict["issuedOn"] as? String,
                              let returnedOn = bookHistoryDict["returnedOn"] as? String
                        else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let bookHistory = History(userId: userId, userName: userName, issuedOn: issuedOn, returnedOn: returnedOn)
                        bookHistoryArray.append(bookHistory)
                    }
                    
                    
                    self.currentBook = [ Book(id: document!["id"] as! String, bookISBN: document!["bookISBN"] as! String, bookImageURL: document!["bookImageURL"] as! String, bookName: document!["bookName"] as! String, bookAuthor: document!["bookAuthor"] as! String, bookDescription: document!["bookDescription"] as! String, bookCategory: document!["bookCategory"] as! String, bookSubCategories: document!["bookSubCategories"] as! [String], bookPublishingDate: document!["bookPublishingDate"] as! String, bookStatus: document!["bookStatus"] as! String, bookIssuedTo: document!["bookIssuedTo"] as! String, bookIssuedToName: document!["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: document!["bookIssuedOn"] as! String, bookExpectedReturnOn: document!["bookExpectedReturnOn"] as! String, bookRating: document!["bookRating"] as! Float, bookReviews: document!["bookReviews"] as! [String], bookHistory: bookHistoryArray, createdOn: document!["createdOn"] as! String, updayedOn: document!["updatedOn"] as! String) ]
                    self.responseStatus = 200
                    self.responseMessage = "Book fetched successfuly"
                }
                else{
                    self.responseStatus = 200
                    self.responseMessage = "Something went wrong, Unable to get book. Chek console for error"
                    print("Unable to get updated document. May be this could be the error: Book does not exist or db returned nil.")
                }
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Something went wrong, Unable to book. Chek console for error"
                print("Unable to get book. Error: \(String(describing: error)).")
            }
        }
    }
    
    func getBooks(){
        
        self.responseStatus = 0
        self.responseMessage = ""
        self.allBooks = []
        
        dbInstance.collection("Books").getDocuments{ (snapshot, error) in
            
            if(error == nil && snapshot != nil){
                for document in snapshot!.documents{
                    let documentData = document.data()
                    
                    guard let bookHistoryDictArray = documentData["bookHistory"] as? [[String: Any]] else {
                        print("Error: Unable to parse fineDetails array from Firestore document")
                        return
                    }
                    
                    var bookHistoryArray: [History] = []
                    for bookHistoryDict in bookHistoryDictArray {
                        guard let userId = bookHistoryDict["userId"] as? String,
                              let userName = bookHistoryDict["userName"] as? String,
                              let issuedOn = bookHistoryDict["issuedOn"] as? String,
                              let returnedOn = bookHistoryDict["returnedOn"] as? String
                        else {
                            print("Error: Unable to parse fineDetail from dictionary")
                            continue
                        }
                        
                        let bookHistory = History(userId: userId, userName: userName, issuedOn: issuedOn, returnedOn: returnedOn)
                        bookHistoryArray.append(bookHistory)
                    }
                    
                    let book = Book(id: documentData["id"] as! String as Any as! String, bookISBN: documentData["bookISBN"] as! String as Any as! String, bookImageURL: documentData["bookImageURL"] as! String as Any as! String, bookName: documentData["bookName"] as! String as Any as! String, bookAuthor: documentData["bookAuthor"] as! String as Any as! String, bookDescription: documentData["bookDescription"] as! String as Any as! String, bookCategory: documentData["bookCategory"] as! String as Any as! String, bookSubCategories: documentData["bookSubCategories"] as! [String] as Any as! [String], bookPublishingDate: documentData["bookPublishingDate"] as! String as Any as! String, bookStatus: documentData["bookStatus"] as! String as Any as! String, bookIssuedTo: documentData["bookIssuedTo"] as! String as Any as! String, bookIssuedToName: documentData["bookIssuedToName"] as! String as Any as! String, bookIssuedOn: documentData["bookIssuedOn"] as! String as Any as! String, bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as! String as Any as! String, bookRating: Float(documentData["bookRating"] as! Int as Any as! Int), bookReviews: documentData["bookReviews"] as! [String] as Any as! [String], bookHistory: bookHistoryArray, createdOn: documentData["createdOn"] as! String as Any as! String, updayedOn: documentData["updatedOn"] as! String as Any as! String)
                    self.allBooks.append(book)
                }
                print(self.allBooks)
            }
            
        }
        
    }
}