import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orbytis_challenge/features/inspections/domain/entities/inspection_entity.dart';
import 'package:orbytis_challenge/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:orbytis_challenge/features/inspections/presentation/bloc/history/inspections_history_bloc.dart';
import 'package:orbytis_challenge/features/inspections/presentation/bloc/history/inspections_history_event.dart';
import 'package:orbytis_challenge/features/inspections/presentation/bloc/history/inspections_history_state.dart';

import '../../../inspection_test_helpers.dart';

class MockInspectionsRepository extends Mock implements InspectionsRepository {}

void main() {
  late MockInspectionsRepository repository;
  final inspections = [makeInspection(status: InspectionStatus.failed)];

  setUp(() {
    repository = MockInspectionsRepository();
  });

  blocTest<InspectionsHistoryBloc, InspectionsHistoryState>(
    'carrega histórico filtrado por usuário e status',
    build: () {
      when(
        () => repository.getInspections(
          userId: 'user-1',
          statusFilter: InspectionStatus.failed,
        ),
      ).thenAnswer((_) async => inspections);
      return InspectionsHistoryBloc(repository: repository);
    },
    act: (bloc) => bloc.add(
      const InspectionsHistoryFetchRequested(
        userId: 'user-1',
        statusFilter: InspectionStatus.failed,
      ),
    ),
    expect: () => [
      isA<InspectionsHistoryLoading>(),
      predicate<InspectionsHistorySuccess>(
        (state) =>
            state.inspections == inspections &&
            state.activeFilter == InspectionStatus.failed,
      ),
    ],
    verify: (_) => verify(
      () => repository.getInspections(
        userId: 'user-1',
        statusFilter: InspectionStatus.failed,
      ),
    ).called(1),
  );

  blocTest<InspectionsHistoryBloc, InspectionsHistoryState>(
    'emite erro quando o histórico falha',
    build: () {
      when(() => repository.getInspections(userId: 'user-1'))
          .thenThrow(Exception('falha local'));
      return InspectionsHistoryBloc(repository: repository);
    },
    act: (bloc) =>
        bloc.add(const InspectionsHistoryFetchRequested(userId: 'user-1')),
    expect: () => [
      isA<InspectionsHistoryLoading>(),
      isA<InspectionsHistoryError>(),
    ],
  );

  blocTest<InspectionsHistoryBloc, InspectionsHistoryState>(
    'tenta novamente e recarrega o histórico do usuário',
    build: () {
      when(() => repository.getInspections(userId: 'user-1'))
          .thenAnswer((_) async => inspections);
      when(
        () =>
            repository.retryInspection(clientId: 'client-1', userId: 'user-1'),
      ).thenAnswer((_) async {});
      return InspectionsHistoryBloc(repository: repository);
    },
    act: (bloc) async {
      bloc.add(const InspectionsHistoryFetchRequested(userId: 'user-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(
        const InspectionRetryRequested(clientId: 'client-1', userId: 'user-1'),
      );
    },
    expect: () => [
      isA<InspectionsHistoryLoading>(),
      isA<InspectionsHistorySuccess>(),
      predicate<InspectionsHistorySuccess>(
        (state) => state.inspections == inspections,
      ),
    ],
    verify: (_) {
      verify(
        () =>
            repository.retryInspection(clientId: 'client-1', userId: 'user-1'),
      ).called(1);
      verify(() => repository.getInspections(userId: 'user-1')).called(2);
    },
  );

  blocTest<InspectionsHistoryBloc, InspectionsHistoryState>(
    'sincroniza manualmente, sinaliza progresso e atualiza a lista',
    build: () {
      when(() => repository.syncPendingQueue(userId: 'user-1'))
          .thenAnswer((_) async {});
      when(() => repository.getInspections(userId: 'user-1'))
          .thenAnswer((_) async => inspections);
      return InspectionsHistoryBloc(repository: repository);
    },
    act: (bloc) async {
      bloc.add(const InspectionsHistoryFetchRequested(userId: 'user-1'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionsManualSyncRequested());
    },
    expect: () => [
      isA<InspectionsHistoryLoading>(),
      isA<InspectionsHistorySuccess>(),
      predicate<InspectionsHistorySuccess>((state) => state.isSyncing),
      predicate<InspectionsHistorySuccess>(
        (state) => !state.isSyncing && state.inspections == inspections,
      ),
    ],
    verify: (_) =>
        verify(() => repository.syncPendingQueue(userId: 'user-1')).called(1),
  );
}
