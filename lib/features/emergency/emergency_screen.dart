import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'emergency_controller.dart';
import 'widgets/emergency_contact_card.dart';
import 'widgets/sos_button.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(emergencyControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: contactsAsync.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(emergencyControllerProvider),
          ),
          data: (contacts) {
            if (contacts.isEmpty) {
              return const EmptyStateView(
                icon: Icons.local_hospital_outlined,
                title: 'No contacts found',
                subtitle: 'Emergency contacts are not available yet.',
              );
            }

            final primary = contacts.firstWhere(
              (contact) => contact.isPrimary,
              orElse: () => contacts.first,
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 18),
                Center(
                  child: SosButton(
                    onPressed: () => ref
                        .read(emergencyControllerProvider.notifier)
                        .makeCall(primary.phone, context),
                  ),
                ),
                const SizedBox(height: 28),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contacts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.18,
                  ),
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return EmergencyContactCard(
                      contact: contact,
                      onTap: () => ref
                          .read(emergencyControllerProvider.notifier)
                          .makeCall(contact.phone, context),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
