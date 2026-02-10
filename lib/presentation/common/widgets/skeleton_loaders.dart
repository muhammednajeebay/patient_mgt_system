import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class PatientCardSkeleton extends StatelessWidget {
  const PatientCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
                const SkeletonLoader(width: 150, height: 20),
                const SizedBox(height: 8),
                const SkeletonLoader(width: double.infinity, height: 16),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    SkeletonLoader(width: 100, height: 14),
                    SizedBox(width: 24),
                    SkeletonLoader(width: 80, height: 14),
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
                SkeletonLoader(width: 120, height: 16),
                SkeletonLoader(width: 16, height: 16, borderRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PatientListSkeleton extends StatelessWidget {
  const PatientListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const PatientCardSkeleton(),
    );
  }
}

class RegistrationSkeleton extends StatelessWidget {
  const RegistrationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(width: 200, height: 32), // Title
          const SizedBox(height: 24),

          // Multiple Label-Field pairs
          for (int i = 0; i < 5; i++) ...[
            const SkeletonLoader(width: 100, height: 16), // Label
            const SizedBox(height: 8),
            const SkeletonLoader(width: double.infinity, height: 50), // Field
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 12),
          const SkeletonLoader(width: 120, height: 24), // Treatments Header
          const SizedBox(height: 16),
          const SkeletonLoader(
            width: double.infinity,
            height: 50,
          ), // Add Button

          const SizedBox(height: 40),
          const SkeletonLoader(
            width: double.infinity,
            height: 54,
          ), // Save Button
        ],
      ),
    );
  }
}
