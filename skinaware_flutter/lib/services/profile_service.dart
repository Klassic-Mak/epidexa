import 'package:skinaware_client/skinaware_client.dart';

class ProfileService {
  final Client _client;

  ProfileService(this._client);

  /// Save user profile from onboarding data
  Future<ProfileResponse> saveProfile({
    required UuidValue userId,
    required SkinType skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
  }) async {
    return await _client.profile.saveProfile(
      userId: userId,
      skinType: skinType,
      skinSensitivity: skinSensitivity,
      oiliness: oiliness,
      skinConcerns: skinConcerns,
      primaryConcern: primaryConcern,
      knownAllergies: knownAllergies,
      currentMedications: currentMedications,
      skinConditionHistory: skinConditionHistory,
      sunExposure: sunExposure,
      waterIntake: waterIntake,
      sleepQuality: sleepQuality,
      stressLevel: stressLevel,
      skinGoals: skinGoals,
      preferredLanguage: preferredLanguage,
      productBudget: productBudget,
      routineComplexity: routineComplexity,
    );
  }

  /// Get user profile by user ID
  Future<ProfileResponse> getProfile(UuidValue userId) async {
    return await _client.profile.getByUserId(userId: userId);
  }

  /// Update user profile
  Future<ProfileResponse> updateProfile({
    required UuidValue userId,
    SkinType? skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
  }) async {
    return await _client.profile.updateProfile(
      userId: userId,
      skinType: skinType,
      skinSensitivity: skinSensitivity,
      oiliness: oiliness,
      skinConcerns: skinConcerns,
      primaryConcern: primaryConcern,
      knownAllergies: knownAllergies,
      currentMedications: currentMedications,
      skinConditionHistory: skinConditionHistory,
      sunExposure: sunExposure,
      waterIntake: waterIntake,
      sleepQuality: sleepQuality,
      stressLevel: stressLevel,
      skinGoals: skinGoals,
      preferredLanguage: preferredLanguage,
      productBudget: productBudget,
      routineComplexity: routineComplexity,
    );
  }
}
