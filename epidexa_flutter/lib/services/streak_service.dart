import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _lastCheckInKey = 'last_check_in_date';
  static const String _streakCountKey = 'streak_count';
  static const String _totalCheckInsKey = 'total_check_ins';

  /// Check if user has checked in today
  Future<bool> hasCheckedInToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckIn = prefs.getString(_lastCheckInKey);
    
    if (lastCheckIn == null) return false;
    
    final lastDate = DateTime.parse(lastCheckIn);
    final today = DateTime.now();
    
    return _isSameDay(lastDate, today);
  }

  /// Record a check-in for today
  Future<void> checkIn() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = _formatDate(today);
    
    // Check if already checked in today
    if (await hasCheckedInToday()) {
      print('⚠️ [StreakService] Already checked in today');
      return;
    }
    
    final lastCheckIn = prefs.getString(_lastCheckInKey);
    int currentStreak = prefs.getInt(_streakCountKey) ?? 0;
    int totalCheckIns = prefs.getInt(_totalCheckInsKey) ?? 0;
    
    if (lastCheckIn != null) {
      final lastDate = DateTime.parse(lastCheckIn);
      final yesterday = today.subtract(const Duration(days: 1));
      
      if (_isSameDay(lastDate, yesterday)) {
        // Consecutive day - increment streak
        currentStreak++;
        print('✅ [StreakService] Consecutive day! Streak: $currentStreak');
      } else if (!_isSameDay(lastDate, today)) {
        // Streak broken - reset to 1
        currentStreak = 1;
        print('🔄 [StreakService] Streak broken. Starting fresh: $currentStreak');
      }
    } else {
      // First check-in ever
      currentStreak = 1;
      print('🎉 [StreakService] First check-in! Streak: $currentStreak');
    }
    
    // Increment total check-ins
    totalCheckIns++;
    
    // Save to SharedPreferences
    await prefs.setString(_lastCheckInKey, todayString);
    await prefs.setInt(_streakCountKey, currentStreak);
    await prefs.setInt(_totalCheckInsKey, totalCheckIns);
    
    print('💾 [StreakService] Saved - Streak: $currentStreak, Total: $totalCheckIns');
  }

  /// Get current streak count
  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final streak = prefs.getInt(_streakCountKey) ?? 0;
    final lastCheckIn = prefs.getString(_lastCheckInKey);
    
    // Check if streak is still valid (not broken)
    if (lastCheckIn != null && streak > 0) {
      final lastDate = DateTime.parse(lastCheckIn);
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      
      // If last check-in was today or yesterday, streak is valid
      if (_isSameDay(lastDate, today) || _isSameDay(lastDate, yesterday)) {
        return streak;
      } else {
        // Streak broken - reset
        await _resetStreak();
        return 0;
      }
    }
    
    return streak;
  }

  /// Get total number of check-ins
  Future<int> getTotalCheckIns() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCheckInsKey) ?? 0;
  }

  /// Get last check-in date
  Future<DateTime?> getLastCheckInDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckIn = prefs.getString(_lastCheckInKey);
    
    if (lastCheckIn == null) return null;
    
    return DateTime.parse(lastCheckIn);
  }

  /// Reset streak (used when streak is broken)
  Future<void> _resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakCountKey, 0);
    print('🔄 [StreakService] Streak reset to 0');
  }

  /// Clear all streak data (for testing or reset)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastCheckInKey);
    await prefs.remove(_streakCountKey);
    await prefs.remove(_totalCheckInsKey);
    print('🗑️ [StreakService] All data cleared');
  }

  /// Helper: Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Helper: Format date to string (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get streak statistics
  Future<Map<String, dynamic>> getStreakStats() async {
    final currentStreak = await getCurrentStreak();
    final totalCheckIns = await getTotalCheckIns();
    final lastCheckIn = await getLastCheckInDate();
    final hasCheckedToday = await hasCheckedInToday();
    
    return {
      'currentStreak': currentStreak,
      'totalCheckIns': totalCheckIns,
      'lastCheckIn': lastCheckIn,
      'hasCheckedInToday': hasCheckedToday,
    };
  }
}
