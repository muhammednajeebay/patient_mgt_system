import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../provider/registration_provider.dart';

class PaymentOptionsSelector extends StatelessWidget {
  final RegistrationProvider provider;

  const PaymentOptionsSelector({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Cash', 'Card', 'UPI'].map((method) {
        return Row(
          children: [
            Radio<String>(
              value: method,
              groupValue: provider.selectedPaymentMethod,
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) provider.updatePaymentMethod(val);
              },
            ),
            Text(method, style: Theme.of(context).textTheme.bodyLarge),
          ],
        );
      }).toList(),
    );
  }
}
