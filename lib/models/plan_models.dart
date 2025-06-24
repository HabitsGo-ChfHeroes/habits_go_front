class PlanMealIngredient {
  final String name;
  final double quantity;
  final String unit;

  PlanMealIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory PlanMealIngredient.fromJson(Map<String, dynamic> json) {
    return PlanMealIngredient(
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'],
    );
  }
}

class PlanMealFood {
  final String name;
  final String preparation;
  final String videoUrl;
  final List<PlanMealIngredient> ingredients;

  PlanMealFood({
    required this.name,
    required this.preparation,
    required this.videoUrl,
    required this.ingredients,
  });

  factory PlanMealFood.fromJson(Map<String, dynamic> json) {
    return PlanMealFood(
      name: json['name'],
      preparation: json['preparation'],
      videoUrl: json['video_url'],
      ingredients: (json['ingredients'] as List)
          .map((e) => PlanMealIngredient.fromJson(e))
          .toList(),
    );
  }
}

class PlanMeal {
  final int planFoodId;
  final String name;
  final String hour;
  final String status;
  final PlanMealFood food;

  PlanMeal({
    required this.planFoodId,
    required this.name,
    required this.hour,
    required this.status,
    required this.food,
  });

  factory PlanMeal.fromJson(Map<String, dynamic> json) {
    return PlanMeal(
      planFoodId: json['plan_food_id'],
      name: json['name'],
      hour: json['hour'],
      status: json['status'],
      food: PlanMealFood.fromJson(json['food']),
    );
  }
}

class PlanDetailResponse {
  final String date;
  final List<PlanMeal> meals;

  PlanDetailResponse({
    required this.date,
    required this.meals,
  });

  factory PlanDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlanDetailResponse(
      date: json['date'],
      meals: (json['meals'] as List)
          .map((e) => PlanMeal.fromJson(e))
          .toList(),
    );
  }
}
