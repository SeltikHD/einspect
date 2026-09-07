import 'package:einspect/core/network/network_status_cubit.dart';
import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/widgets/app_alert_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<NetworkStatusCubit>().state;

    if (isOnline) return const SizedBox.shrink();

    final colors = AppColors.of(context);

    return AppAlertBanner(
      message: 'Sem conexão com a internet. Modo offline ativo.',
      icon: Icons.wifi_off,
      color: colors.danger,
    );
  }
}
