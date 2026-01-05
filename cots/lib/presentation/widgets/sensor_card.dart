import 'package:cots/design_system/appColors.dart';
import 'package:cots/models/sensor_model.dart';
import 'package:flutter/material.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';

class SensorCard extends StatelessWidget {
  final Sensor sensor;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const SensorCard({
    super.key,
    required this.sensor,
    this.onTap,
    this.onToggle,
  });

  Color _getStatusColor() {
    if (!sensor.isActive) return AppColors.sensorInactive;
    if (sensor.status == 'Bahaya') return AppColors.sensorDanger;
    if (sensor.status == 'Peringatan') return AppColors.sensorWarning;
    return AppColors.sensorActive;
  }

  IconData _getSensorIcon() {
    switch (sensor.type.toLowerCase()) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'pressure':
        return Icons.speed;
      default:
        return Icons.sensors;
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
            padding: LayoutTokens.cardPaddingVertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.paddingSM),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                      ),
                      child: Icon(
                        _getSensorIcon(),
                        color: statusColor,
                        size: AppSpacing.iconLG,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sensor.name,
                            style: AppTypography.heading2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: AppSpacing.iconXS,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                sensor.location,
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingSM,
                        vertical: AppSpacing.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
                      ),
                      child: Text(
                        sensor.status,
                        style: AppTypography.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Divider(
                  color: AppColors.border,
                  height: 1,
                  thickness: LayoutTokens.dividerThickness,
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nilai Saat Ini',
                          style: AppTypography.caption,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sensor.currentValue.toStringAsFixed(1),
                              style: AppTypography.title.copyWith(
                                color: statusColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.xs),
                              child: Text(
                                sensor.unit,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (onToggle != null)
                      Switch(
                        value: sensor.isActive,
                        onChanged: (_) => onToggle!(),
                        activeColor: AppColors.primary,
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: AppSpacing.iconXS,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Update: ${_formatDateTime(sensor.lastUpdated)}',
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
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}