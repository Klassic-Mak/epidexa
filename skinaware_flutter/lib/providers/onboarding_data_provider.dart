import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinaware_client/skinaware_client.dart';
import 'dart:convert';

/// Data model for onboarding information
class OnboardingData {
  // Basic Info
  final String? name;
  final int? age;
  final Gender? gender;

  // Skin Assessment
  final SkinType? skinType;
  final String? skinSensitivity; // low, medium, high
  final String? oiliness; // none, t-zone, all-over

  // Skin Concerns
  final List<String> skinConcerns;
  final String? primaryConcern;

  // Medical History
  final List<String> allergies;
  final List<String> medications;
  final List<String> skinConditionHistory;

  // Lifestyle
  final String? sunExposure; // minimal, moderate, high
  final String? waterIntake; // low, moderate, high
  final String? sleepQuality; // poor, fair, good, excellent
  final String? stressLevel; // low, moderate, high

  // Goals
  final List<String> skinGoals;

  // Preferences
  final String? preferredLanguage; // en, vi
  final String? productBudget; // budget, mid-range, premium
  final String? routineComplexity; // minimal, moderate, comprehensive

  const OnboardingData({
    this.name,
    this.age,
    this.gender,
    this.skinType,
    this.skinSensitivity,
    this.oiliness,
    this.skinConcerns = const [],
    this.primaryConcern,
    this.allergies = const [],
    this.medications = const [],
    this.skinConditionHistory = const [],
    this.sunExposure,
    this.waterIntake,
    this.sleepQuality,
    this.stressLevel,
    this.skinGoals = const [],
    this.preferredLanguage,
    this.productBudget,
    this.routineComplexity,
  });

  OnboardingData copyWith({
    String? name,
    int? age,
    Gender? gender,
    SkinType? skinType,
    String? skinSensitivity,
    String? oiliness,
    List<String>? skinConcerns,
    String? primaryConcern,
    List<String>? allergies,
    List<String>? medications,
    List<String>? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    List<String>? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      skinType: skinType ?? this.skinType,
      skinSensitivity: skinSensitivity ?? this.skinSensitivity,
      oiliness: oiliness ?? this.oiliness,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      primaryConcern: primaryConcern ?? this.primaryConcern,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      skinConditionHistory: skinConditionHistory ?? this.skinConditionHistory,
      sunExposure: sunExposure ?? this.sunExposure,
      waterIntake: waterIntake ?? this.waterIntake,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      stressLevel: stressLevel ?? this.stressLevel,
      skinGoals: skinGoals ?? this.skinGoals,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      productBudget: productBudget ?? this.productBudget,
      routineComplexity: routineComplexity ?? this.routineComplexity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender?.name,
      'skinType': skinType?.name,
      'skinSensitivity': skinSensitivity,
      'oiliness': oiliness,
      'skinConcerns': skinConcerns,
      'primaryConcern': primaryConcern,
      'allergies': allergies,
      'medications': medications,
      'skinConditionHistory': skinConditionHistory,
      'sunExposure': sunExposure,
      'waterIntake': waterIntake,
      'sleepQuality': sleepQuality,
      'stressLevel': stressLevel,
      'skinGoals': skinGoals,
      'preferredLanguage': preferredLanguage,
      'productBudget': productBudget,
      'routineComplexity': routineComplexity,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['name'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] != null
          ? Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.MALE)
          : null,
      skinType: json['skinType'] != null
          ? SkinType.values.firstWhere((e) => e.name == json['skinType'], orElse: () => SkinType.NORMAL)
          : null,
      skinSensitivity: json['skinSensitivity'] as String?,
      oiliness: json['oiliness'] as String?,
      skinConcerns: List<String>.from(json['skinConcerns'] ?? []),
      primaryConcern: json['primaryConcern'] as String?,
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      skinConditionHistory: List<String>.from(json['skinConditionHistory'] ?? []),
      sunExposure: json['sunExposure'] as String?,
      waterIntake: json['waterIntake'] as String?,
      sleepQuality: json['sleepQuality'] as String?,
      stressLevel: json['stressLevel'] as String?,
      skinGoals: List<String>.from(json['skinGoals'] ?? []),
      preferredLanguage: json['preferredLanguage'] as String?,
      productBudget: json['productBudget'] as String?,
      routineComplexity: json['routineComplexity'] as String?,
    );
  }

  /// Generate personalization summary for AI prompt
  String toPersonalizationPrompt() {
    final parts = <String>[];

    if (name != null) parts.add('Name: $name');
    if (age != null) parts.add('Age: $age years old');
    if (gender != null) parts.add('Gender: ${gender!.name.toLowerCase()}');
    if (skinType != null) parts.add('Skin Type: ${skinType!.name.toLowerCase().replaceAll('_', ' ')}');
    if (skinSensitivity != null) parts.add('Skin Sensitivity: $skinSensitivity');
    if (oiliness != null) parts.add('Oiliness: $oiliness');

    if (skinConcerns.isNotEmpty) {
      parts.add('Skin Concerns: ${skinConcerns.join(', ')}');
    }
    if (primaryConcern != null) {
      parts.add('Primary Concern: $primaryConcern');
    }

    if (allergies.isNotEmpty) {
      parts.add('Known Allergies: ${allergies.join(', ')}');
    }
    if (medications.isNotEmpty) {
      parts.add('Current Medications: ${medications.join(', ')}');
    }
    if (skinConditionHistory.isNotEmpty) {
      parts.add('Skin Condition History: ${skinConditionHistory.join(', ')}');
    }

    if (sunExposure != null) parts.add('Sun Exposure: $sunExposure');
    if (waterIntake != null) parts.add('Water Intake: $waterIntake');
    if (sleepQuality != null) parts.add('Sleep Quality: $sleepQuality');
    if (stressLevel != null) parts.add('Stress Level: $stressLevel');

    if (skinGoals.isNotEmpty) {
      parts.add('Skincare Goals: ${skinGoals.join(', ')}');
    }

    if (productBudget != null) parts.add('Product Budget: $productBudget');
    if (routineComplexity != null) parts.add('Routine Preference: $routineComplexity');

    if (parts.isEmpty) return '';

    return '''
## User Profile
${parts.join('\n')}

**Important:** Personalize all recommendations based on this profile. Consider their skin type, concerns, allergies, and goals when providing advice.
''';
  }

  bool get isComplete {
    return skinType != null &&
           skinConcerns.isNotEmpty &&
           skinGoals.isNotEmpty;
  }
}

/// Notifier for managing onboarding data
class OnboardingDataNotifier extends Notifier<OnboardingData> {
  @override
  OnboardingData build() => const OnboardingData();

  // Basic Info
  void setName(String name) => state = state.copyWith(name: name);
  void setAge(int age) => state = state.copyWith(age: age);
  void setGender(Gender gender) => state = state.copyWith(gender: gender);

  // Skin Assessment
  void setSkinType(SkinType skinType) => state = state.copyWith(skinType: skinType);
  void setSkinSensitivity(String sensitivity) => state = state.copyWith(skinSensitivity: sensitivity);
  void setOiliness(String oiliness) => state = state.copyWith(oiliness: oiliness);

  // Skin Concerns
  void setSkinConcerns(List<String> concerns) => state = state.copyWith(skinConcerns: concerns);
  void addSkinConcern(String concern) {
    if (!state.skinConcerns.contains(concern)) {
      state = state.copyWith(skinConcerns: [...state.skinConcerns, concern]);
    }
  }
  void removeSkinConcern(String concern) {
    state = state.copyWith(
      skinConcerns: state.skinConcerns.where((c) => c != concern).toList(),
    );
  }
  void setPrimaryConcern(String concern) => state = state.copyWith(primaryConcern: concern);

  // Medical History
  void setAllergies(List<String> allergies) => state = state.copyWith(allergies: allergies);
  void addAllergy(String allergy) {
    if (!state.allergies.contains(allergy)) {
      state = state.copyWith(allergies: [...state.allergies, allergy]);
    }
  }
  void removeAllergy(String allergy) {
    state = state.copyWith(
      allergies: state.allergies.where((a) => a != allergy).toList(),
    );
  }

  void setMedications(List<String> medications) => state = state.copyWith(medications: medications);
  void addMedication(String medication) {
    if (!state.medications.contains(medication)) {
      state = state.copyWith(medications: [...state.medications, medication]);
    }
  }
  void removeMedication(String medication) {
    state = state.copyWith(
      medications: state.medications.where((m) => m != medication).toList(),
    );
  }

  void setSkinConditionHistory(List<String> conditions) =>
    state = state.copyWith(skinConditionHistory: conditions);

  // Lifestyle
  void setSunExposure(String exposure) => state = state.copyWith(sunExposure: exposure);
  void setWaterIntake(String intake) => state = state.copyWith(waterIntake: intake);
  void setSleepQuality(String quality) => state = state.copyWith(sleepQuality: quality);
  void setStressLevel(String level) => state = state.copyWith(stressLevel: level);

  // Goals
  void setSkinGoals(List<String> goals) => state = state.copyWith(skinGoals: goals);
  void addSkinGoal(String goal) {
    if (!state.skinGoals.contains(goal)) {
      state = state.copyWith(skinGoals: [...state.skinGoals, goal]);
    }
  }
  void removeSkinGoal(String goal) {
    state = state.copyWith(
      skinGoals: state.skinGoals.where((g) => g != goal).toList(),
    );
  }

  // Preferences
  void setPreferredLanguage(String language) => state = state.copyWith(preferredLanguage: language);
  void setProductBudget(String budget) => state = state.copyWith(productBudget: budget);
  void setRoutineComplexity(String complexity) => state = state.copyWith(routineComplexity: complexity);

  // Persistence
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_data', jsonEncode(state.toJson()));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('onboarding_data');
    if (data != null) {
      state = OnboardingData.fromJson(jsonDecode(data));
    }
  }

  void reset() => state = const OnboardingData();
}

/// Provider for onboarding data
final onboardingDataProvider = NotifierProvider<OnboardingDataNotifier, OnboardingData>(() {
  return OnboardingDataNotifier();
});

/// Provider for user profile (loaded from server)
final userProfileProvider = StateProvider<UserProfile?>((ref) => null);
