import 'package:flutter/foundation.dart';
import '../models/counsellor.dart';
import '../services/counsellor_service.dart';

class CounsellorProvider extends ChangeNotifier {
  final CounsellorService _service = CounsellorService();

  List<Counsellor> _counsellors = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Counsellor> get counsellors => _counsellors;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => const [
        'All',
        'Psychologist',
        'Clinical Psychologist',
        'Relationship Counsellor',
        'Marriage Counsellor',
        'Career Counsellor',
        'Therapist',
        'Life Coach',
      ];

  List<Counsellor> get filteredCounsellors {
    final query = _searchQuery.trim().toLowerCase();
    return _counsellors.where((c) {
      final matchesCategory = _selectedCategory == 'All' ||
          c.professionalTitle
              .toLowerCase()
              .contains(_selectedCategory.toLowerCase());
      final matchesSearch = query.isEmpty ||
          c.fullName.toLowerCase().contains(query) ||
          c.professionalTitle.toLowerCase().contains(query) ||
          c.specialities.any((s) => s.toLowerCase().contains(query)) ||
          c.location.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> fetchCounsellors() async {
    _isLoading = true;
    notifyListeners();
    try {
      _counsellors = await _service.getCounsellors();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Counsellor?> getCounsellorById(String id) async {
    // Check local list first
    final cached = _counsellors.where((c) => c.id == id);
    if (cached.isNotEmpty) {
      return cached.first;
    }
    // Otherwise fetch from service
    return await _service.getCounsellorById(id);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
