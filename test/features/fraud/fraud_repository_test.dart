import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/features/fraud/data/repositories/fraud_repository_impl.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

import 'support/fake_fraud.dart';

void main() {
  late ControllableFraudFeed feed;
  late FraudRepositoryImpl repository;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    feed = ControllableFraudFeed();
    repository = FraudRepositoryImpl(feed: feed);
  });

  tearDown(() async {
    repository.dispose();
    await feed.close();
  });

  /// Subscribes and keeps the latest emitted snapshot.
  ({List<FraudAlert> Function() latest, Future<void> Function() cancel})
      observe() {
    var value = const <FraudAlert>[];
    final sub = repository.watch().listen((result) {
      result.onSuccess((v) => value = v);
    });
    return (latest: () => value, cancel: sub.cancel);
  }

  test('an arriving alert appears in the store', () async {
    final o = observe();
    feed.emit(fraudAlert(id: 'a'));
    await settle();

    expect(o.latest().map((a) => a.id), ['a']);
    await o.cancel();
  });

  test('alerts are held newest first', () async {
    final o = observe();
    feed
      ..emit(fraudAlert(id: 'a'))
      ..emit(fraudAlert(id: 'b'));
    await settle();

    expect(o.latest().map((a) => a.id), ['b', 'a']);
    await o.cancel();
  });

  test('a repeated id is ignored', () async {
    final o = observe();
    feed
      ..emit(fraudAlert(id: 'a'))
      ..emit(fraudAlert(id: 'a'));
    await settle();

    expect(o.latest().where((a) => a.id == 'a').length, 1);
    await o.cancel();
  });

  test('markFrozen flips the alert in place', () async {
    final o = observe();
    feed.emit(fraudAlert(id: 'a'));
    await settle();

    await repository.markFrozen('a');
    await settle();

    expect(o.latest().single.status, FraudAlertStatus.frozen);
    await o.cancel();
  });

  test('dismiss removes the alert', () async {
    final o = observe();
    feed
      ..emit(fraudAlert(id: 'a'))
      ..emit(fraudAlert(id: 'b'));
    await settle();

    await repository.dismiss('a');
    await settle();

    expect(o.latest().map((a) => a.id), ['b']);
    await o.cancel();
  });

  test('an alert that lands before anyone subscribes is not lost', () async {
    // The store subscribes to the feed at construction, so a push that
    // precedes the first watch() is still there when a surface reads it.
    feed.emit(fraudAlert(id: 'early'));
    await settle();

    final first = await repository.watch().first;
    expect(first.valueOrNull?.map((a) => a.id), ['early']);
  });
}
