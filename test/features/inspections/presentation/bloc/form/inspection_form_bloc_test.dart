import 'package:bloc_test/bloc_test.dart';
import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:einspect/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_bloc.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_event.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../inspection_test_helpers.dart';

class MockInspectionsRepository extends Mock implements InspectionsRepository {}

void main() {
  late MockInspectionsRepository repository;

  setUpAll(() {
    registerFallbackValue(makeInspection());
  });

  setUp(() {
    repository = MockInspectionsRepository();
    when(
      () => repository.getInspectionByWorkOrderId(
        workOrderId: any(named: 'workOrderId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => null);
  });

  InspectionFormStarted startedEvent() {
    return const InspectionFormStarted(
      workOrderId: 'work-order-1',
      userId: 'user-1',
      targetLatitude: -23.5505,
      targetLongitude: -46.6333,
    );
  }

  blocTest<InspectionFormBloc, InspectionFormState>(
    'cria uma inspeção nova com UUID e modo editável',
    build: () => InspectionFormBloc(repository: repository),
    act: (bloc) => bloc.add(startedEvent()),
    expect: () => [
      predicate<InspectionFormState>(
        (state) =>
            RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            ).hasMatch(state.clientId) &&
            state.userId == 'user-1' &&
            state.workOrderId == 'work-order-1' &&
            !state.isReadOnly &&
            state.status == InspectionStatus.draft,
      ),
    ],
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'restaura inspeção sincronizada como somente leitura',
    setUp: () {
      when(
        () => repository.getInspectionByWorkOrderId(
          workOrderId: 'work-order-1',
          userId: 'user-1',
        ),
      ).thenAnswer(
        (_) async => makeInspection(status: InspectionStatus.synced),
      );
    },
    build: () => InspectionFormBloc(repository: repository),
    act: (bloc) => bloc.add(startedEvent()),
    expect: () => [
      predicate<InspectionFormState>(
        (state) =>
            state.clientId == 'client-1' &&
            state.status == InspectionStatus.synced &&
            state.isReadOnly,
      ),
    ],
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'atualiza observação e ignora edição em inspeção somente leitura',
    setUp: () {
      when(
        () => repository.getInspectionByWorkOrderId(
          workOrderId: 'work-order-1',
          userId: 'user-1',
        ),
      ).thenAnswer(
        (_) async => makeInspection(status: InspectionStatus.synced),
      );
    },
    build: () => InspectionFormBloc(repository: repository),
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionObservationChanged('alteracao bloqueada'));
    },
    expect: () => [predicate<InspectionFormState>((state) => state.isReadOnly)],
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'seleciona foto persistindo-a e remove a foto anterior',
    build: () => InspectionFormBloc(repository: repository),
    setUp: () {
      when(
        () => repository.persistPhoto(
          tempPath: 'temp/photo.png',
          clientId: any(named: 'clientId'),
        ),
      ).thenAnswer((_) async => '/documents/permanent.png');
      when(() => repository.deletePhoto('/documents/permanent.png'))
          .thenAnswer((_) async {
            return;
          });
    },
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionPhotoSelected('temp/photo.png'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionPhotoRemoved());
    },
    expect: () => [
      predicate<InspectionFormState>((state) => state.photoPath == null),
      predicate<InspectionFormState>(
        (state) => state.photoPath == '/documents/permanent.png',
      ),
      predicate<InspectionFormState>((state) => state.photoPath == null),
    ],
    verify: (_) {
      verify(
        () => repository.persistPhoto(
          tempPath: 'temp/photo.png',
          clientId: any(named: 'clientId'),
        ),
      ).called(1);
      verify(() => repository.deletePhoto('/documents/permanent.png'))
          .called(1);
    },
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'salva rascunho com status draft',
    build: () => InspectionFormBloc(repository: repository),
    setUp: () => when(() => repository.saveDraft(any())).thenAnswer((_) async {
      return;
    }),
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionDraftSaveSubmitted());
    },
    expect: () => [
      predicate<InspectionFormState>((state) => state.clientId.isNotEmpty),
      predicate<InspectionFormState>(
        (state) => state.submissionStatus == FormSubmissionStatus.submitting,
      ),
      predicate<InspectionFormState>(
        (state) =>
            state.submissionStatus == FormSubmissionStatus.successDrafted,
      ),
    ],
    verify: (_) {
      verify(
        () => repository.saveDraft(
          any<InspectionEntity>(
            that: predicate<InspectionEntity>(
              (inspection) =>
                  inspection.status == InspectionStatus.draft &&
                  inspection.clientId.isNotEmpty,
            ),
          ),
        ),
      ).called(1);
    },
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'falha na conclusão quando os campos obrigatórios estão incompletos',
    build: () => InspectionFormBloc(repository: repository),
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionObservationChanged('curta'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionCompletionSubmitted());
    },
    expect: () => [
      predicate<InspectionFormState>((state) => state.clientId.isNotEmpty),
      predicate<InspectionFormState>((state) => state.observation == 'curta'),
      predicate<InspectionFormState>(
        (state) => state.submissionStatus == FormSubmissionStatus.failure,
      ),
    ],
    verify: (_) => verifyNever(() => repository.submitInspection(any())),
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'conclui online e emite successSynced',
    build: () => InspectionFormBloc(repository: repository),
    setUp: () {
      var lookupCount = 0;
      when(
        () => repository.getInspectionByWorkOrderId(
          workOrderId: 'work-order-1',
          userId: 'user-1',
        ),
      ).thenAnswer((_) async {
        lookupCount++;
        return lookupCount == 1
            ? makeInspection(status: InspectionStatus.draft)
            : makeInspection(status: InspectionStatus.synced);
      });
      when(() => repository.submitInspection(any())).thenAnswer((_) async {
        return;
      });
    },
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionCompletionSubmitted());
    },
    expect: () => [
      predicate<InspectionFormState>((state) => state.clientId.isNotEmpty),
      predicate<InspectionFormState>(
        (state) => state.submissionStatus == FormSubmissionStatus.submitting,
      ),
      predicate<InspectionFormState>(
        (state) =>
            state.submissionStatus == FormSubmissionStatus.successSynced &&
            state.isReadOnly &&
            state.status == InspectionStatus.synced,
      ),
    ],
  );

  blocTest<InspectionFormBloc, InspectionFormState>(
    'conclui offline e emite successQueuedOffline',
    build: () => InspectionFormBloc(repository: repository),
    setUp: () {
      var lookupCount = 0;
      when(
        () => repository.getInspectionByWorkOrderId(
          workOrderId: 'work-order-1',
          userId: 'user-1',
        ),
      ).thenAnswer((_) async {
        lookupCount++;
        return lookupCount == 1
            ? makeInspection(status: InspectionStatus.draft)
            : makeInspection(status: InspectionStatus.pending);
      });
      when(() => repository.submitInspection(any())).thenAnswer((_) async {
        return;
      });
    },
    act: (bloc) async {
      bloc.add(startedEvent());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const InspectionCompletionSubmitted());
    },
    expect: () => [
      predicate<InspectionFormState>((state) => state.clientId.isNotEmpty),
      predicate<InspectionFormState>(
        (state) => state.submissionStatus == FormSubmissionStatus.submitting,
      ),
      predicate<InspectionFormState>(
        (state) =>
            state.submissionStatus ==
                FormSubmissionStatus.successQueuedOffline &&
            state.isReadOnly &&
            state.status == InspectionStatus.pending,
      ),
    ],
  );
}
