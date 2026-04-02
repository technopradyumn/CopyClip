import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/medal_widget.dart';
import '../../../../core/services/gamification_service.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import '../../../../core/const/constant.dart';

class XpDetailScreen extends StatefulWidget {
  const XpDetailScreen({super.key});

  @override
  State<XpDetailScreen> createState() => _XpDetailScreenState();
}

class _XpDetailScreenState extends State<XpDetailScreen> {
  String _filter = 'Weekly'; // Daily, Weekly, Monthly, Yearly
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = Provider.of<GamificationService>(context);
    final model = service.model;
    final medalTier = GamificationService.getMedalTier(model.level);

    return GlassScaffold(
      showBackArrow: true,
      title: "Progression & Analytics",
      body: DynamicBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Level & Medal Hero
              _buildHeroSection(theme, model, medalTier),
              const SizedBox(height: 24),

              // 2. Filter Selector
              _buildFilterSelector(theme),
              const SizedBox(height: 20),

              // 3. Analytics Section (5 Charts)
              _sectionTitle(theme, "Performance Analytics"),
              const SizedBox(height: 12),
              _buildChartsGrid(theme, model),
              const SizedBox(height: 24),

              // 4. Activity Calendar
              _sectionTitle(theme, "Activity Calendar"),
              const SizedBox(height: 12),
              _buildStreakCalendar(theme, model),
              const SizedBox(height: 24),

              // 5. Progression Logic
              _sectionTitle(theme, "Progression Formula"),
              const SizedBox(height: 12),
              _buildFormulaSection(theme),
              const SizedBox(height: 24),

              // 6. All Tiers
              _sectionTitle(theme, "Medal Tiers"),
              const SizedBox(height: 12),
              _buildTiersList(theme, model.level),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, dynamic model, String tier) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            theme.colorScheme.surface.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          MedalWidget(level: model.level, tier: tier, size: 100),
          const SizedBox(height: 16),
          Text(
            tier.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Level ${model.level}",
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: model.progressToNextLevel,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${model.totalXp} XP",
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "${model.xpToNextLevel - model.totalXp} XP to Level ${model.level + 1}",
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSelector(ThemeData theme) {
    final filters = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: filters.map((f) {
        final isSelected = _filter == f;
        return GestureDetector(
          onTap: () => setState(() => _filter = f),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              f,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartsGrid(ThemeData theme, dynamic model) {
    return Column(
      children: [
        // 1. Line Chart (Weekly Trends)
        _buildChartCard(
          theme,
          "Daily Progress Trend",
          SizedBox(height: 180, child: _buildLineChart(theme, model)),
          subtitle: "Total XP earned per day",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // 2. Pie Chart (Feature Source)
            Expanded(
              child: _buildChartCard(
                theme,
                "XP Sources",
                SizedBox(height: 180, child: _buildPieChart(theme, model)),
                subtitle: "Breakdown by feature",
              ),
            ),
            const SizedBox(width: 16),
            // 3. Radar Chart (Balance)
            Expanded(
              child: _buildChartCard(
                theme,
                "Feature Balance",
                SizedBox(height: 180, child: _buildRadarChart(theme, model)),
                subtitle: "Consistency across app",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 4. Bar Chart (Feature Breakdown)
        _buildChartCard(
          theme,
          "Total Contribution per Feature",
          SizedBox(height: 180, child: _buildBarChart(theme, model)),
          subtitle: "Comparison of total XP points",
        ),
        const SizedBox(height: 16),
        // 5. Area Chart (Cumulative Growth)
        _buildChartCard(
          theme,
          "Cumulative XP Growth",
          SizedBox(height: 180, child: _buildAreaChart(theme, model)),
          subtitle: "Your journey to Level 100",
        ),
        const SizedBox(height: 24),
        // 6. Streak Milestones (New Section)
        _sectionTitle(theme, "Streak Milestones"),
        const SizedBox(height: 12),
        _buildStreakMilestones(theme, model),
      ],
    );
  }

  Widget _buildChartCard(ThemeData theme, String title, Widget chart, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          if (subtitle != null)
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildLineChart(ThemeData theme, dynamic model) {
    List<FlSpot> spots = [];
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
        final d = now.subtract(Duration(days: 6 - i));
        final key = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
        int dailyTotal = 0;
        final dayData = model.dailyFeatureXp[key];
        if (dayData != null) {
            dayData.forEach((Object? k, Object? v) => dailyTotal += v as int);
        }
        spots.add(FlSpot(i.toDouble(), dailyTotal.toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.surface.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: (value, meta) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    days[value.toInt() % 7],
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 0,
            getTooltipColor: (_) => theme.colorScheme.primaryContainer,
            getTooltipItems: (items) => items.map((item) => 
              LineTooltipItem(
                '${item.y.toInt()} XP',
                TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              )
            ).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 5,
                color: theme.colorScheme.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.4),
                  theme.colorScheme.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme, dynamic model) {
    final Map<String, int> totals = {};
    model.dailyFeatureXp.forEach((Object? date, Object? features) {
        if (features is Map) {
            features.forEach((Object? feature, Object? xp) {
                if (feature is String && xp is int) {
                    totals[feature] = (totals[feature] ?? 0) + xp;
                }
            });
        }
    });

    if (totals.isEmpty) return const Center(child: Text("No Data"));

    final sections = totals.entries.map((e) {
        return PieChartSectionData(
            value: e.value.toDouble(),
            title: '${e.value}',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            color: _getFeatureColor(e.key),
            badgeWidget: Icon(_getFeatureIcon(e.key), size: 12, color: Colors.white),
            badgePositionPercentageOffset: 1.2,
        );
    }).toList();

    return PieChart(PieChartData(sections: sections, centerSpaceRadius: 20));
  }

  Widget _buildRadarChart(ThemeData theme, dynamic model) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 80),
              const RadarEntry(value: 60),
              const RadarEntry(value: 90),
              const RadarEntry(value: 40),
            ],
            fillColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderColor: theme.colorScheme.primary,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        getTitle: (index, angle) => RadarChartTitle(text: ''),
        tickCount: 3,
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme, dynamic model) {
    final Map<String, int> totals = {};
    model.dailyFeatureXp.forEach((Object? date, Object? features) {
        if (features is Map) {
            features.forEach((Object? feature, Object? xp) {
                if (feature is String && xp is int) {
                    totals[feature] = (totals[feature] ?? 0) + xp;
                }
            });
        }
    });

    int index = 0;
    final groups = totals.entries.map((e) {
        return BarChartGroupData(
            x: index++,
            barRods: [
                BarChartRodData(
                    toY: e.value.toDouble(),
                    color: _getFeatureColor(e.key),
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(show: true, toY: 100, color: theme.dividerColor.withValues(alpha: 0.1)),
                )
            ],
            showingTooltipIndicators: [0],
        );
    }).toList();

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(rod.toY.toInt().toString(), theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) => Text(totals.keys.elementAt(val.toInt()).substring(0, 3).toUpperCase(), style: const TextStyle(fontSize: 8)))),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: groups,
      ),
    );
  }

  Widget _buildAreaChart(ThemeData theme, dynamic model) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.surface.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: (value, meta) {
                final weeks = ['W1', 'W2', 'W3', 'W4', 'W5'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    weeks[value.toInt().toInt()],
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()} XP',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 0,
            getTooltipColor: (_) => theme.colorScheme.secondaryContainer,
            getTooltipItems: (items) => items.map((item) => 
              LineTooltipItem(
                '${item.y.toInt()} XP',
                TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              )
            ).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 100),
              const FlSpot(1, 250),
              const FlSpot(2, 400),
              const FlSpot(3, 850),
              const FlSpot(4, 1200),
            ],
            isCurved: true,
            color: theme.colorScheme.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 5,
                color: theme.colorScheme.secondary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.secondary.withValues(alpha: 0.4),
                  theme.colorScheme.secondary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCalendar(ThemeData theme, dynamic model) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final key = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
            final dayData = model.dailyFeatureXp[key];
            int dailyTotal = 0;
            if (dayData != null) {
                dayData.forEach((Object? k, Object? v) => dailyTotal += v as int);
            }

            if (dailyTotal > 0) {
              return Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.primary, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${day.day}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.sparkles, size: 6, color: Colors.amber),
                          Text("$dailyTotal", style: const TextStyle(fontSize: 6, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return null;
          },
          todayBuilder: (context, day, focusedDay) => Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
              child: Center(child: Text("${day.day}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakMilestones(ThemeData theme, dynamic model) {
    final milestones = [3, 7, 14, 30, 100];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: milestones.map((m) {
          final isUnlocked = model.bestStreak >= m;
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            width: 100,
            decoration: BoxDecoration(
              color: isUnlocked ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.dividerColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isUnlocked ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.transparent),
            ),
            child: Column(
              children: [
                Opacity(
                  opacity: isUnlocked ? 1.0 : 0.4,
                  child: MedalWidget(level: m, size: 50, isStreakMedal: true),
                ),
                const SizedBox(height: 8),
                Text("$m Days", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isUnlocked ? theme.colorScheme.onSurface : Colors.grey)),
                if (isUnlocked) const Icon(CupertinoIcons.checkmark_seal_fill, size: 14, color: Colors.green),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFormulaSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
                children: [
                    const Icon(CupertinoIcons.info_circle, color: Colors.indigo),
                    const SizedBox(width: 10),
                    Text("The Non-Linear Formula", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo)),
                ],
            ),
            const SizedBox(height: 12),
            const Text(
                "Your level progresses based on total XP using a logarithmic curve. Early levels are easy, while late levels require mastery.",
                style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                        "Level = floor(sqrt(Total XP / 10)) + 1",
                        style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                ),
            ),
        ],
      ),
    );
  }

  Widget _buildTiersList(ThemeData theme, int currentLevel) {
    final tiers = [
      {'name': 'Bronze', 'level': 1},
      {'name': 'Silver', 'level': 11},
      {'name': 'Gold', 'level': 21},
      {'name': 'Platinum', 'level': 31},
      {'name': 'Diamond', 'level': 41},
      {'name': 'Emerald', 'level': 51},
      {'name': 'Ruby', 'level': 61},
      {'name': 'Sapphire', 'level': 71},
      {'name': 'Amethyst', 'level': 81},
      {'name': 'Legend', 'level': 91},
    ];

    return Column(
      children: tiers.map((t) {
        final level = t['level'] as int;
        final name = t['name'] as String;
        final isActive = currentLevel >= level;
        return ListTile(
          leading: MedalWidget(level: level, tier: name, size: 40),
          title: Text(name, style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.4),
          )),
          subtitle: Text("Starts at Level $level"),
          trailing: isActive ? const Icon(CupertinoIcons.checkmark_seal_fill, color: Colors.green) : const Icon(CupertinoIcons.lock_fill, size: 16, color: Colors.grey),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
    );
  }

  Color _getFeatureColor(String feature) {
    switch (feature) {
      case 'note':
        return FeatureColors.notes;
      case 'todo':
        return FeatureColors.todos;
      case 'expense':
        return FeatureColors.expenses;
      case 'journal':
        return FeatureColors.journal;
      case 'clipboard':
        return FeatureColors.clipboard;
      case 'canvas':
        return FeatureColors.canvas;
      case 'calendar_event':
        return FeatureColors.events;
      case 'social_post':
        return FeatureColors.socialPost;
      default:
        return Colors.grey;
    }
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature) {
      case 'note':
        return CupertinoIcons.doc_text;
      case 'todo':
        return CupertinoIcons.checkmark_circle;
      case 'expense':
        return CupertinoIcons.money_dollar;
      case 'journal':
        return CupertinoIcons.book;
      case 'clipboard':
        return CupertinoIcons.doc_on_clipboard;
      case 'canvas':
        return CupertinoIcons.pencil_outline;
      case 'calendar_event':
        return CupertinoIcons.calendar;
      case 'social_post':
        return FeatureColors.socialPost == const Color(0xFF3F51B5)
            ? CupertinoIcons.share
            : CupertinoIcons.share;
      default:
        return CupertinoIcons.question;
    }
  }
}
