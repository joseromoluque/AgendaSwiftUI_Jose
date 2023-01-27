//
//  Components.swift
//  AgendaJose
//
//  Created by José Santiago  Romo Luque on 27/1/23.
//

import SwiftUI


// MARK: - Public Components

// Estas vistas son reutilizables por cualquier Vista/Pantalla ya que no pertenecen a ninguna en concreto, son públicas

struct BackgroundColorView: View {
    var body: some View {
        Color.cyan.ignoresSafeArea()
    }
}

struct TitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .font(.system(size: 30, weight: .bold))
            .padding(.top, 20)
    }
}

struct AgendaImageView: View {
    var body: some View {
        Image("Agendapng")
            .resizable()
            .frame(width: 170, height: 170)
            //.clipShape(Circle())
    }
}
