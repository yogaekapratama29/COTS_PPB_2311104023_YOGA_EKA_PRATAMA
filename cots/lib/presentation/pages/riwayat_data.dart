import 'package:cots/config/providers.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';
import '../widgets/custom_button.dart';

class RiwayatData extends StatefulWidget {
  final String? sensorId;

  const RiwayatData({super.key, this.sensorId});

  @override
  State<RiwayatData> createState() => _RiwayatDataState();
}

class _RiwayatDataState extends State<RiwayatData> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Data'),
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          var history = widget.sensorId != null
              ? provider.getHistoryBySensorId(widget.sensorId!)
              : provider.history;
          if (_selectedDate != null) {
            history = history.where((h) {
              return h.timestamp.year == _selectedDate!.year &&
                  h.timestamp.month == _selectedDate!.month &&
                  h.timestamp.day == _selectedDate!.day;
            }).toList();
          }

          return Column(
            children: [
              Container(
                color: AppColors.elevated,
                padding: EdgeInsets.all(AppSpacing.md),
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: LayoutTokens.borderRadius,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppSpacing.iconSM,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Rentang Tanggal'
                                : _formatDate(_selectedDate!),
                            style: AppTypography.body.copyWith(
                              color: _selectedDate == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (_selectedDate != null)
                          InkWell(
                            onTap: () => setState(() => _selectedDate = null),
                            child: Icon(
                              Icons.close,
                              size: AppSpacing.iconSM,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              'Belum ada riwayat',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(AppSpacing.md),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          final status = _getStatus(item.value);
                          final statusColor = _getStatusColor(status);

                          return Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.elevated,
                                borderRadius: LayoutTokens.borderRadius,
                                boxShadow: LayoutTokens.cardShadow,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppSpacing.md),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                _formatDateTime(item.timestamp),
                                                style: AppTypography.body.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: AppSpacing.sm),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.sm,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(
                                                    AppSpacing.radiusXS,
                                                  ),
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
                                          SizedBox(height: AppSpacing.xs),
                                          Text(
                                            item.sensorName,
                                            style: AppTypography.caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              item.value.toStringAsFixed(1),
                                              style: AppTypography.title.copyWith(
                                                color: statusColor,
                                              ),
                                            ),
                                            SizedBox(width: AppSpacing.xs),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 2),
                                              child: Text(
                                                item.unit,
                                                style: AppTypography.body.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.elevated,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: CustomButton(
          text: 'Lihat Riwayat Data',
          onPressed: () {
          },
          type: ButtonType.primary,
        ),
      ),
    );
  }

  String _getStatus(double value) {
    if (value > 30) return 'Tinggi';
    if (value > 28) return 'Normal';
    if (value > 26) return 'Normal';
    return 'Rendah';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Tinggi':
      case 'Rendah':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} Jan ${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day} Jan ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}