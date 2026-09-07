import 'dart:io';

import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_bloc.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_event.dart';
import 'package:einspect/features/inspections/presentation/bloc/form/inspection_form_state.dart';
import 'package:einspect/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InspectionFormPage extends StatefulWidget {
  final WorkOrderEntity workOrder;

  const InspectionFormPage({super.key, required this.workOrder});

  @override
  State<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends State<InspectionFormPage> {
  final _observationController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 85,
    );
    if (file != null && mounted) {
      context.read<InspectionFormBloc>().add(
        InspectionPhotoSelected(file.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InspectionFormBloc, InspectionFormState>(
      listener: (context, state) {
        if (state.submissionStatus == FormSubmissionStatus.successSynced) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inspeção enviada e sincronizada com sucesso!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          Navigator.of(context).pop();
        }

        if (state.submissionStatus ==
            FormSubmissionStatus.successQueuedOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Sem conexão no momento. Inspeção salva na fila local e será sincronizada automaticamente.',
              ),
              backgroundColor: Color(0xFFE65100),
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.of(context).pop();
        }

        if (state.submissionStatus == FormSubmissionStatus.successDrafted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rascunho salvo com sucesso.'),
              backgroundColor: Colors.blueAccent,
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.of(context).pop();
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (_observationController.text.isEmpty &&
            state.observation.isNotEmpty) {
          _observationController.text = state.observation;
        }

        return Scaffold(
          appBar: AppBar(title: Text('Inspeção: ${widget.workOrder.code}')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner Read-Only quando a inspeção já foi finalizada
                if (state.isReadOnly) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: state.status == InspectionStatus.synced
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.status == InspectionStatus.synced
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.status == InspectionStatus.synced
                              ? Icons.check_circle_outline
                              : Icons.schedule,
                          color: state.status == InspectionStatus.synced
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.status == InspectionStatus.synced
                                ? 'Inspeção sincronizada com sucesso.'
                                : 'Inspeção concluída e aguardando envio na fila de sincronização.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: state.status == InspectionStatus.synced
                                  ? Colors.green.shade900
                                  : Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Card da OS
                Card(
                  elevation: 0,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blue.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.workOrder.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.workOrder.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Observação
                const Text(
                  'Observação técnica *',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _observationController,
                  maxLines: 4,
                  readOnly: state.isReadOnly,
                  onChanged: (text) => context.read<InspectionFormBloc>().add(
                    InspectionObservationChanged(text),
                  ),
                  decoration: InputDecoration(
                    hintText: state.isReadOnly
                        ? 'Sem observações'
                        : 'Descreva o estado do ativo (mínimo 10 caracteres)',
                    filled: true,
                    fillColor: state.isReadOnly
                        ? Colors.grey.shade100
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Condição
                const Text(
                  'Condição do ativo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: state.condition,
                  hint: const Text('Selecione uma condição'),
                  items: const [
                    DropdownMenuItem(value: 'bom', child: Text('Bom')),
                    DropdownMenuItem(value: 'regular', child: Text('Regular')),
                    DropdownMenuItem(value: 'ruim', child: Text('Ruim')),
                    DropdownMenuItem(value: 'crítico', child: Text('Crítico')),
                  ],
                  onChanged: state.isReadOnly
                      ? null
                      : (value) {
                          if (value != null) {
                            context.read<InspectionFormBloc>().add(
                              InspectionConditionChanged(value),
                            );
                          }
                        },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: state.isReadOnly
                        ? Colors.grey.shade100
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Foto
                const Text(
                  'Evidência fotográfica *',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (state.photoPath != null && state.photoPath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          File(state.photoPath!),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (!state.isReadOnly)
                          IconButton(
                            icon: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.close, color: Colors.black),
                            ),
                            onPressed: () => context
                                .read<InspectionFormBloc>()
                                .add(const InspectionPhotoRemoved()),
                          ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state.isReadOnly
                              ? null
                              : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Câmera'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state.isReadOnly
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Galeria'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // GPS
                const Text(
                  'Localização GPS *',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                if (state.isOutOfGeofence && !state.isReadOnly) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber.shade900,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Atenção: Você está a ${state.geofenceDistanceMeters!.toStringAsFixed(0)}m do ponto programado da OS (limite recomendado: 200m).',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: state.isReadOnly
                        ? Colors.grey.shade100
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCFD8DC)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.latitude != null &&
                                state.longitude != null) ...[
                              Text(
                                'Lat: ${state.latitude!.toStringAsFixed(5)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'Long: ${state.longitude!.toStringAsFixed(5)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ] else
                              const Text(
                                'Nenhuma coordenada obtida',
                                style: TextStyle(color: Colors.black54),
                              ),
                          ],
                        ),
                      ),
                      if (!state.isReadOnly) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onPressed: state.isFetchingLocation
                              ? null
                              : () => context.read<InspectionFormBloc>().add(
                                  const InspectionLocationRequested(),
                                ),
                          icon: state.isFetchingLocation
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.my_location, size: 18),
                          label: const Text('Obter GPS'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Botões de Ação (ocultos em modo Read-Only)
                if (!state.isReadOnly) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          onPressed:
                              state.submissionStatus ==
                                  FormSubmissionStatus.submitting
                              ? null
                              : () => context.read<InspectionFormBloc>().add(
                                  const InspectionDraftSaveSubmitted(),
                                ),
                          child: const Text('Salvar Rascunho'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          onPressed:
                              state.submissionStatus ==
                                  FormSubmissionStatus.submitting
                              ? null
                              : () => context.read<InspectionFormBloc>().add(
                                  const InspectionCompletionSubmitted(),
                                ),
                          child:
                              state.submissionStatus ==
                                  FormSubmissionStatus.submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Concluir Inspeção'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
