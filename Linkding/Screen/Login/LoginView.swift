//
//  Login.swift
//  Linkding
//
//  Created by bzima on 05.01.2023.
//

import AlertToast
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    init(saveAction: @escaping (_ url: String, _ token: String) -> Void) {
        self.viewModel = LoginViewModel(saveAction: saveAction)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(UIColor.systemBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack {
                Image("header")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                TextField("Url", text: $viewModel.url)
                    .textFieldStyle(LargeTextFieldStyle())
                    .padding(EdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0))
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                TextField("Token", text: $viewModel.token)
                    .textFieldStyle(LargeTextFieldStyle())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                Button(action: {
                    hideKeyboard()
                    viewModel.save()
                }, label: {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewModel.isValid ? .white : .gray)
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(8)
                })
                .disabled(!viewModel.isValid)
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(saveAction: {_,_ in })
    }
}
