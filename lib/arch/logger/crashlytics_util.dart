import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsUtil {
  static void recordError({
    String reason = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      printDetails: true,
      reason: reason,
    );
  }
}
