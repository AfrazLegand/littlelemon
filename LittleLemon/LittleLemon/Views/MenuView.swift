//
//  MenuView.swift
//  LittleLemon
//
//  Created by Afraz Siddiqui on 11/08/2024.
//

import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = []
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Little Lemon")
                    .font(.largeTitle)
                    .padding()
                Text("Chicago")
                    .font(.title2)
                    .padding(.bottom)
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .padding(.bottom)
                TextField("Search menu", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List(dishes) { dish in
                        NavigationLink(destination: DishDetailsView(dish: dish)) {
                            HStack {
                                Text("\(dish.title ?? "Unknown Title") - $\(dish.price ?? "0.00")")
                                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                    image.resizable()
                                         .scaledToFit()
                                         .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                getMenuData()
            }
        }
    }
    
    func getMenuData() {
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            if let menuList = try? decoder.decode(MenuList.self, from: data) {
                DispatchQueue.main.async {
                    self.saveMenuItems(menuList.menu)
                }
            }
        }.resume()
    }
    
    private func saveMenuItems(_ menuItems: [MenuItem]) {
        let existingDishes = fetchExistingDishes()
        
        for item in menuItems {
            if let existingDish = existingDishes.first(where: { $0.title == item.title }) {
                existingDish.image = item.image
                existingDish.price = item.price
            } else {
                let dish = Dish(context: viewContext)
                dish.title = item.title
                dish.image = item.image
                dish.price = item.price
            }
        }

        try? viewContext.save()
    }
    
    private func fetchExistingDishes() -> [Dish] {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch existing dishes: \(error)")
            return []
        }
    }
    
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }
    
    private func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
}
