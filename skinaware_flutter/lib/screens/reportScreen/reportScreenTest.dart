import 'dart:math' as math;
import 'package:flutter/material.dart';

class ReportSkinTestScreen extends StatefulWidget {
  const ReportSkinTestScreen({super.key});

  @override
  State<ReportSkinTestScreen> createState() => _ReportSkinTestScreenState();
}

class _ReportSkinTestScreenState extends State<ReportSkinTestScreen> {
  static const primaryColor = Color(0xFF0284C7);

  // Tabs (chips)
  final List<_MetricTab> _tabs = const [
    _MetricTab("Elasticity skin", Icons.water_drop_outlined),
    _MetricTab("Sensitive skin", Icons.spa_outlined),
    _MetricTab("Skin wrinkles", Icons.waves_outlined),
    _MetricTab("Hydration", Icons.opacity_outlined),
  ];

  int _selectedTab = 0;

  // Week selector
  final List<String> _weeks = const [
    "Week 1",
    "Week 2",
    "Week 3",
    "Week 4",
  ];
  int _selectedWeek = 0;

  // Example data sets per tab (0..100)
  final Map<int, List<double>> _seriesByTab = {
    0: [22, 45, 38, 42, 50, 46, 76, 30], // Elasticity
    1: [55, 52, 48, 50, 49, 44, 40, 38], // Sensitive
    2: [35, 37, 40, 43, 50, 58, 70, 62], // Wrinkles
    3: [28, 34, 46, 41, 55, 63, 58, 49], // Hydration
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final series =
        _seriesByTab[_selectedTab] ?? const [30, 35, 40, 50, 45, 55, 60, 50];
    final latest = series.isNotEmpty
        ? series[math.min(4, series.length - 1)]
        : 0.0; // “May” point
    final current = series.isNotEmpty ? series.last : 0.0;
    final avg = series.isEmpty
        ? 0.0
        : (series.reduce((a, b) => a + b) / series.length);
    final trend = current - series.first;

    final insight = _buildInsight(
      tabName: _tabs[_selectedTab].label,
      avg: avg,
      current: current,
      trend: trend,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            const SizedBox(height: 6),
            Text(
              "Report skin test analysis",
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),

            const SizedBox(height: 14),

            // Chips row
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final selected = i == _selectedTab;
                  return _MetricChip(
                    label: _tabs[i].label,
                    icon: _tabs[i].icon,
                    selected: selected,
                    primaryColor: primaryColor,
                    onTap: () => setState(() => _selectedTab = i),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Chart Card (like the image)
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Week of ${_selectedWeek == 0
                              ? "1 Mei - 7 Mei 2023"
                              : _selectedWeek == 1
                              ? "8 Mei - 14 Mei 2023"
                              : _selectedWeek == 2
                              ? "15 Mei - 21 Mei 2023"
                              : "22 Mei - 28 Mei 2023"}",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _WeekDropdown(
                        value: _weeks[_selectedWeek],
                        items: _weeks,
                        onChanged: (v) {
                          final idx = _weeks.indexOf(v);
                          if (idx >= 0) setState(() => _selectedWeek = idx);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 190,
                    child: _LineChartCard(
                      primaryColor: primaryColor,
                      series: series,
                      // “May” marker: choose index 4 to match the sample look
                      markerIndex: math.min(4, series.length - 1),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Quick stats under chart (more analytical)
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          title: "Average",
                          value: "${avg.round()}%",
                          icon: Icons.analytics_outlined,
                          primaryColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          title: "Current",
                          value: "${current.round()}%",
                          icon: Icons.trending_up_rounded,
                          primaryColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          title: "Change",
                          value: "${trend >= 0 ? "+" : ""}${trend.round()}%",
                          icon: Icons.swap_vert_rounded,
                          primaryColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Insight / explanation (adds detail)
            _CardShell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Insight",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          insight,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF475569),
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // “Report score” section like the image + more detailed items
            Row(
              children: [
                Text(
                  "Report score",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all"),
                ),
              ],
            ),
            Text(
              "Monday, 7 March 2023",
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 10),

            _ScoreRow(
              primaryColor: primaryColor,
              title: "Score your skin test",
              subtitle: "Elasticity + hydration summary",
              score: 80,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ScoreRow(
              primaryColor: primaryColor,
              title: "Sensitivity overview",
              subtitle: "Barrier calmness indicators",
              score: 62,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ScoreRow(
              primaryColor: primaryColor,
              title: "Wrinkle risk check",
              subtitle: "Texture + fine lines trend",
              score: 71,
              onTap: () {},
            ),

            const SizedBox(height: 14),

            // Recommendations (extra)
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recommended actions",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Bullet(
                    primaryColor: primaryColor,
                    text: "Use a gentle cleanser and avoid over-scrubbing.",
                  ),
                  const SizedBox(height: 8),
                  _Bullet(
                    primaryColor: primaryColor,
                    text: "Moisturize twice daily (focus on barrier support).",
                  ),
                  const SizedBox(height: 8),
                  _Bullet(
                    primaryColor: primaryColor,
                    text: "Wear sunscreen every morning to stabilize trends.",
                  ),
                  const SizedBox(height: 8),
                  _Bullet(
                    primaryColor: primaryColor,
                    text:
                        "Track sleep + water intake for 7 days to compare impact.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildInsight({
    required String tabName,
    required double avg,
    required double current,
    required double trend,
  }) {
    final trendWord = trend >= 0 ? "improving" : "dropping";
    final severity = (current - avg).abs();

    String extra;
    if (severity < 6) {
      extra =
          "Your results are close to your weekly average, which usually means your routine is stable.";
    } else if (current > avg) {
      extra =
          "You’re above your weekly baseline—keep the same routine for a few more days to confirm the improvement.";
    } else {
      extra =
          "You’re below your weekly baseline—consider simplifying your routine and focusing on hydration + barrier care.";
    }

    return "$tabName is currently ${current.round()}% and looks $trendWord (${trend >= 0 ? "+" : ""}${trend.round()}% vs start of week). "
        "Weekly average is ${avg.round()}%. $extra";
  }
}

// ------------------------ UI pieces ------------------------

class _MetricTab {
  final String label;
  final IconData icon;
  const _MetricTab(this.label, this.icon);
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8EEF6)),
      ),
      child: child,
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _MetricChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? primaryColor : const Color(0xFFF1F5F9);
    final fg = selected ? Colors.white : const Color(0xFF0F172A);
    final border = selected ? primaryColor : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _WeekDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color primaryColor;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final Color primaryColor;
  final String title;
  final String subtitle;
  final int score;
  final VoidCallback onTap;

  const _ScoreRow({
    required this.primaryColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EEF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.description_outlined, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "$score%",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final Color primaryColor;
  final String text;

  const _Bullet({required this.primaryColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check_rounded, size: 14, color: primaryColor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------------ Chart (no packages) ------------------------

class _LineChartCard extends StatelessWidget {
  final Color primaryColor;
  final List<double> series;
  final int markerIndex;

  const _LineChartCard({
    required this.primaryColor,
    required this.series,
    required this.markerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        primaryColor: primaryColor,
        series: series,
        markerIndex: markerIndex.clamp(0, math.max(0, series.length - 1)),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final Color primaryColor;
  final List<double> series;
  final int markerIndex;

  _LineChartPainter({
    required this.primaryColor,
    required this.series,
    required this.markerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 36.0;
    final rightPad = 12.0;
    final topPad = 12.0;
    final bottomPad = 28.0;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    final rect = Rect.fromLTWH(leftPad, topPad, chartW, chartH);

    // Background
    final bg = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      bg,
    );

    // Grid + Y labels (0..100)
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );

    for (int i = 0; i <= 5; i++) {
      final t = i / 5.0;
      final y = rect.top + rect.height * t;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), gridPaint);

      final value = (100 - (t * 100)).round();
      final tp = TextPainter(
        text: TextSpan(text: "$value%", style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: leftPad - 6);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // X labels (Jan..Jul like the image)
    const months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul"];
    final xLabelStyle = const TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    for (int i = 0; i < months.length; i++) {
      final x = rect.left + (rect.width * (i / (months.length - 1)));
      final tp = TextPainter(
        text: TextSpan(text: months[i], style: xLabelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, rect.bottom + 6));
    }

    if (series.length < 2) return;

    // Normalize
    double clamp01(double v) => v.clamp(0.0, 100.0);

    final points = <Offset>[];
    for (int i = 0; i < series.length; i++) {
      final x = rect.left + rect.width * (i / (series.length - 1));
      final y = rect.top + rect.height * (1 - (clamp01(series[i]) / 100));
      points.add(Offset(x, y));
    }

    // Fill under line (soft)
    final fillPath = Path()
      ..moveTo(points.first.dx, rect.bottom)
      ..lineTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath
      ..lineTo(points.last.dx, rect.bottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.18),
          primaryColor.withOpacity(0.02),
        ],
      ).createShader(rect);

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Marker (vertical dashed + dot + bubble)
    final mi = markerIndex.clamp(0, points.length - 1);
    final m = points[mi];

    final dashPaint = Paint()
      ..color = primaryColor.withOpacity(0.55)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawDashedLine(
      canvas,
      dashPaint,
      Offset(m.dx, rect.top),
      Offset(m.dx, rect.bottom),
      dash: 6,
      gap: 6,
    );

    // Big dot
    canvas.drawCircle(m, 7, Paint()..color = Colors.white);
    canvas.drawCircle(m, 5, Paint()..color = primaryColor);

    // Bubble label (e.g., 50%)
    final bubbleText = "${series[mi].round()}%";
    final bubbleTP = TextPainter(
      text: TextSpan(
        text: bubbleText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final bubbleW = bubbleTP.width + 18;
    final bubbleH = bubbleTP.height + 10;
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(m.dx, rect.top + 16),
        width: bubbleW,
        height: bubbleH,
      ),
      const Radius.circular(12),
    );

    final bubblePaint = Paint()..color = primaryColor;
    canvas.drawRRect(bubbleRect, bubblePaint);

    // little pointer triangle
    final tip = Path();
    tip.moveTo(m.dx - 7, bubbleRect.bottom);
    tip.lineTo(m.dx + 7, bubbleRect.bottom);
    tip.lineTo(m.dx, bubbleRect.bottom + 8);
    tip.close();
    canvas.drawPath(tip, bubblePaint);

    bubbleTP.paint(
      canvas,
      Offset(
        bubbleRect.center.dx - bubbleTP.width / 2,
        bubbleRect.center.dy - bubbleTP.height / 2,
      ),
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b, {
    required double dash,
    required double gap,
  }) {
    final total = (b - a);
    final len = total.distance;
    final dir = total / len;

    double t = 0;
    while (t < len) {
      final start = a + dir * t;
      final end = a + dir * math.min(t + dash, len);
      canvas.drawLine(start, end, paint);
      t += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.markerIndex != markerIndex ||
        oldDelegate.series != series;
  }
}
