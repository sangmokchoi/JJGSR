
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class GoogleAnalytics {

  Future<void> clickedCategoryEvent(String value) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: "clicked_category",
        parameters: {
          "category": value,
        },
      );
      debugPrint("clickedCategoryEvent 완료");
    } catch (e) {
      debugPrint("clickedCategoryEvent e: $e");
    }
  }

}