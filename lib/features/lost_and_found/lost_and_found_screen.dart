import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/colors.dart';
import '../../shared/widgets/app_screen.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  int _tabIndex = 0;
  List<dynamic> _items = [];
  bool _loading = true;

  // Report lost form state
  bool _submitted = false;
  String _reportRef = '';
  final _itemNameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _itemNameCtrl.dispose();
    _categoryCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    _locationCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final json = await rootBundle.loadString('assets/data/lost_items.json');
    final list = jsonDecode(json) as List<dynamic>;
    if (mounted) {
      setState(() {
        _items = list;
        _loading = false;
      });
    }
  }

  void _submitReport() {
    final ref = 'LF${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    setState(() {
      _submitted = true;
      _reportRef = ref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kPurple.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: kPurpleLight, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lost & Found',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: kCream,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    Text(
                      'Report and recover lost items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kMutedText,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab switcher
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder),
            ),
            child: Row(
              children: [
                _TabBtn(
                  label: 'Found Items',
                  isActive: _tabIndex == 0,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _TabBtn(
                  label: 'Report Lost',
                  isActive: _tabIndex == 1,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _tabIndex == 0
                ? _FoundItemsTab(items: _items, loading: _loading)
                : _ReportLostTab(
                    itemNameCtrl: _itemNameCtrl,
                    categoryCtrl: _categoryCtrl,
                    descCtrl: _descCtrl,
                    dateCtrl: _dateCtrl,
                    locationCtrl: _locationCtrl,
                    nameCtrl: _nameCtrl,
                    phoneCtrl: _phoneCtrl,
                    submitted: _submitted,
                    reportRef: _reportRef,
                    onSubmit: _submitReport,
                    onReportAnother: () =>
                        setState(() => _submitted = false),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isActive ? kPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? kCream : kMutedText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FoundItemsTab extends StatefulWidget {
  const _FoundItemsTab({required this.items, required this.loading});
  final List<dynamic> items;
  final bool loading;

  @override
  State<_FoundItemsTab> createState() => _FoundItemsTabState();
}

class _FoundItemsTabState extends State<_FoundItemsTab> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(
          child: CircularProgressIndicator(color: kPurpleLight));
    }
    return ListView(
      children: [
        ...widget.items.map((item) {
          final id = item['id'] as String;
          final isExpanded = _expanded.contains(id);
          final isClaimed = (item['status'] as String) == 'claimed';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FoundItemCard(
              item: item,
              isExpanded: isExpanded,
              isClaimed: isClaimed,
              onToggle: () => setState(() {
                if (isExpanded) {
                  _expanded.remove(id);
                } else {
                  _expanded.add(id);
                }
              }),
            ),
          );
        }),
        const SizedBox(height: 12),
        // RCCG Security contact card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPurple.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.security_outlined, color: kPurpleLight, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RCCG Security Desk',
                      style: TextStyle(
                        color: kCream,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'For all lost and found inquiries',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kMutedText,
                          ),
                    ),
                  ],
                ),
              ),
              const Text(
                '08012345678',
                style: TextStyle(
                  color: kPurpleLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _FoundItemCard extends StatelessWidget {
  const _FoundItemCard({
    required this.item,
    required this.isExpanded,
    required this.isClaimed,
    required this.onToggle,
  });

  final dynamic item;
  final bool isExpanded;
  final bool isClaimed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kSurfaceHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.inventory_2_outlined,
                        color: kMutedText, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String? ?? '',
                          style: const TextStyle(
                            color: kCream,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isClaimed
                                    ? kSuccess.withValues(alpha: 0.15)
                                    : kGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isClaimed ? 'Claimed' : 'Pending',
                                style: TextStyle(
                                  color: isClaimed ? kSuccess : kGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item['category'] as String? ?? '',
                              style: const TextStyle(
                                  color: kMutedText, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: kMutedText,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1, color: kBorder),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['description'] as String? ?? '',
                      style: const TextStyle(
                          color: kMutedText, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: kMutedText, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          item['locationFound'] as String? ?? '',
                          style: const TextStyle(
                              color: kMutedText, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!isClaimed)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPurpleLight,
                            side: BorderSide(
                                color: kPurple.withValues(alpha: 0.4)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.phone_outlined, size: 16),
                          label: const Text('Contact Security'),
                        ),
                      )
                    else
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: kSuccess, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Returned to owner',
                            style: TextStyle(color: kSuccess, fontSize: 13),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportLostTab extends StatelessWidget {
  const _ReportLostTab({
    required this.itemNameCtrl,
    required this.categoryCtrl,
    required this.descCtrl,
    required this.dateCtrl,
    required this.locationCtrl,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.submitted,
    required this.reportRef,
    required this.onSubmit,
    required this.onReportAnother,
  });

  final TextEditingController itemNameCtrl;
  final TextEditingController categoryCtrl;
  final TextEditingController descCtrl;
  final TextEditingController dateCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final bool submitted;
  final String reportRef;
  final VoidCallback onSubmit;
  final VoidCallback onReportAnother;

  @override
  Widget build(BuildContext context) {
    if (submitted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: kSuccess, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Report Submitted!',
              style: TextStyle(
                color: kCream,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reference: $reportRef',
              style: const TextStyle(color: kGold, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: kCream,
                side: const BorderSide(color: kBorder),
              ),
              onPressed: onReportAnother,
              child: const Text('Report Another'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        _FormSection(
          title: 'Item Details',
          children: [
            _FormField(label: 'Item name', controller: itemNameCtrl),
            const SizedBox(height: 10),
            _FormField(label: 'Category (e.g. Wallet, Phone)', controller: categoryCtrl),
            const SizedBox(height: 10),
            _FormField(
              label: 'Description',
              controller: descCtrl,
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FormSection(
          title: 'When & Where',
          children: [
            _FormField(label: 'Date lost (YYYY-MM-DD)', controller: dateCtrl),
            const SizedBox(height: 10),
            _FormField(
                label: 'Location last seen', controller: locationCtrl),
          ],
        ),
        const SizedBox(height: 14),
        _FormSection(
          title: 'Owner Info',
          children: [
            _FormField(label: 'Your name', controller: nameCtrl),
            const SizedBox(height: 10),
            _FormField(label: 'Phone number', controller: phoneCtrl),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPurple.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: kPurpleLight, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'RCCG security checks the lost and found database daily.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMutedText,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onSubmit,
            child: const Text(
              'Submit Report',
              style: TextStyle(
                color: kCream,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: kGold,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: kCream),
      cursorColor: kPurple,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: kMutedText, fontSize: 13),
        filled: true,
        fillColor: kSurface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPurpleLight, width: 1.5),
        ),
      ),
    );
  }
}
