import 'package:einspect/core/errors/failure.dart';
import 'package:einspect/core/network/network_info.dart';
import 'package:einspect/features/inspections/data/datasources/inspections_local_data_source.dart';
import 'package:einspect/features/inspections/data/datasources/inspections_remote_data_source.dart';
import 'package:einspect/features/inspections/data/models/inspection_model.dart';
import 'package:einspect/features/inspections/data/repositories/inspections_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../inspection_test_helpers.dart';

class MockInspectionsLocalDataSource extends Mock
    implements InspectionsLocalDataSource {}

class MockInspectionsRemoteDataSource extends Mock
    implements InspectionsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockInspectionsLocalDataSource localDataSource;
  late MockInspectionsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late InspectionsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(makeModel());
  });

  setUp(() {
    localDataSource = MockInspectionsLocalDataSource();
    remoteDataSource = MockInspectionsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = InspectionsRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => localDataSource.insertOrUpdate(any<InspectionModel>()))
        .thenAnswer((_) async {
          return null;
        });
  });

  test('bloqueia submissão de inspeção já somente leitura', () async {
    when(
      () => localDataSource.findByClientId(
        clientId: 'client-1',
        userId: 'user-1',
      ),
    ).thenAnswer((_) async => makeModel(status: 'synced'));

    await expectLater(
      repository.submitInspection(makeInspection()),
      throwsA(isA<StateError>()),
    );
    verifyNever(() => localDataSource.insertOrUpdate(any<InspectionModel>()));
  });

  test('salva como pending antes de iniciar a sincronização', () async {
    when(
      () => localDataSource.findByClientId(
        clientId: 'client-1',
        userId: 'user-1',
      ),
    ).thenAnswer((_) async => null);
    when(() => localDataSource.findSyncQueue(userId: 'user-1'))
        .thenAnswer((_) async => []);

    await repository.submitInspection(makeInspection());

    verify(
      () => localDataSource.insertOrUpdate(
        any<InspectionModel>(
          that: predicate<InspectionModel>(
            (model) =>
                model.clientId == 'client-1' && model.status == 'pending',
          ),
        ),
      ),
    ).called(1);
    verify(() => networkInfo.isConnected).called(1);
  });

  test('não acessa a fila nem o remoto quando está offline', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    await repository.syncPendingQueue(userId: 'user-1');

    verifyNever(() => localDataSource.findSyncQueue(userId: 'user-1'));
    verifyNever(
      () => remoteDataSource.uploadInspection(any<InspectionModel>()),
    );
  });

  test('sincroniza pendentes e salva serverId e syncedAt', () async {
    final queued = makeModel(status: 'pending');
    when(() => localDataSource.findSyncQueue(userId: 'user-1'))
        .thenAnswer((_) async => [queued]);
    when(() => remoteDataSource.uploadInspection(queued)).thenAnswer(
      (_) async => {'id': 'server-1', 'syncedAt': '2026-01-02T03:04:05.000Z'},
    );

    await repository.syncPendingQueue(userId: 'user-1');

    verify(
      () => localDataSource.insertOrUpdate(
        any<InspectionModel>(
          that: predicate<InspectionModel>(
            (model) =>
                model.status == 'synced' &&
                model.serverId == 'server-1' &&
                model.syncedAt != null,
          ),
        ),
      ),
    ).called(1);
    verify(() => remoteDataSource.uploadInspection(queued)).called(1);
  });

  test(
    'marca a inspeção como failed com mensagem legível em erro de API',
    () async {
      final queued = makeModel(status: 'pending');
      when(() => localDataSource.findSyncQueue(userId: 'user-1'))
          .thenAnswer((_) async => [queued]);
      when(() => remoteDataSource.uploadInspection(queued))
          .thenThrow(const NetworkFailure('API indisponível'));

      await repository.syncPendingQueue(userId: 'user-1');

      verify(
        () => localDataSource.insertOrUpdate(
          any<InspectionModel>(
            that: predicate<InspectionModel>(
              (model) =>
                  model.status == 'failed' &&
                  model.failureReason != null &&
                  model.failureReason!.contains('API indisponível'),
            ),
          ),
        ),
      ).called(1);
    },
  );
}
