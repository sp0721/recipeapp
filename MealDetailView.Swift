import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @State private var mealDetail: MealDetail?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let meal = mealDetail {
                Text(meal.name)
                    .font(.title)
                    .padding(.bottom, 10)

                Text("Instructions")
                    .font(.headline)
                Text(meal.instructions)

                Text("Ingredients")
                    .font(.headline)
                ForEach(meal.ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .task {
            await loadMealDetail()
        }
    }

    func loadMealDetail() async {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
            mealDetail = decodedResponse.meals.first
        } catch {
            print("Failed to load meal details: \(error)")
        }
    }
}
