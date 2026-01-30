import 'package:flutter/material.dart';
import 'package:skinaware_flutter/constants.dart';

class CheckSkinScreen extends StatefulWidget {
  const CheckSkinScreen({super.key});

  @override
  State<CheckSkinScreen> createState() => _CheckSkinScreenState();
}

class _CheckSkinScreenState extends State<CheckSkinScreen> {
  String selectedSkinType = 'Normal';
  final Set<String> selectedSymptoms = {};
  String selectedArea = 'Face';

  final skinTypes = ['Normal', 'Oily', 'Dry', 'Sensitive'];
  final symptoms = ['Acne', 'Rash', 'Dryness', 'Itching', 'Pigmentation'];
  final areas = ['Face', 'Hands', 'Arms', 'Legs', 'Back', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Check your skin condition',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your skin so we can provide helpful guidance',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            _sectionCard(
              title: 'Skin Type',
              icon: Icons.water_drop_outlined,
              child: _gridOptions(
                items: skinTypes,
                selectedItem: selectedSkinType,
                onSelect: (value) {
                  setState(() => selectedSkinType = value);
                },
              ),
            ),

            _sectionCard(
              title: 'Select Symptoms',
              icon: Icons.checklist_rounded,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: symptoms.map((symptom) {
                  final isSelected = selectedSymptoms.contains(symptom);
                  return _chipOption(
                    label: symptom,
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSymptoms.remove(symptom);
                        } else {
                          selectedSymptoms.add(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            _sectionCard(
              title: 'Affected Area',
              icon: Icons.touch_app_outlined,
              child: _gridOptions(
                items: areas,
                selectedItem: selectedArea,
                onSelect: (value) {
                  setState(() => selectedArea = value);
                },
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('SkinType: $selectedSkinType');
                  debugPrint('Symptoms: $selectedSymptoms');
                  debugPrint('Area: $selectedArea');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Get Guidance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: primaryColor),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _gridOptions({
    required List<String> items,
    required String selectedItem,
    required ValueChanged<String> onSelect,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedItem;

        return GestureDetector(
          onTap: () => onSelect(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE0F2FE)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFFE5E7EB),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              item,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF334155),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chipOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F2FE) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF38BDF8) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
