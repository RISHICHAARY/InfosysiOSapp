////
////  ProfileCompletedView.swift
////  Library Management System
////
////  Created by Abhishek Jadaun on 09/05/24.
////
//
//import SwiftUI
//
//struct ProfileCompletedView: View {
//    
//    @State var name: String = ""
//    @State var email: String = ""
//    @State var mobile: String = ""
//    
//    @State var isShowingImagePicker = false
//    @State var isImageSelected = false
//    @State var selectedImage: UIImage = UIImage()
//    
//    @State private var showConfirmationAlert = false
//    @State private var navigateToProfileView = false
//    @Environment(\.presentationMode) var presentationMode
//    
//    @EnvironmentObject var themeManager: ThemeManager
//    @ObservedObject var LibViewModel: LibrarianViewModel
//    @ObservedObject var configViewModel: ConfigViewModel
//    
//    var body: some View {
//        ScrollView{
//            VStack{
//                VStack {
//                    Button(action: {
//                        isShowingImagePicker.toggle()
//                    }) {
//                        ZStack {
//                            if isImageSelected {
//                                Image(uiImage: selectedImage)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 150, height: 150)
//                                    .clipShape(Circle())
//                                    .onTapGesture {
//                                        isShowingImagePicker.toggle()
//                                    }
//                            } else {
//                                AsyncImage(url: URL(string: LibViewModel.currentMember[0].profileImage)) { image in
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 140, height: 140)
//                                        .clipShape(Circle())
//                                        .padding(.top, 20)
//                                } placeholder: {
//                                    Image(systemName: "person.circle.fill")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 140, height: 140)
//                                        .clipShape(Circle())
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                    .sheet(isPresented: $isShowingImagePicker) {
//                        ImagePicker(selectedImage: $selectedImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary)
//                    }
//                }
//                VStack(alignment: .leading) {
//                    
//                    Text("Name:")
//                        .font(.callout)
//                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
//                    CustomTextField(text: $name, placeholder: "")
//                    Text("Mobile:")
//                        .font(.callout)
//                        .foregroundColor(themeManager.selectedTheme.bodyTextColor)
//                    CustomTextField(text: $mobile, placeholder: "")
//                        .keyboardType(.phonePad)
//                }
//                .padding()
//                
//                SecondaryCustomButton(action: {
//                    showConfirmationAlert = true
//                }, label: "Update Details")
//                .alert(isPresented: $showConfirmationAlert, content: {
//                    Alert(
//                        title: Text("Save Changes"),
//                        message: Text("Are you sure you want to update your details?"),
//                        primaryButton: .cancel(Text("Cancel")),
//                        secondaryButton: .default(Text("OK"), action: {
//                            LibViewModel.updateStaff(userID: LibViewModel.currentMember[0].userID, name: name, email: email, mobile: mobile, profilePhoto: selectedImage, isImageUpdated: isImageSelected)
//                        })
//                    )
//                })
//                .padding()
//                
//                NavigationLink(value: navigateToProfileView) {
//                    Text("")
//                }
//                .navigationDestination(isPresented: $navigateToProfileView) {
//                    ProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel)
//                }
//                .navigationTitle("Edit Details")
//            }
//            .navigationBarBackButtonHidden()
//            .task {
//                name = LibViewModel.currentMember[0].name
//                mobile = LibViewModel.currentMember[0].mobile
//                email = LibViewModel.currentMember[0].email
//            }
//        }
//    }
//}
//
////struct ProfileCompletedView_Previews: PreviewProvider {
////    static var previews: some View {
////        @State var staffViewModel = StaffViewModel()
////
////        let themeManager = ThemeManager()
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'ZZZ"
////        let createdOnDate = dateFormatter.date(from: "April 24, 2024 at 12:40:44 PM UTC+5:30") ?? Date()
////        let updatedOnDate = dateFormatter.date(from: "April 24, 2024 at 12:40:44 PM UTC+5:30") ?? Date()
////        let sampleStaff = Staff(
////            userID: "VzCFTZhEjoMZpFuzBw1Kt1S1AGm1",
////            name: "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/staffProfileImages%2F35PmRqJThks5zqXgn02g.jpeg?alt=media&token=6334f513-e00e-4d77-83fe-e9be3dae9c5a",
////            email: "Manvi Singhal",
////            mobile: "librarian",
////            profileImageURL: "manvi.singhal03@gmail.com",
////            aadhar: "6976927239",
////            role: "789269282392",
////            password: "gyhg",
////            createdOn: createdOnDate,
////            updatedOn: updatedOnDate
////        )
////
////        return ProfileCompletedView()
////            .environmentObject(themeManager)
////    }
////}