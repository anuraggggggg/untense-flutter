import 'package:flutter/foundation.dart';

/// Mood options for the home check-in.
enum MoodType {
  calm,
  okay,
  stressed,
  low,
}

extension MoodTypeX on MoodType {
  String get label => switch (this) {
        MoodType.calm => 'Calm',
        MoodType.okay => 'Okay',
        MoodType.stressed => 'Stressed',
        MoodType.low => 'Low',
      };

  String get emoji => switch (this) {
        MoodType.calm => '🌿',
        MoodType.okay => '☁️',
        MoodType.stressed => '🌊',
        MoodType.low => '🌙',
      };
}

/// Holds dashboard UI state (mood check-in, etc.).
class DashboardProvider extends ChangeNotifier {
  MoodType? _selectedMood;

  MoodType? get selectedMood => _selectedMood;

  void selectMood(MoodType mood) {
    if (_selectedMood == mood) {
      _selectedMood = null;
    } else {
      _selectedMood = mood;
    }
    notifyListeners();
  }
}
