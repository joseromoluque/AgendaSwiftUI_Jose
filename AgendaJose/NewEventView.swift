//
//  NewEventView.swift
//  AgendaJose
//
//  Created by José Santiago  Romo Luque on 27/1/23.
//

import SwiftUI

struct NewEventView: View {
    @Binding var shouldShowNewEvent: Bool
    @State var date: Date = Date()
    @State var name: String = ""
    
    var completion: () -> () = {}
    
    var body: some View {
        ZStack{
            BackgroundColorView()
            VStack{
                Text("Nuevo Evento")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                TextField(" Introduce el nombre del evento", text: $name)
                    .frame(height: 60)
                    .frame(width: 370)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 15)
                
                Spacer()
                
                Button{
                    createEvent()
                    shouldShowNewEvent = false
                }label: {
                    Text("Confirmar")
                        .frame(height: 50)
                        .frame(width: 140)
                        .background(Color.white)
                        .font(.system(size: 30))
                        .cornerRadius(10)
                        .padding(.top, 15)
                }
            }
        }
    }
    private func eventRegister(name: String, date: Int) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        //params
        let dictionary: [String: Any] = [
            "name" : name,
            "date" : date
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
    func createEvent(){
        let myDate = convertDateToInt(date: date)
        eventRegister(name: name, date: myDate )
    }
    
    
    func onSuccess(){
        completion()
        shouldShowNewEvent = false
    }
    
    func convertDateToInt(date: Date) -> Int{
        let intDate = Int(date.timeIntervalSince1970 * 1000)
        return intDate
    }
    func onError(error: String) {
        
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(shouldShowNewEvent: .constant(true))
    }
}
