import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/treatment_list.dart';
import '../../../provider/registration_provider.dart';

class AddTreatmentBottomSheet extends StatefulWidget {
  final int? editIndex;
  final SelectedTreatment? initialSelection;

  const AddTreatmentBottomSheet({
    super.key,
    this.editIndex,
    this.initialSelection,
  });

  @override
  State<AddTreatmentBottomSheet> createState() =>
      _AddTreatmentBottomSheetState();
}

class _AddTreatmentBottomSheetState extends State<AddTreatmentBottomSheet> {
  Treatment? selectedTreatment;
  int maleCount = 0;
  int femaleCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      selectedTreatment = widget.initialSelection!.treatment;
      maleCount = widget.initialSelection!.male;
      femaleCount = widget.initialSelection!.female;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.editIndex != null
                    ? 'Edit Treatment'
                    : 'Choose Treatment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabel('Choose Treatment'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Treatment>(
                isExpanded: true,
                hint: const Text(
                  'Choose treatment',
                  style: TextStyle(fontSize: 14),
                ),
                value: selectedTreatment,
                items: provider.treatments.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t.name ?? ''));
                }).toList(),
                onChanged: (val) => setState(() => selectedTreatment = val),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text('Add Patients', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),

          _buildCounter(
            'Male',
            maleCount,
            (val) => setState(() => maleCount = val),
          ),
          const SizedBox(height: 12),
          _buildCounter(
            'Female',
            femaleCount,
            (val) => setState(() => femaleCount = val),
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed:
                selectedTreatment != null && (maleCount > 0 || femaleCount > 0)
                ? () {
                    if (widget.editIndex != null) {
                      provider.updateTreatment(
                        widget.editIndex!,
                        selectedTreatment!,
                        maleCount,
                        femaleCount,
                      );
                    } else {
                      provider.addTreatment(
                        selectedTreatment!,
                        maleCount,
                        femaleCount,
                      );
                    }
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(widget.editIndex != null ? 'Update' : 'Save'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD9D9D9)),
          ),
          child: Text(label),
        ),
        Row(
          children: [
            _circleButton(Icons.remove, () {
              if (value > 0) onChanged(value - 1);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                value.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _circleButton(Icons.add, () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
