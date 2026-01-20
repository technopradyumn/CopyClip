import 'dart:ui';
import 'package:copyclip/src/core/const/premium_constants.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isAdLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PremiumProvider>(context);
    final theme = Theme.of(context);

    return GlassScaffold(
      title: "Premium Access",
      showBackArrow: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Coins & Watch Ad Card (Combined)
            _buildBalanceCard(context, provider),

            const SizedBox(height: 16),

            // 2. Buy Premium Action
            if (!provider.isPremium)
              _ActionGlassCard(
                title: "Buy Premium (7 Days)",
                subtitle: "Cost: ${PremiumConstants.premiumCost} Coins",
                icon: Icons.diamond_outlined,
                color: Colors.purpleAccent,
                isDisabled: provider.coins < PremiumConstants.premiumCost,
                onTap: () async {
                  final success = await provider.buyPremium();
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Premium Activated for 7 days!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Not enough coins!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              )
            else
              _GlassContainer(
                color: Colors.greenAccent.withOpacity(0.1),
                borderColor: Colors.greenAccent.withOpacity(0.3),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Premium Active",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Expires: ${DateFormat.yMMMd().format(provider.premiumExpiryDate!)}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // 3. Categorized Features
            _SectionHeader(title: "Rich Text Editor"),
            _PremiumFeatureTile(
              icon: Icons.picture_as_pdf_outlined,
              title: "PDF Export",
              description: "Export your documents to PDF instantly",
            ),
            _PremiumFeatureTile(
              icon: Icons.print_outlined,
              title: "Print Documents",
              description: "Directly print your notes",
            ),
            _PremiumFeatureTile(
              icon: Icons.find_replace_outlined,
              title: "Advanced Search",
              description: "Search & Replace within your text",
            ),
            _PremiumFeatureTile(
              icon: Icons.perm_media_outlined,
              title: "Rich Media",
              description: "Insert Images, Videos, and Links",
            ),
            _PremiumFeatureTile(
              icon: Icons.palette_outlined,
              title: "Styling & Colors",
              description: "Custom text and background colors",
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, PremiumProvider provider) {
    return _GlassContainer(
      gradient: LinearGradient(
        colors: [
          Colors.amber.shade700.withOpacity(0.8),
          Colors.amber.shade400.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: Colors.amber.shade200.withOpacity(0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${provider.coins}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isAdLoading
                  ? null
                  : () async {
                      setState(() => _isAdLoading = true);
                      await provider.showRewardedAd(
                        onReward: (amount) {
                          provider.addCoins(amount);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("You earned $amount coins!"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      );
                      if (mounted) setState(() => _isAdLoading = false);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.amber.shade800,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isAdLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.amber,
                      ),
                    )
                  : const Icon(Icons.play_circle_fill),
              label: Text(
                _isAdLoading
                    ? "Loading Ad..."
                    : "Watch Ad (+${PremiumConstants.rewardCoinAmount})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;

  const _GlassContainer({
    required this.child,
    this.color,
    this.gradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                color ??
                (gradient == null ? Colors.white.withOpacity(0.05) : null),
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionGlassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDisabled;

  const _ActionGlassCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(24),
      child: _GlassContainer(
        color: isDisabled
            ? Colors.grey.withOpacity(0.05)
            : color.withOpacity(0.08),
        borderColor: isDisabled ? Colors.transparent : color.withOpacity(0.2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey : color.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: isDisabled
                    ? null
                    : [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isDisabled
                          ? TextDecoration.lineThrough
                          : null,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!isDisabled)
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

class _PremiumFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PremiumFeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _GlassContainer(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.amber, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "PRO",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
