import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import 'lost_found_controller.dart';

class ReportItemScreen extends ConsumerStatefulWidget {
  const ReportItemScreen({super.key});

  @override
  ConsumerState<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends ConsumerState<ReportItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(lostFoundControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Field(
              controller: _titleController,
              label: 'Title',
              onChanged:
                  ref.read(lostFoundControllerProvider.notifier).setTitle,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _descriptionController,
              label: 'Description',
              onChanged:
                  ref.read(lostFoundControllerProvider.notifier).setDescription,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: reportState.category,
              dropdownColor: kBackground,
              style: const TextStyle(color: kCream),
              decoration: _inputDecoration('Category'),
              items: const ['Electronics', 'Bag', 'Wallet', 'Book', 'Other']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(lostFoundControllerProvider.notifier)
                      .setCategory(value);
                }
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: kCream,
                side: const BorderSide(color: kPurple),
              ),
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(reportState.dateLost == null
                  ? 'Pick Date'
                  : reportState.dateLost!.toIso8601String().split('T').first),
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _locationController,
              label: 'Location',
              onChanged: ref
                  .read(lostFoundControllerProvider.notifier)
                  .setLocationFound,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _phoneController,
              label: 'Phone',
              onChanged: ref
                  .read(lostFoundControllerProvider.notifier)
                  .setContactPhone,
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: kCream.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kPurple),
              ),
              child: const Icon(Icons.camera_alt, color: kGold, size: 42),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: kCream,
              ),
              onPressed: _submit,
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(lostFoundControllerProvider).dateLost ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      ref.read(lostFoundControllerProvider.notifier).setDateLost(picked);
    }
  }

  void _submit() {
    ref.read(lostFoundControllerProvider.notifier).submitReport();
    context.goNamed('lostAndFound');
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: kCream.withValues(alpha: 0.7)),
      filled: true,
      fillColor: kCream.withValues(alpha: 0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kCream.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kPurple, width: 2),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: kCream),
      cursorColor: kPurple,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kCream.withValues(alpha: 0.7)),
        filled: true,
        fillColor: kCream.withValues(alpha: 0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kCream.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPurple, width: 2),
        ),
      ),
    );
  }
}
