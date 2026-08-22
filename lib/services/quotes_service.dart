import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuotesService {
  static const String _url = 'https://zenquotes.io/api/random';

  static const List<Quote> _fallbackQuotes = [
    Quote(
      quote: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
    ),
    Quote(
      quote: 'You don\'t have to control your thoughts. You just have to stop letting them control you.',
      author: 'Dan Millman',
    ),
    Quote(
      quote: 'Calmness is the cradle of power.',
      author: 'Josiah Gilbert Holland',
    ),
    Quote(
      quote: 'Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.',
      author: 'Thich Nhat Hanh',
    ),
  ];

  static Quote getRandomFallbackQuote() {
    final random = Random();
    return _fallbackQuotes[random.nextInt(_fallbackQuotes.length)];
  }

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
          final item = data[0] as Map<String, dynamic>;
          final quoteText = item['q'] as String?;
          final authorText = item['a'] as String?;
          if (quoteText != null && quoteText.trim().isNotEmpty) {
            return Quote(
              quote: quoteText.trim(),
              author: authorText?.trim().isNotEmpty == true
                  ? authorText!.trim()
                  : 'Unknown',
            );
          }
        }
      }
    } catch (_) {
      // Fallback silently if Network error, TimeoutException, parsing error etc.
    }
    return getRandomFallbackQuote();
  }
}
