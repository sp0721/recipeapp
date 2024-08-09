import SwiftUI

struct ContentView: View {
    @State private var meals: [Meal] = []

    var body: some View {
        NavigationView {
            List(meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                    Text(meal.name)
                }
            }
            .navigationTitle("Desserts")
            .task {
                await loadDesserts()
            }
        }
    }

    func loadDesserts() async {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            meals = decodedResponse.meals.sorted(by: { $0.name < $1.name })
        } catch {
            print("Failed to load meals: \(error)")
        }
    }
}
