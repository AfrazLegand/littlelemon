//
//  DishDetailsView.swift
//  LittleLemon
//
//  Created by Afraz Siddiqui on 12/08/2024.
//

import SwiftUI

struct DishDetailsView: View {
    let dish: Dish
    
    var body: some View {
        VStack {
            Text(dish.title ?? "Unknown Item")
                .font(.largeTitle)
                .padding()
            
            if let imageUrl = dish.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 300, height: 200)
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }
            
            Text("Price: $\(dish.price ?? "0")")
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Dish Details")
        .padding()
    }
}

#Preview {
    DishDetailsView(dish: Dish(context: PersistenceController.shared.container.viewContext))
}
