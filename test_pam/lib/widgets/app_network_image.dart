import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_pam/resources/app_colors.dart';

// Imagine descărcată din URL-ul din JSON (foto sau SVG), cu fundal gri cât se încarcă sau la eroare.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.url, required this.size, this.radius = 0, this.circle = false});

  final String url;
  final double size;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(width: size, height: size, color: AppColors.imagePlaceholder);
    final image = Uri.parse(url).path.endsWith('.svg')
        ? SvgPicture.network(
            url,
            width: size,
            height: size,
            placeholderBuilder: (_) => SizedBox(width: size, height: size),
            errorBuilder: (_, _, _) => SizedBox(width: size, height: size),
          )
        : Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) => progress == null ? child : placeholder, // gri cât se descarcă
            errorBuilder: (_, _, _) => placeholder, // gri dacă nu e internet
          );
    if (circle) return ClipOval(child: image);
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}
