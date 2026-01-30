import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProfileEndpoint extends Endpoint {
  /// Create or update user profile from onboarding data
  Future<ProfileResponse> saveProfile(
    Session session, {
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
    try {
      // Check if profile already exists for this user
      final existingProfile = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );

      final now = DateTime.now().toUtc();

      if (existingProfile != null) {
        // Update existing profile
        final updatedProfile = existingProfile.copyWith(
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
          updatedAt: now,
        );

        final saved = await UserProfile.db.updateRow(session, updatedProfile);

        return ProfileResponse(
          success: true,
          message: 'Profile updated successfully.',
          profile: saved,
        );
      } else {
        // Create new profile
        final newProfile = UserProfile(
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
          createdAt: now,
          updatedAt: now,
        );

        final inserted = await UserProfile.db.insertRow(session, newProfile);

        return ProfileResponse(
          success: true,
          message: 'Profile created successfully.',
          profile: inserted,
        );
      }
    } catch (e) {
      session.log('Save profile failed: $e', level: LogLevel.error);

      return ProfileResponse(
        success: false,
        error: 'Failed to save profile: $e',
        profile: null,
      );
    }
  }

  /// Get user profile by user ID
  Future<ProfileResponse> getByUserId(
    Session session, {
    required UuidValue userId,
  }) async {
    try {
      final profile = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (profile == null) {
        return ProfileResponse(
          success: false,
          error: 'Profile not found.',
          profile: null,
        );
      }

      return ProfileResponse(
        success: true,
        profile: profile,
      );
    } catch (e) {
      session.log('Get profile failed: $e', level: LogLevel.error);

      return ProfileResponse(
        success: false,
        error: 'Failed to get profile: $e',
        profile: null,
      );
    }
  }

  /// Update specific profile fields
  Future<ProfileResponse> updateProfile(
    Session session, {
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
    try {
      final existingProfile = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (existingProfile == null) {
        return ProfileResponse(
          success: false,
          error: 'Profile not found. Please complete onboarding first.',
          profile: null,
        );
      }

      final updatedProfile = existingProfile.copyWith(
        skinType: skinType ?? existingProfile.skinType,
        skinSensitivity: skinSensitivity ?? existingProfile.skinSensitivity,
        oiliness: oiliness ?? existingProfile.oiliness,
        skinConcerns: skinConcerns ?? existingProfile.skinConcerns,
        primaryConcern: primaryConcern ?? existingProfile.primaryConcern,
        knownAllergies: knownAllergies ?? existingProfile.knownAllergies,
        currentMedications: currentMedications ?? existingProfile.currentMedications,
        skinConditionHistory: skinConditionHistory ?? existingProfile.skinConditionHistory,
        sunExposure: sunExposure ?? existingProfile.sunExposure,
        waterIntake: waterIntake ?? existingProfile.waterIntake,
        sleepQuality: sleepQuality ?? existingProfile.sleepQuality,
        stressLevel: stressLevel ?? existingProfile.stressLevel,
        skinGoals: skinGoals ?? existingProfile.skinGoals,
        preferredLanguage: preferredLanguage ?? existingProfile.preferredLanguage,
        productBudget: productBudget ?? existingProfile.productBudget,
        routineComplexity: routineComplexity ?? existingProfile.routineComplexity,
        updatedAt: DateTime.now().toUtc(),
      );

      final saved = await UserProfile.db.updateRow(session, updatedProfile);

      return ProfileResponse(
        success: true,
        message: 'Profile updated successfully.',
        profile: saved,
      );
    } catch (e) {
      session.log('Update profile failed: $e', level: LogLevel.error);

      return ProfileResponse(
        success: false,
        error: 'Failed to update profile: $e',
        profile: null,
      );
    }
  }
}
