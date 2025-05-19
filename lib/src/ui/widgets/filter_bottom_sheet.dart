import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/ui/widgets/custom_dropdown.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final TextEditingController levelController;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController genderController;
  final List<String> levels;
  final List<String> countries;
  final List<String> cities;
  final List<String> genders;
  final SfRangeValues selectedWeightRange;
  final Function(SfRangeValues) onWeightRangeChanged;
  final Function(String?, String?, String?, String?, SfRangeValues?) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.levelController,
    required this.countryController,
    required this.cityController,
    required this.genderController,
    required this.levels,
    required this.countries,
    required this.cities,
    required this.genders,
    required this.selectedWeightRange,
    required this.onWeightRangeChanged,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SfRangeValues _weightRange;

  @override
  void initState() {
    super.initState();
    _weightRange = widget.selectedWeightRange;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                height: 50,
                controller: widget.levelController,
                levels: widget.levels,
                label: 'Skill level',
                hint: 'Select level',
              ),
              const SizedBox(height: 9),
              CustomDropdown(
                height: 50,
                controller: widget.countryController,
                levels: widget.countries,
                label: 'Country',
                hint: 'Select country',
              ),
              const SizedBox(height: 9),
              CustomDropdown(
                height: 50,
                controller: widget.cityController,
                levels: widget.cities,
                label: 'City',
                hint: 'Select city',
              ),
              const SizedBox(height: 9),
              CustomDropdown(
                height: 50,
                controller: widget.genderController,
                levels: widget.genders,
                label: 'Gender',
                hint: 'Select gender',
              ),
              const SizedBox(height: 24),
              Text(
                'Weight Range: ${_weightRange.start.toInt()}kg - ${_weightRange.end.toInt()}kg',
                style: const TextStyle(color: AppColors.text, fontSize: 12),
              ),

          SfSliderTheme(
              data: SfSliderThemeData(
                activeLabelStyle: TextStyle(color: AppColors.primary, fontSize: 12, fontStyle: FontStyle.italic),
                inactiveLabelStyle: TextStyle(color: Colors.red[200], fontSize: 12, fontStyle: FontStyle.italic),
              ),
            child: SfRangeSlider(
                min: 40,
                max: 150,
                values: _weightRange,
                interval: 10,
                showLabels: true,
                enableTooltip: true,
                stepSize: 1,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _weightRange = values;
                  });
                  widget.onWeightRangeChanged(values);
                },
              )),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(45),
                ),
                onPressed: () {
                  widget.onApplyFilters(
                    widget.levelController.text,
                    widget.countryController.text,
                    widget.cityController.text,
                    widget.genderController.text,
                    _weightRange,
                  );
                },
                child: const Text('Apply Filters', style: TextStyle(color: AppColors.white),),
              ),
            ],
          ),
        );
      },
    );
  }
}
