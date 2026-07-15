import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Single app-wide logger. Overridden in `bootstrap()` so the instance that
/// captures framework/zone errors is the same one the provider graph sees.
final talkerProvider = Provider<Talker>((ref) => TalkerFlutter.init());
