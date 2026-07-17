import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:vaulta/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:vaulta/features/dashboard/domain/usecases/dashboard_usecases.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(
    remote: DashboardRemoteDataSource(ref.watch(dioProvider)),
  );
}

/// Dashboard read model. autoDispose on purpose: when the authenticated
/// shell unmounts (logout), the cache dies with it.
@riverpod
class DashboardController extends _$DashboardController {
  var _disposed = false;

  @override
  AsyncValue<DashboardSummary> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    // Kick the initial load exactly once, after build returns.
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  /// Reloads the summary. Existing data survives the round trip and any
  /// failure; the failure is returned for a transient surface (snackbar).
  Future<Failure?> refresh() => _load();

  Future<Failure?> _load() async {
    if (!state.hasValue) state = const AsyncLoading();
    final repository = ref.read(dashboardRepositoryProvider);
    final result = await GetDashboardSummary(repository).call(
      const NoParams(),
    );
    // The screen may have unmounted while the request was in flight.
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (summary) {
        state = AsyncData(summary);
        return null;
      },
      onFailure: (failure) {
        if (!state.hasValue) {
          state = AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          );
        }
        return failure;
      },
    );
  }
}

/// The account whose balance and history the balance card shows.
/// `null` means "the first account in the summary".
@riverpod
class SelectedAccountId extends _$SelectedAccountId {
  @override
  String? build() => null;

  void select(String id) {
    if (state == id) return;
    state = id;
  }
}
