//
//  ContentView.swift
//  AgendaJose
//
//  Created by José Santiago  Romo Luque on 27/1/23.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Private Properties
    
    @State private var email: String = ""
    @State private var pass: String = ""
    
    @State var shouldShowAgenda: Bool = false
    @State private var shouldShowRegister: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColorView()
                
                VStack {
                    TitleView(title: "Login")
                    
                    AgendaImageView()
                        .padding(.top, 20)
                    
                    textFields()
                    
                    Spacer()
                    
                    
                    
                    Spacer()
                    
                    loginButton(title: "Login")
                    
                    HStack{
                        Text("¿No tienes una cuenta?")
                        
                        NavigationLink{
                            RegisterView()
                        }label: {
                            Text ("Register")
                                .foregroundColor(.white)
                                .frame(height: 60)
                            
                        }
                    }
                }
            }
        }
        .accentColor(.white)
        
    }
    
    // MARK: - Accessory Views
    
    // Esta vista se puede sacar a la Extension de abajo pero está aqui para que sepais que tambien se puede quedar dentro del struct
    func textFields() -> some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .frame(height: 54)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.horizontal, 21)
                .padding(.top, 60)
            
            SecureField("Password", text: $pass)
                .frame(height: 54)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.horizontal, 21)
                .padding(.top, 5)
            
        }
    }
    func login(email: String, pass: String) {
       
       //baseUrl + endpoint
       let url = "https://superapi.netlify.app/api/register"
       
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
       // TODO: - Go to Agenda
       shouldShowAgenda = true
   }

   func onError(error: String) {
       
   }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


//MARK: - Extensions

extension LoginView {
    
    var loginButton: some View {
        Button {
            shouldShowRegister = true
        } label: {
            Text("Login")
                .foregroundColor(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(15)
                .padding(.horizontal, 21)

        }
        .background(
            NavigationLink(destination: RegisterView(), isActive: $shouldShowRegister) {
                EmptyView()
            }
        )
    }
    
    // Esta es otra manera de extraer las vistas, funciona exactamente igual que la var << loginButton: some View >>, no se esta llamando/utilizando pero la dejo aquí para que sepais ambas maneras.
    func loginButton(title: String) -> some View {
        Button {
            // call login action
            
            //shouldShowRegister = true
            login(email: email, pass: pass)
             
        } label: {
            Text(title)
                .foregroundColor(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(5)
                .padding(.horizontal, 21)

        }
        .background(
            NavigationLink(destination: AgendaView(), isActive: $shouldShowAgenda) {
                EmptyView()
            }
        )
    }
}
