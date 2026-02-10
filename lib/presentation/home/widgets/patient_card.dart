
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_mgt_system/core/constants/app_colors.dart';
import 'package:patient_mgt_system/data/models/patient_list.dart';

class PatientCard extends StatelessWidget {
  final int index;
  final Patient patient;

  const PatientCard({super.key, required this.index, required this.patient});

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'No date';
    if (patient.dateNdTime != null) {
      formattedDate = DateFormat('dd/MM/yyyy').format(patient.dateNdTime!);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ${patient.name ?? "Unknown"}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient.patientdetailsSet?.isNotEmpty == true
                      ? patient.patientdetailsSet!
                            .map((t) => t.treatmentName ?? "")
                            .where((n) => n.isNotEmpty)
                            .join(', ')
                      : 'No treatments',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF646464),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Icon(
                      Icons.people_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      patient.user ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF646464),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.cardFooterColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'View Booking details',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

