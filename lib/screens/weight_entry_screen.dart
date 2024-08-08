import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';
import '../utils/validators.dart';
import '../models/weight_entry.dart';

class WeightEntryScreen extends StatefulWidget {
  final AuthService authService;

  const WeightEntryScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _WeightEntryScreenState createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _databaseService = DatabaseService();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitWeight() async {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final currentUser = widget.authService.currentUser;
      if (currentUser != null) {
        final entry = WeightEntry(
          userId: currentUser.id,
          weight: weight,
          date: _selectedDate,
        );
        await _databaseService.insertWeightEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.weightSaved)),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.userNotLoggedIn)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.logWeight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _weightController,
                labelText: Strings.weight,
                prefixIcon: Icons.fitness_center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.validateWeight,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: Styles.inputDecoration.copyWith(
                    labelText: Strings.date,
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: Styles.primaryButtonStyle,
                onPressed: _submitWeight,
                child: Text(Strings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
