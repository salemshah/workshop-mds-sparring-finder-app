import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/widgets/text_with_icon.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import '../theme/app_colors.dart';

class AthleteCard extends StatelessWidget {
  final String name;
  final String weight;
  final String city;
  final String level;
  final image;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String gender;

  const AthleteCard({
    super.key,
    required this.name,
    required this.weight,
    required this.city,
    required this.level,
    required this.image,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = image.startsWith('http');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.text, width: 2),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 44,
                height: 44,
                child: isNetworkImage
                    ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.white38);
                  },
                )
                    : Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.capitalizeEachWord(),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    TextWithIcon(icon: Icons.fitness_center_rounded, text: weight.capitalizeEachWord().limit(5), iconSize: 18, iconColor: AppColors.primary),
                    const SizedBox(width: 8),
                    TextWithIcon(icon: Icons.location_city_rounded, text: city.capitalizeEachWord().limit(6), iconSize: 18, iconColor: AppColors.primary),
                    const SizedBox(width: 8),
                    TextWithIcon(icon: Icons.signal_cellular_alt, text: level.capitalizeEachWord().limit(8), iconSize: 18, iconColor: AppColors.primary),
                    const SizedBox(width: 8),
                    Icon(gender == "Female"? Icons.female_rounded : Icons.male_rounded, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.primary
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
