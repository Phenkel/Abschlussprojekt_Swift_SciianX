//
//  EditProfileView.swift
//  SciianX
//
//  Created by Philipp Henkel on 23.01.24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var imageItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var name: String = ""
    @State private var description: String = ""
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundImage()
            
            Form {
                ZStack {
                    ProfilePictureBig(self.authenticationViewModel.user, image: self.$image)
                    
                    PhotosPicker(
                        selection: $imageItem,
                        matching: .images,
                        label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    )
                }
                .listRowBackground(Color.clear)
                //.padding(.vertical, -20)
                
                Section("User Info") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                .textFieldStyle(.roundedBorder)
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
                
                Section("Save") {
                    BigButton(
                        label: "Save Changes",
                        color: .blue,
                        action: {
                            self.userViewModel.updateFirebaseUser(
                                realName: self.name,
                                description: self.description,
                                image: self.image
                            )
                            self.dismiss()
                        }
                    )
                }
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
                
                
                Section("Account Settings") {
                    BigButton(
                        label: "Logout",
                        color: .red,
                        action: {
                            self.authenticationViewModel.logout()
                        }
                    )
                    
                    BigButton(
                        label: "Delete Account",
                        color: .red,
                        action: {
                            // MARK: DELETE ACCOUNT ACTION
                        }
                    )
                }
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(.blue)
            .scrollContentBackground(.hidden)
        }
        .onChange(of: self.imageItem) { image in
            self.userViewModel.convertImagePicker(self.imageItem) { image in
                self.image = image
            }
        }
        .onAppear {
            self.name = self.userViewModel.user?.realName ?? ""
            self.description = self.userViewModel.user?.description ?? ""
        }
    }
}
