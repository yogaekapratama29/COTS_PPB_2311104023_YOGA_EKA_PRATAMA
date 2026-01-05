import 'package:cots/config/providers.dart';
import 'package:cots/core/app_route.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';
import '../widgets/custom_button.dart';

class DetailSensor extends StatelessWidget {
  final String? sensorId;

  const DetailSensor({super.key, this.sensorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sensor'),
        actions: [
          TextButton(
            onPressed: () {
            },
            child: Text(
              'Edit',
              style: AppTypography.body.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final sensor = provider.getSensorById(sensorId ?? '');

          if (sensor == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Sensor tidak ditemukan',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final statusColor = _getStatusColor(sensor.status);

          return ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              _InfoRow(label: 'Nama Sensor', value: sensor.name),
              SizedBox(height: AppSpacing.sm),
              _InfoRow(label: 'Lokasi', value: sensor.location),
              SizedBox(height: AppSpacing.sm),
              _InfoRow(label: 'Tipe Sensor', value: sensor.type),
              SizedBox(height: AppSpacing.sm),
              _InfoRow(
                label: 'Status',
                value: sensor.status,
                valueColor: statusColor,
              ),
              SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: LayoutTokens.borderRadius,
                ),
                child: Column(
                  children: [
                    Text('Nilai Saat Ini', style: AppTypography.caption),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          sensor.currentValue.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            sensor.unit,
                            style: AppTypography.title.copyWith(
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text('Pengaturan', style: AppTypography.section),
              SizedBox(height: AppSpacing.md),

              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.elevated,
                  borderRadius: LayoutTokens.borderRadius,
                  boxShadow: LayoutTokens.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sensor Aktif', style: AppTypography.body),
                    Switch(
                      value: sensor.isActive,
                      onChanged: (_) {
                        provider.toggleSensorStatus(sensor.id);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Lihat Riwayat Data',
                onPressed: () => AppRoutes.navigateTo(
                  context,
                  AppRoutes.history,
                  arguments: {'sensorId': sensor.id},
                ),
                type: ButtonType.primary,
                icon: Icons.history,
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Bahaya':
        return AppColors.danger;
      case 'Peringatan':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: LayoutTokens.borderRadius,
        boxShadow: LayoutTokens.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (valueColor != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: valueColor!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
              ),
              child: Text(
                value,
                style: AppTypography.body.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              value,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}