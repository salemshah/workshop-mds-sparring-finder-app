import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/models/availability/availability_model.dart';
import 'package:sparring_finder/src/ui/widgets/custom_button.dart';
import '../../../blocs/availability/availability_event.dart';
import '../../../blocs/availability/availability_state.dart';
import '../../theme/app_colors.dart';

class AvailabilityFormScreen extends StatefulWidget {
  const AvailabilityFormScreen({super.key, this.availability});

  final Availability? availability;

  @override
  State<AvailabilityFormScreen> createState() => _AvailabilityFormScreenState();
}

class _AvailabilityFormScreenState extends State<AvailabilityFormScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late final TextEditingController _locationCtrl;

  bool get isEdit => widget.availability != null;


  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final a = widget.availability!;
      _selectedDate = a.specificDate;
      _startTime = TimeOfDay.fromDateTime(a.startTime);
      _endTime   = TimeOfDay.fromDateTime(a.endTime);
      _locationCtrl = TextEditingController(text: a.location);
    } else {
      _locationCtrl = TextEditingController();
    }
  }


  /* ----------------------------- Pickers ----------------------------- */

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? TimeOfDay.now())
          : (_endTime   ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  /* ----------------------------- Submit ------------------------------ */

  void _save() {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time')),
      );
      return;
    }
    if (_locationCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location is required')),
      );
      return;
    }

    // Combine date & time into full DateTimes for backend
    DateTime _combine(TimeOfDay t) => DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      t.hour,
      t.minute,
    );

    final payload = {
      'specific_date': _selectedDate!.toIso8601String(),
      'start_time': _combine(_startTime!).toIso8601String(),
      'end_time': _combine(_endTime!).toIso8601String(),
      'location': _locationCtrl.text.trim(),
    };

    final bloc = context.read<AvailabilityBloc>();

    if (isEdit) {
      bloc.add(UpdateAvailability(widget.availability!.id, payload));
    } else {
      bloc.add(CreateAvailability(payload));
    }
  }

  /* ----------------------------- UI ------------------------------ */

  @override
  Widget build(BuildContext context) {
    return BlocListener<AvailabilityBloc, AvailabilityState>(
      listener: (context, state) {
        if (state is AvailabilityFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is AvailabilityOperationSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context); // return to previous screen
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            isEdit ? 'Edit Availability' : 'Add Availability',
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 40),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Provide your available schedule so other athletes can book a sparring session with you.",
                          style: TextStyle(color: AppColors.text),
                        ),
                      ),
                    ),
                    _buildLabel("Select date"),
                    GestureDetector(
                      onTap: _pickDate,
                      child: _buildInputField(
                        _selectedDate != null
                            ? DateFormat('dd MMM, yyyy').format(_selectedDate!)
                            : "Select date",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Select start time (from)"),
                    GestureDetector(
                      onTap: () => _pickTime(true),
                      child: _buildInputField(
                        _startTime != null
                            ? _startTime!.format(context)
                            : "Select start time",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Select end time (to)"),
                    GestureDetector(
                      onTap: () => _pickTime(false),
                      child: _buildInputField(
                        _endTime != null
                            ? _endTime!.format(context)
                            : "Select end time",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Location"),
                    TextFormField(
                      controller: _locationCtrl,
                      style: const TextStyle(color: AppColors.text),
                      decoration: _inputDecoration("Enter location"),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<AvailabilityBloc, AvailabilityState>(
                      builder: (context, state) {
                        final loading = state is AvailabilityLoadInProgress;
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            label: loading ? 'Saving...' : 'Save',
                            onPressed: loading ? null : _save,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ----------------------------- Helper widgets ------------------------- */

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildInputField(String value) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    margin: const EdgeInsets.only(top: 6),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(10),
      color: AppColors.inputFill,
    ),
    child: Text(value, style: const TextStyle(color: AppColors.text)),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.text),
    filled: true,
    fillColor: AppColors.inputFill,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[500]!),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
