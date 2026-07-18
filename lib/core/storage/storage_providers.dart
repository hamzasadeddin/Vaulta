import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/storage/app_database.dart';

/// One database per app. Deliberately not autoDispose: closing the cache
/// mid-session would tear it out from under active Drift streams; logout
/// clears session state, not the on-device cache.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
