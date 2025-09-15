import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_review/in_app_review.dart';

/// Service to handle in-app reviews for both iOS and Android.
///
/// Uses the `in_app_review` package. If in-app review is not available,
/// it falls back to opening the store listing URL specified in `.env`
/// under the key `STORE_URL`.
class InAppReviewService {
  /// Instance of the in-app review plugin
  final InAppReview _inAppReview = InAppReview.instance;

  /// Requests an in-app review.
  ///
  /// - If the in-app review dialog is available, it will be shown to the user.
  /// - Otherwise, it will open the store listing using the URL from `.env`.
  ///
  /// Make sure to load the `.env` file in `main.dart` using:
  /// ```dart
  /// await dotenv.load(fileName: ".env");
  /// ```
  Future<void> requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        // Show the native in-app review dialog
        await _inAppReview.requestReview();
      } else {
        // Fallback: open store listing from .env
        final storeUrl = dotenv.env['STORE_URL'] ?? '';
        if (storeUrl.isNotEmpty) {
          await _inAppReview.openStoreListing(appStoreId: storeUrl);
        } else {
          print('STORE_URL is not set in .env');
        }
      }
    } catch (e) {
      print('Error requesting in-app review: $e');
    }
  }
}
