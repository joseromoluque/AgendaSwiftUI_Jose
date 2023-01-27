//
//  AgendaView.swift
//  AgendaJose
//
//  Created by José Santiago  Romo Luque on 27/1/23.
//

import SwiftUI

struct EventResponseModel: Decodable {
    let name: String?
    let date: Int?
    
    enum CodingKeys: String, CodingKey{
        case name
        case date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = Int(date)
        }else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        }else if let _ = try? values.decodeIfPresent(Float.self, forKey: .date) {
            self.date = nil
        }else{
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct EventPresentationModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Int
}

struct AgendaView: View {
    @State var dateSelected: Date = Date()
    @State var events: [EventPresentationModel] = []
    @State var shouldShowNewEvent = false
    var body: some View {
        ZStack{
            Color.cyan.ignoresSafeArea()
            VStack {
                Text("Agenda")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                DatePicker("", selection: $dateSelected, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(events) { event in
                            HStack{
                                Text(event.name)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("\(event.date)")
                                    .padding(.trailing, 10)
                            }
                            .frame(height: 40)
                            .background(Color.white)
                            .padding(.horizontal, 10)
                            
                            
                        }
                    }
                }
            }
        }
        
        .sheet(isPresented: $shouldShowNewEvent, content: {
            NewEventView(shouldShowNewEvent: $shouldShowNewEvent){
                getEvents()
            }
        })
        .toolbar {
            Button{
                shouldShowNewEvent = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 17))
            }
            .accentColor(.white)
        }

        .onAppear {
            getEvents()
        }
    }
    
    func getEvents () {
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        
        NetworkHelper.shared.requestProvider(url: url, type: .GET) { data, response, error in
            if let error = error {
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 { // esto daria ok
                    onSuccess(data: data)
                } else { // esto daria error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    
    func onSuccess(data: Data) {
        // TODO: - Go to Agenda
        do {
            let eventsNotFiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            
            self.events = eventsNotFiltered.compactMap({eventNotFiltered in
                guard let date = eventNotFiltered?.date else {return nil}
                
                return EventPresentationModel(name: eventNotFiltered?.name ?? "Empty name", date: date)
            })
        }catch {
            self.onError(error: error.localizedDescription)
        }
        
    }
    
    func onError(error: String) {
        print(error)
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView()
    }
}
