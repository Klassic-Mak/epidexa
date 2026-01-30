import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/streak_service.dart';

/// State for streak data
class StreakState {
  final int currentStreak;
  final int totalCheckIns;
  final DateTime? lastCheckIn;
  final bool hasCheckedInToday;
  final bool isLoading;

  const StreakState({
    this.currentStreak = 0,
    this.totalCheckIns = 0,
    this.lastCheckIn,
    this.hasCheckedInToday = false,
    this.isLoading = true,
  });

  StreakState copyWith({
    int? currentStreak,
    int? totalCheckIns,
    DateTime? lastCheckIn,
    bool? hasCheckedInToday,
    bool? isLoading,
  }) {
    return StreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      hasCheckedInToday: hasCheckedInToday ?? this.hasCheckedInToday,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for managing streak state
class StreakNotifier extends Notifier<StreakState> {
  final _streakService = StreakService();

  @override
  StreakState build() {
    // Load streak data when provider is initialized
    _loadStreakData();
    return const StreakState();
  }

  /// Load streak data from local storage
  Future<void> _loadStreakData() async {
    try {
      final stats = await _streakService.getStreakStats();
      
      state = state.copyWith(
        currentStreak: stats['currentStreak'] as int,
        totalCheckIns: stats['totalCheckIns'] as int,
        lastCheckIn: stats['lastCheckIn'] as DateTime?,
        hasCheckedInToday: stats['hasCheckedInToday'] as bool,
        isLoading: false,
      );
      
      print('✅ [StreakProvider] Loaded streak data: ${stats['currentStreak']} days');
    } catch (e) {
      print('❌ [StreakProvider] Error loading streak data: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Record a check-in for today
  Future<void> checkIn() async {
    if (state.hasCheckedInToday) {
      print('⚠️ [StreakProvider] Already checked in today');
      return;
    }

    try {
      await _streakService.checkIn();
      
      // Reload data after check-in
      await _loadStreakData();
      
      print('✅ [StreakProvider] Check-in successful! Streak: ${state.currentStreak}');
    } catch (e) {
      print('❌ [StreakProvider] Error during check-in: $e');
    }
  }

  /// Refresh streak data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadStreakData();
  }

  /// Clear all streak data (for testing)
  Future<void> clearData() async {
    await _streakService.clearAllData();
    await _loadStreakData();
    print('🗑️ [StreakProvider] All data cleared');
  }
}

/// Provider for streak state
final streakProvider = NotifierProvider<StreakNotifier, StreakState>(() {
  return StreakNotifier();
});
