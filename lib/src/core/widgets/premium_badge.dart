import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumBadge extends StatelessWidget {
  final Widget child;
  final bool showBadge;

  const PremiumBadge({super.key, required this.child, this.showBadge = true});

  @override
  Widget build(BuildContext context) {
    if (!showBadge) return child;

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: Consumer<PremiumProvider>(
            builder: (context, provider, _) {
              // Optionally hide if user is already premium?
              // Prompt says: "add a premium badg on every premium features"
              // Usually badges are shown to indicate it IS a premium feature (locked), or just to mark it.
              // I will show a small crown icon.

              if (provider.isPremium) {
                // Feature is unlocked, maybe show gold border or nothing?
                // Let's show a "Premium" label or icon.
                return const SizedBox(); // Hide badge if unlocked? Or maybe keep it?
                // Usually "Premium Badge" implies "Locked".
                // Let's assume this widget wraps content that IS premium.
                // If user IS premium, they can access it, so maybe no badge needed or a "gold star".
                // But if user is NOT premium, we might want to show a lock.
                // The requirements say "add a premium badg on every premium features".
                // I will make a simple icon for now.
              }

              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.star, size: 12, color: Colors.white),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PremiumFeatureIcon extends StatelessWidget {
  const PremiumFeatureIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
