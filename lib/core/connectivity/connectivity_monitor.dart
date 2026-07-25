import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A hint that the device *may* be able to reach the network again.
///
/// **Not a source of truth, and the distinction is load-bearing.**
/// `connectivity_plus` reports the state of the network *interface*, not
/// reachability: a captive portal, a VPN that dropped, DNS that is down
/// and an API that is returning 503 all report "connected". Building an
/// outbox that decides whether to send based on this is the classic
/// offline-sync bug.
///
/// So this only ever *wakes* the drain. Whether a confirm actually
/// worked is decided by the confirm's own response, every time.
abstract interface class ConnectivityMonitor {
  /// Fires when at least one interface comes up. Coalescing, debouncing
  /// and "is it really up" are all deliberately not this type's job.
  Stream<void> get onRestored;
}

/// `connectivity_plus` adapter.
///
/// Kept to four lines on purpose: this is the one file in the delta
/// whose API surface belongs to an unpinned third-party package, so if
/// `pub get` resolves a major version whose stream emits a single
/// `ConnectivityResult` rather than a list, the fix is contained here.
class PlatformConnectivityMonitor implements ConnectivityMonitor {
  PlatformConnectivityMonitor([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<void> get onRestored => _connectivity.onConnectivityChanged
      .where((results) => results.any((r) => r != ConnectivityResult.none))
      .map((_) {});
}

/// A monitor that never fires. The drain still runs at startup, on a
/// manual retry and on its own backoff timer, so an app without
/// connectivity signals degrades to polling rather than to nothing.
class SilentConnectivityMonitor implements ConnectivityMonitor {
  const SilentConnectivityMonitor();

  @override
  Stream<void> get onRestored => const Stream<void>.empty();
}

/// Overridden in tests with a controllable stream.
final connectivityMonitorProvider = Provider<ConnectivityMonitor>(
  (ref) => PlatformConnectivityMonitor(),
);
