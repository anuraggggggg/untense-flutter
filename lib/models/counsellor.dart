class Counsellor {
  final String id;
  final String fullName;
  final String profileImage;
  final String professionalTitle;
  final int age;
  final String location;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final bool verified;
  final String bio;
  final List<String> languages;
  final List<String> specialities;
  final List<String> qualifications;
  final double chatPrice;
  final double audioPrice;
  final double videoPrice;
  final String sessionDuration;
  final bool availableNow;
  final String nextAvailableSlot;

  const Counsellor({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.professionalTitle,
    required this.age,
    required this.location,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.verified,
    required this.bio,
    required this.languages,
    required this.specialities,
    required this.qualifications,
    required this.chatPrice,
    required this.audioPrice,
    required this.videoPrice,
    required this.sessionDuration,
    required this.availableNow,
    required this.nextAvailableSlot,
  });

  double get startingPrice {
    final prices = [chatPrice, audioPrice, videoPrice].where((p) => p > 0);
    if (prices.isEmpty) return 0;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    // Extract specialisations from API payload
    final List<String> specNames = [];
    if (json['specialisations'] is List) {
      for (var s in (json['specialisations'] as List)) {
        if (s is Map && s['specialisation'] is Map) {
          final specMap = s['specialisation'] as Map;
          if (specMap['name'] != null) {
            specNames.add(specMap['name'].toString());
          }
        } else if (s is Map && s['name'] != null) {
          specNames.add(s['name'].toString());
        }
      }
    } else if (json['specialities'] is List) {
      specNames.addAll((json['specialities'] as List).map((e) => e.toString()));
    }

    // Hourly rate parsing (if > 1000, e.g. 100000 in paise => ₹1000)
    double baseRate = 0.0;
    if (json['hourlyRateAmount'] != null) {
      final num raw = json['hourlyRateAmount'] as num;
      baseRate = raw >= 10000 ? (raw / 100.0) : raw.toDouble();
    } else if (json['chatPrice'] != null) {
      baseRate = (json['chatPrice'] as num).toDouble();
    }

    final double chat = json['chatPrice'] != null
        ? (json['chatPrice'] as num).toDouble()
        : (baseRate > 0 ? baseRate * 0.6 : 499.0);
    final double audio = json['audioPrice'] != null
        ? (json['audioPrice'] as num).toDouble()
        : (baseRate > 0 ? baseRate * 0.85 : 799.0);
    final double video = json['videoPrice'] != null
        ? (json['videoPrice'] as num).toDouble()
        : (baseRate > 0 ? baseRate : 1199.0);

    // Rating parsing (string "4.9" or num 4.9)
    double ratingVal = 0.0;
    if (json['ratingAverage'] != null) {
      ratingVal = double.tryParse(json['ratingAverage'].toString()) ?? 0.0;
    } else if (json['rating'] != null) {
      ratingVal = (json['rating'] as num).toDouble();
    }

    final String name = json['displayName']?.toString() ??
        json['fullName']?.toString() ??
        'Counsellor';
    final String qual = json['qualification']?.toString() ?? 'Specialist';
    final String title = json['professionalTitle']?.toString() ??
        (specNames.isNotEmpty ? specNames.first : qual);

    return Counsellor(
      id: json['id']?.toString() ?? '',
      fullName: name,
      profileImage: json['avatarUrl']?.toString() ??
          json['profileImage']?.toString() ??
          '',
      professionalTitle: title,
      age: (json['age'] as int?) ?? 34,
      location: json['location']?.toString() ?? 'India',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 5,
      rating: ratingVal > 0 ? ratingVal : 4.8,
      reviewCount: (json['ratingCount'] as num?)?.toInt() ??
          (json['reviewCount'] as num?)?.toInt() ??
          0,
      verified: json['isVerified'] == true || json['verified'] == true,
      bio: json['bio']?.toString() ??
          'Licensed mental wellness expert offering dedicated support.',
      languages: json['languages'] is List
          ? List<String>.from(json['languages'])
          : ['English', 'Hindi'],
      specialities:
          specNames.isNotEmpty ? specNames : ['Mental Health', 'Counselling'],
      qualifications: json['qualification'] != null
          ? [json['qualification'].toString()]
          : ['Certified Counsellor'],
      chatPrice: chat,
      audioPrice: audio,
      videoPrice: video,
      sessionDuration: json['sessionDuration']?.toString() ?? '45 mins',
      availableNow: json['availableNow'] == true || true,
      nextAvailableSlot:
          json['nextAvailableSlot']?.toString() ?? 'Available Today',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profileImage': profileImage,
      'professionalTitle': professionalTitle,
      'age': age,
      'location': location,
      'experienceYears': experienceYears,
      'rating': rating,
      'reviewCount': reviewCount,
      'verified': verified,
      'bio': bio,
      'languages': languages,
      'specialities': specialities,
      'qualifications': qualifications,
      'chatPrice': chatPrice,
      'audioPrice': audioPrice,
      'videoPrice': videoPrice,
      'sessionDuration': sessionDuration,
      'availableNow': availableNow,
      'nextAvailableSlot': nextAvailableSlot,
    };
  }
}
