import Foundation

struct MealDetail: Decodable {
    let name: String
    let instructions: String
    let ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case instructions = "strInstructions"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)

        // Extract ingredients and measurements
        var ingredientsArray: [String] = []
        for i in 1...20 {
            if let ingredient = try container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strIngredient\(i)")!),
               let measure = try container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strMeasure\(i)")!),
               !ingredient.isEmpty, !measure.isEmpty {
                ingredientsArray.append("\(ingredient) - \(measure)")
            }
        }
        ingredients = ingredientsArray
    }
}

struct MealDetailResponse: Decodable {
    let meals: [MealDetail]
}
