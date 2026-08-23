import 'package:flutter/material.dart';
import 'success_page.dart';
import 'car_wash_form_page.dart';

class ProblemSelectionPage extends StatefulWidget {
  const ProblemSelectionPage({super.key, required this.vehicle});

  final String vehicle;

  @override
  State<ProblemSelectionPage> createState() => _ProblemSelectionPageState();
}

class _ProblemSelectionPageState extends State<ProblemSelectionPage> {
  static const Color _background = Color(0xFFF4CFCF);
  static const Color _accent = Color(0xFFE53935);

  final List<_Choice> _problems = const [
    _Choice(label: 'Pinchado', icon: Icons.build_circle_outlined),
    _Choice(label: 'Bateria', icon: Icons.battery_full_outlined),
    _Choice(label: 'Lavado', icon: Icons.local_car_wash_outlined),
    _Choice(label: 'Choque', icon: Icons.error_outline),
  ];

  String? _selected;

  void _goToCarWashForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarWashFormPage(vehicle: widget.vehicle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Text(
                'Cual es tu problema?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 18,
                children: _problems.map((choice) {
                  final bool isSelected = _selected == choice.label;
                  return _ChoiceButton(
                    choice: choice,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selected = choice.label);
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _selected == null
                      ? null
                      : () {
                          if (_selected == 'Lavado') {
                            _goToCarWashForm();
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SuccessPage(
                                vehicle: widget.vehicle,
                                problem: _selected!,
                              ),
                            ),
                          );
                        },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.choice,
    required this.isSelected,
    required this.onTap,
  });

  final _Choice choice;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? _ProblemSelectionPageState._accent : Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _ProblemSelectionPageState._accent.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(choice.icon, size: 36, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              choice.label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice {
  const _Choice({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
