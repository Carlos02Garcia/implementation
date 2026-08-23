import 'package:flutter/material.dart';
import 'success_page.dart';

class CarWashFormPage extends StatefulWidget {
  const CarWashFormPage({super.key, required this.vehicle});

  final String vehicle;

  @override
  State<CarWashFormPage> createState() => _CarWashFormPageState();
}

class _CarWashFormPageState extends State<CarWashFormPage> {
  static const Color _background = Color(0xFFF4CFCF);
  static const Color _accent = Color(0xFFE53935);
  static const Color _fieldText = Color(0xFF1C1C1C);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _DateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isFormComplete =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _DateController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  void _handleFieldChange() => setState(() {});

  InputDecoration _inputDecoration(String label, {Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefix,
      suffixIcon: suffix,
    );
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      _DateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _handleFieldChange();
    }
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessPage(
          vehicle: widget.vehicle,
          problem: 'Lavado',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const _GradientTitle(text: 'Servicio De Lavado'),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(color: _fieldText, fontSize: 16),
                        decoration: _inputDecoration('Nombre'),
                        onChanged: (_) => _handleFieldChange(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(color: _fieldText, fontSize: 16),
                        decoration: _inputDecoration('Apellido'),
                        onChanged: (_) => _handleFieldChange(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _DateController,
                  readOnly: true,
                  style: const TextStyle(color: _fieldText, fontSize: 16),
                  decoration: _inputDecoration(
                    'Fecha',
                    suffix: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                      onPressed: _pickBirthDate,
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                  onTap: _pickBirthDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: _fieldText, fontSize: 16),
                  decoration: _inputDecoration(
                    'Telefono',
                    prefix: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.flag_outlined, color: Colors.black54),
                    ),
                  ),
                  onChanged: (_) => _handleFieldChange(),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isFormComplete ? _submit : null,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientTitle extends StatelessWidget {
  const _GradientTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Color(0xFF3D83F6), Color(0xFFD964D8)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
