import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../provider/registration_provider.dart';

class TreatmentDatePicker extends StatelessWidget {
  final RegistrationProvider provider;

  const TreatmentDatePicker({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) provider.updateDate(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provider.selectedDate != null
                  ? '${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}'
                  : 'Select Date',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class TreatmentTimePicker extends StatelessWidget {
  final RegistrationProvider provider;

  const TreatmentTimePicker({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimeDropdown(
            hint: 'Hour',
            value: provider.selectedHour.isEmpty ? null : provider.selectedHour,
            items: List.generate(24, (i) => i.toString().padLeft(2, '0')),
            onChanged: (val) => provider.updateTime(hour: val),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TimeDropdown(
            hint: 'Minutes',
            value: provider.selectedMinute.isEmpty
                ? null
                : provider.selectedMinute,
            items: List.generate(60, (i) => i.toString().padLeft(2, '0')),
            onChanged: (val) => provider.updateTime(minute: val),
          ),
        ),
      ],
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const _TimeDropdown({
    required this.hint,
    this.value,
    required this.items,
    required Function(String?) this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          menuMaxHeight: 200,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items.map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
