import 'package:flutter/foundation.dart';
import '../models/counsellor.dart';
import '../services/counsellor_service.dart';

class CounsellorProvider extends ChangeNotifier {
  final CounsellorService _service = CounsellorService();

  List<Counsellor> _counsellors = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'rating';

  List<Counsellor> get counsellors => _counsellors;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  List<String> get categories {
    final set = <String>{'All'};
    for (var c in _counsellors) {
      if (c.professionalTitle.isNotEmpty) {
        set.add(c.professionalTitle);
      }
      for (var spec in c.specialities) {
        if (spec.isNotEmpty) set.add(spec);
      }
    }
    return set.toList();
  }

  List<Counsellor> get filteredCounsellors {
    final query = _searchQuery.trim().toLowerCase();
    var list = _counsellors.where((c) {
      final matchesCategory = _selectedCategory == 'All' ||
          c.professionalTitle
              .toLowerCase()
              .contains(_selectedCategory.toLowerCase()) ||
          c.specialities.any(
            (s) => s.toLowerCase().contains(_selectedCategory.toLowerCase()),
          );
      final matchesSearch = query.isEmpty ||
          c.fullName.toLowerCase().contains(query) ||
          c.professionalTitle.toLowerCase().contains(query) ||
          c.specialities.any((s) => s.toLowerCase().contains(query)) ||
          c.location.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortBy == 'price_low') {
      list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    } else if (_sortBy == 'price_high') {
      list.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
    } else if (_sortBy == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  Future<void> fetchCounsellors() async {
    _isLoading = true;
    notifyListeners();
    try {
      _counsellors = await _service.getCounsellors(
        search: _searchQuery,
        sortBy: _sortBy,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Counsellor?> getCounsellorById(String id) async {
    final cached = _counsellors.where((c) => c.id == id);
    if (cached.isNotEmpty) {
      return cached.first;
    }
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

  void setSortBy(String sort) {
    _sortBy = sort;
    fetchCounsellors();
  }
}
