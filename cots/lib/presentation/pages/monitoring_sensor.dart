import 'package:cots/config/providers.dart';
import 'package:cots/core/app_route.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';

class MonitoringSensor extends StatelessWidget {
  const MonitoringSensor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Sensor'),
        actions: [
          TextButton(
            onPressed: () => AppRoutes.navigateTo(context, AppRoutes.sensorList),
            child: Text(
              'Daftar Sensor',
              style: AppTypography.body.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final activeSensors = provider.activeSensors;
          final totalSensors = provider.sensors.length;
          final inactiveSensors = provider.inactiveSensors.length;
          int warningCount = 0;
          for (var sensor in provider.sensors) {
            if (sensor.status == 'Peringatan' || sensor.status == 'Bahaya') {
              warningCount++;
            }
          }

          return Column(
            children: [
              Container(
                color: AppColors.elevated,
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.grid_view,
                        iconColor: AppColors.primary,
                        label: 'Total Sensor',
                        value: totalSensors.toString(),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.bolt,
                        iconColor: AppColors.success,
                        label: 'Sensor Aktif',
                        value: activeSensors.length.toString(),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.warning,
                        iconColor: AppColors.warning,
                        label: 'Peringatan',
                        value: warningCount.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Data Terbaru', style: AppTypography.section),
                        Text(
                          '18sb',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    if (activeSensors.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            children: [
                              Icon(
                                Icons.sensors_off,
                                size: 64,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'Belum ada sensor aktif',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...activeSensors.map((sensor) => Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
                            child: _RecentDataCard(
                              sensorName: sensor.name,
                              location: sensor.location,
                              value: sensor.currentValue.toStringAsFixed(1),
                              unit: sensor.unit,
                              status: sensor.status,
                              timestamp: sensor.lastUpdated,
                              onTap: () => AppRoutes.navigateTo(
                                context,
                                AppRoutes.sensorDetail,
                                arguments: {'sensorId': sensor.id},
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRoutes.navigateTo(context, AppRoutes.addSensor),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Sensor'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: LayoutTokens.borderRadius,
        border: Border.all(color: iconColor, width: 2),
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.iconLG),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.title.copyWith(
              fontSize: 28,
              color: iconColor,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _RecentDataCard extends StatelessWidget {
  final String sensorName;
  final String location;
  final String value;
  final String unit;
  final String status;
  final DateTime timestamp;
  final VoidCallback onTap;

  const _RecentDataCard({
    required this.sensorName,
    required this.location,
    required this.value,
    required this.unit,
    required this.status,
    required this.timestamp,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Bahaya':
        return AppColors.danger;
      case 'Peringatan':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: LayoutTokens.borderRadius,
        boxShadow: LayoutTokens.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: LayoutTokens.borderRadius,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sensorName, style: AppTypography.heading2),
                          SizedBox(height: AppSpacing.xs),
                          Text(location, style: AppTypography.caption),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
                      ),
                      child: Text(
                        status,
                        style: AppTypography.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: AppTypography.title.copyWith(
                            fontSize: 32,
                            color: statusColor,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            unit,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatDateTime(timestamp),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day} Jan ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}