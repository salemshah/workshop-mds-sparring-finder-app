import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparring_finder/src/ui/widgets/custom_button.dart';

import '../../theme/app_colors.dart';

class AvailabilityFormScreen extends StatefulWidget {
  const AvailabilityFormScreen({super.key});

  @override
  State<AvailabilityFormScreen> createState() => _AvailabilityFormScreenState();
}

class _AvailabilityFormScreenState extends State<AvailabilityFormScreen> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final locationController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add new Availability',
          style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.center,
                          "Provide your available schedule to other athletes can see it and book a sparring session with you.",
                          style: TextStyle(color: AppColors.text),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                  _buildLabel("Select date"),
                  GestureDetector(
                    onTap: _pickDate,
                    child: _buildInputField(
                      selectedDate != null
                          ? DateFormat('dd MMM, yyyy').format(selectedDate!)
                          : "Select Date",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Select start time (from)"),
                  GestureDetector(
                    onTap: () => _pickTime(isStart: true),
                    child: _buildInputField(
                      startTime != null
                          ? startTime!.format(context)
                          : "Select start time",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Select end time (To)"),
                  GestureDetector(
                    onTap: () => _pickTime(isStart: false),
                    child: _buildInputField(
                      endTime != null ? endTime!.format(context) : "Select end time",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Location where you want to spar"),
                  TextFormField(
                    controller: locationController,
                    style: const TextStyle(color: AppColors.text),
                    decoration: _inputDecoration("Enter location"),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        // Save logic here
                        print("Date: $selectedDate");
                        print("From: $startTime");
                        print("To: $endTime");
                        print("Location: ${locationController.text}");
                      },
                      label: "Save",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF2A2D37),
      ),
      child: Text(
        value,
        style: const TextStyle(color: AppColors.text),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.text),
      filled: true,
      fillColor: const Color(0xFF2A2D37),
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
}

