import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_mgt_system/core/constants/static_data.dart';
import 'package:patient_mgt_system/data/models/branch_list.dart';
import 'package:patient_mgt_system/provider/registration_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../provider/auth_provider.dart';
import '../common/widgets/custom_button.dart';
import '../../core/services/pdf_service.dart';
import 'widgets/add_treatment_bottom_sheet.dart';
import 'widgets/registration_widgets.dart';
import 'widgets/treatment_item_card.dart';
import 'widgets/payment_options_widget.dart';
import 'widgets/date_time_selector.dart';
import '../common/widgets/skeleton_loaders.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().fetchInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<RegistrationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const RegistrationSkeleton();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register Patient',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),

                  const RegistrationLabel(text: 'Patient Name'),
                  RegistrationTextField(
                    hint: 'Enter your full name',
                    onChanged: (val) => provider.name = val,
                  ),

                  const RegistrationLabel(text: 'WhatsApp Number'),
                  RegistrationTextField(
                    hint: 'Enter your WhatsApp number',
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => provider.phone = val,
                  ),

                  const RegistrationLabel(text: 'Address'),
                  RegistrationTextField(
                    hint: 'Enter your full address',
                    maxLines: 3,
                    onChanged: (val) => provider.address = val,
                  ),

                  const RegistrationLabel(text: 'Location'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Choose your location'),
                        value: provider.selectedLocation,
                        items: StaticData.locations.map((loc) {
                          return DropdownMenuItem(value: loc, child: Text(loc));
                        }).toList(),
                        onChanged: (val) => provider.updateLocation(val),
                      ),
                    ),
                  ),

                  const RegistrationLabel(text: 'Branch'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Branch>(
                        isExpanded: true,
                        hint: const Text('Select Branch'),
                        value: provider.selectedBranch,
                        items: provider.branches.map((branch) {
                          return DropdownMenuItem(
                            value: branch,
                            child: Text(branch.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (val) => provider.updateBranch(val),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Treatments',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),

                  ...provider.selectedTreatments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final selection = entry.value;
                    return TreatmentItemCard(
                      selection: selection,
                      index: index,
                      provider: provider,
                    );
                  }),

                  const SizedBox(height: 12),
                  _buildAddButton(context, provider),

                  const SizedBox(height: 32),

                  const RegistrationLabel(text: 'Total Amount'),
                  ReadOnlyField(text: provider.totalAmount.toStringAsFixed(2)),

                  const RegistrationLabel(text: 'Discount Amount'),
                  RegistrationTextField(
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final discount = double.tryParse(val) ?? 0.0;
                      provider.updateFinancials(discount: discount);
                    },
                  ),
                  const RegistrationLabel(text: 'Payment Option'),
                  PaymentOptionsSelector(provider: provider),

                  const RegistrationLabel(text: 'Advance Amount'),
                  RegistrationTextField(
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final advance = double.tryParse(val) ?? 0.0;
                      provider.updateFinancials(advance: advance);
                    },
                  ),

                  const RegistrationLabel(text: 'Balance Amount'),
                  ReadOnlyField(
                    text: provider.balanceAmount.toStringAsFixed(2),
                  ),

                  const RegistrationLabel(text: 'Treatment Date'),
                  TreatmentDatePicker(provider: provider),

                  const RegistrationLabel(text: 'Treatment Time'),
                  TreatmentTimePicker(provider: provider),

                  const SizedBox(height: 40),

                  CustomButton(
                    text: 'Save',
                    isLoading: provider.isSaving,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        final executiveName =
                            authProvider.currentUser?.name ?? 'Admin';

                        final success = await provider.registerPatient(
                          executiveName,
                        );

                        if (success) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Patient registered successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Generate PDF
                            try {
                              final pdfService = PdfService();
                              final dateStr = provider.selectedDate != null
                                  ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(provider.selectedDate!)
                                  : '';
                              final timeStr =
                                  '${provider.selectedHour}:${provider.selectedMinute} ${DateTime.now().hour >= 12 ? "PM" : "AM"}';

                              await pdfService.generateRegistrationPdf(
                                name: provider.name,
                                phone: provider.phone,
                                address: provider.address,
                                branch:
                                    provider.selectedBranch?.name ?? 'General',
                                location:
                                    provider.selectedLocation ?? 'Default',
                                treatments: provider.selectedTreatments,
                                totalAmount: provider.totalAmount,
                                discountAmount: provider.discountAmount,
                                advanceAmount: provider.advanceAmount,
                                balanceAmount: provider.balanceAmount,
                                dateTime: '$dateStr-$timeStr',
                              );
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to generate PDF: $e'),
                                  ),
                                );
                              }
                            }
                            context.pop();
                          }
                        } else if (provider.error != null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(provider.error!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, RegistrationProvider provider) {
    return ElevatedButton(
      onPressed: () => _showAddTreatmentDialog(context, provider),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF1F1F1),
        foregroundColor: Colors.black,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Add Item', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddTreatmentDialog(
    BuildContext context,
    RegistrationProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddTreatmentBottomSheet(),
    );
  }
}
