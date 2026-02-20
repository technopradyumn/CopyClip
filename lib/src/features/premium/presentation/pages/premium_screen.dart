import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:copyclip/src/core/common_widgets/mascot_character.dart';
import 'package:copyclip/src/core/const/premium_constants.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_event.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_state.dart';
import '../../../../l10n/app_localizations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  // We rely on Bloc State

  @override
  void initState() {
    super.initState();
    // Preload ad if needed
    context.read<PremiumBloc>().add(LoadRewardedAd());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return GlassScaffold(
          title: null,
          showBackArrow: false,
          body: Column(
            children: [
              SeamlessHeader(
                title: AppLocalizations.of(context)!.premiumAccess,
                subtitle: state.isPremium
                    ? "${AppLocalizations.of(context)!.premiumActiveUntil} ${state.premiumExpiryDate != null ? DateFormat.yMMMd().format(state.premiumExpiryDate!) : '∞'}"
                    : AppLocalizations.of(context)!.unlockAllFeatures,
                icon: Icons.star,
                iconColor: Colors.amber,
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 1. Coins & Watch Ad Card (Combined)
                      // 1. Coins & Watch Ad Card (Combined) - ALWAYS VISIBLE
                      _buildBalanceCard(context, state),

                      const SizedBox(height: 16),

                      // 2. Buy Premium Action
                      if (!state.isPremium)
                        _ActionGlassCard(
                          title: AppLocalizations.of(context)!.buyPremium,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.costCoins(PremiumConstants.premiumCost),
                          icon: Icons.diamond_outlined,
                          color: Colors.purpleAccent,
                          isDisabled:
                              state.coins < PremiumConstants.premiumCost,
                          onTap: () {
                            if (state.coins >= PremiumConstants.premiumCost) {
                              context.read<PremiumBloc>().add(BuyPremium());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black.withValues(
                                    alpha: 0.9,
                                  ),
                                  content: Row(
                                    children: [
                                      const MascotCharacter(
                                        size: 40,
                                        state: MascotState.happy,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.premiumActivated,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red.shade900,
                                  content: Row(
                                    children: [
                                      const MascotCharacter(
                                        size: 40,
                                        state: MascotState.sad,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.notEnoughCoins,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      else
                        _GlassContainer(
                          color: Colors.greenAccent.withValues(alpha: 0.15),
                          borderColor: Colors.greenAccent.withValues(
                            alpha: 0.3,
                          ),
                          child: Column(
                            children: [
                              const MascotCharacter(
                                    size: 100,
                                    state: MascotState.happy,
                                  )
                                  .animate()
                                  .scale(
                                    duration: 600.ms,
                                    curve: Curves.elasticOut,
                                  )
                                  .shimmer(delay: 800.ms, duration: 1.seconds),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.premiumActive,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.premiumExpiryDate != null
                                    ? "${AppLocalizations.of(context)!.expires} ${DateFormat.yMMMd().format(state.premiumExpiryDate!)}"
                                    : AppLocalizations.of(
                                        context,
                                      )!.temporaryAccess,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "CONGRATULATIONS!",
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 400.ms)
                                  .slideY(begin: 1),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      // 3. Categorized Features
                      _SectionHeader(
                        title: AppLocalizations.of(context)!.journalExpression,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.palette_outlined,
                        title: AppLocalizations.of(context)!.artisticDesigns,
                        description: AppLocalizations.of(
                          context,
                        )!.artisticDesignsDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.auto_awesome,
                        title: AppLocalizations.of(context)!.premiumLayouts,
                        description: AppLocalizations.of(
                          context,
                        )!.premiumLayoutsDesc,
                      ),

                      const SizedBox(height: 24),

                      _SectionHeader(
                        title: AppLocalizations.of(context)!.calendarTools,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.calendar_month,
                        title: AppLocalizations.of(context)!.fullCalendar,
                        description: AppLocalizations.of(
                          context,
                        )!.fullCalendarDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.copy_all,
                        title: AppLocalizations.of(context)!.autoSaveClipboard,
                        description: AppLocalizations.of(
                          context,
                        )!.clipboardAutoSaveDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.widgets_outlined,
                        title: AppLocalizations.of(context)!.proWidgets,
                        description: AppLocalizations.of(
                          context,
                        )!.proWidgetsDesc,
                      ),

                      const SizedBox(height: 24),

                      _SectionHeader(
                        title: AppLocalizations.of(context)!.dataExport,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.cloud_done_outlined,
                        title: AppLocalizations.of(context)!.advancedBackup,
                        description: AppLocalizations.of(
                          context,
                        )!.advancedBackupDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.picture_as_pdf_outlined,
                        title: AppLocalizations.of(context)!.pdfExport,
                        description: AppLocalizations.of(
                          context,
                        )!.pdfExportDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.print_outlined,
                        title: AppLocalizations.of(context)!.printReady,
                        description: AppLocalizations.of(
                          context,
                        )!.printReadyDesc,
                      ),

                      const SizedBox(height: 24),

                      _SectionHeader(
                        title: AppLocalizations.of(context)!.richTextEditor,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.find_replace_outlined,
                        title: AppLocalizations.of(context)!.advancedSearch,
                        description: AppLocalizations.of(
                          context,
                        )!.advancedSearchDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.perm_media_outlined,
                        title: AppLocalizations.of(context)!.richMedia,
                        description: AppLocalizations.of(
                          context,
                        )!.richMediaDesc,
                      ),
                      _PremiumFeatureTile(
                        icon: Icons.format_paint_outlined,
                        title: AppLocalizations.of(context)!.editorStyling,
                        description: AppLocalizations.of(
                          context,
                        )!.editorStylingDesc,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(BuildContext context, PremiumState state) {
    // Ad State
    final isLoading = state.isAdLoading;
    final isReady = state.isAdReady;

    return _GlassContainer(
      gradient: LinearGradient(
        colors: [
          Colors.amber.shade700.withValues(alpha: 0.8),
          Colors.amber.shade400.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: Colors.amber.shade200.withValues(alpha: 0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.balance,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${state.coins}",
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
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
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
              onPressed: isLoading
                  ? null
                  : () {
                      if (!isReady) {
                        context.read<PremiumBloc>().add(LoadRewardedAd());
                      } else {
                        context.read<PremiumBloc>().add(
                          ShowRewardedAd(
                            onReward: (amount) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.amber.shade800
                                        .withValues(alpha: 0.9),
                                    content: Row(
                                      children: [
                                        const MascotCharacter(
                                          size: 40,
                                          state: MascotState.amazed,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.youEarnedCoins(amount),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }
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
              icon: isLoading
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
                isLoading
                    ? AppLocalizations.of(context)!.loadingAd
                    : (isReady
                          ? AppLocalizations.of(
                              context,
                            )!.watchAd(PremiumConstants.rewardCoinAmount)
                          : AppLocalizations.of(context)!.loadAd),
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
                (gradient == null
                    ? Colors.white.withValues(alpha: 0.05)
                    : null),
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  borderColor ??
                  Theme.of(context).colorScheme.outline.withValues(
                    alpha: 0.2,
                  ), // Minimal & Visible
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
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
            ? Colors.grey.withValues(alpha: 0.05)
            : color.withValues(alpha: 0.08),
        borderColor: isDisabled
            ? Colors.transparent
            : color.withValues(alpha: 0.2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey : color.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                boxShadow: isDisabled
                    ? null
                    : [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
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
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
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
    // Determine mascot state based on title hash for variety
    final mascotState = title.length % 3 == 0
        ? MascotState.thinking
        : (title.length % 2 == 0 ? MascotState.happy : MascotState.amazed);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _GlassContainer(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                MascotCharacter(size: 45, state: mascotState),
              ],
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
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .shimmer(duration: 2.seconds),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.amber.withValues(alpha: 0.2),
              size: 16,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
    );
  }
}
