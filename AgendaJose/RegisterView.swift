//
//  RegisterView.swift
//  AgendaJose
//
//  Created by José Santiago  Romo Luque on 27/1/23.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: - Private Properties
    
    @State private var email: String = ""
    @State private var pass: String = ""
    
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            BackgroundColorView()
            
            VStack(spacing: 20) {
                
                TitleView(title: "Register")
                
                AgendaImageView()
                
                TextField("Email", text: $email)
                    .frame(height: 54)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 21)
                    .padding(.top, 40)
                
                SecureField("Password", text: $pass)
                    .frame(height: 54)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 21)
                    .padding(.top, 20)

                
                Spacer()
                
                
                Button {
                    // TODO: - Register Action
                    register(email: email, pass: pass)
                    
                } label: {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(15)
                        .padding(.horizontal, 21)
                }
                
                
            }
        }
        // Estas dos lineas sirven para esconder el nav bar de arriba en caso de que quisieseis hacerlo
        //.navigationBarBackButtonHidden(true)
        //.navigationTitle(Text(""))
    }
    
    // MARK: - Private Methods
    
    // Llamada a la petición de NetworkHelper que pronto pasaremos a viewModel
    private func register(email: String, pass: String) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/db/register"
        
        //params
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : pass
        ]
        
        // petición
        NetworkHelper.shared.requestProvider(url: url, params: dictionary) { data, response, error in
            if let error = error {
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 { // esto daria ok
                    onSuccess()
                } else { // esto daria error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    func onSuccess() {
        mode.wrappedValue.dismiss()
    }
    
    func onError(error: String) {
        
    }
}


// MARK: - Previews

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
