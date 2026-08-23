import 'package:flutter/material.dart';
import 'problem_selection_page.dart';

class VehicleSelectionPage extends StatefulWidget {
  const VehicleSelectionPage({super.key});

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  static const Color _background = Color(0xFFF4CFCF);
  static const Color _accent = Color(0xFFE53935);

  final List<_Choice> _vehicles = const [
    _Choice(label: 'Carro', icon: Icons.directions_car_outlined),
    _Choice(label: 'Moto', icon: Icons.two_wheeler_outlined),
    _Choice(label: 'Bicicleta', icon: Icons.pedal_bike_outlined),
  ];

  String? _selected;

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
                'Selecciona\ntu vehiculo',
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
                children: _vehicles.map((choice) {
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProblemSelectionPage(
                                vehicle: _selected!,
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? _VehicleSelectionPageState._accent : Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _VehicleSelectionPageState._accent.withOpacity(0.2),
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
