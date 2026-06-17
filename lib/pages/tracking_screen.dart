import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnim;

  static const Color primary = Color(0xFFD4724A);
  static const Color bgDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF2A2A2A);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFF3A3A3A);

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnim = Tween<double>(begin: 0.0, end: 0.72).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Map background
          _buildMapBackground(),
          // Top controls
          SafeArea(
            child: Column(
              children: [
                _buildMapControls(),
              ],
            ),
          ),
          // Bottom panel
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _MapPainter(),
      ),
    );
  }

  Widget _buildMapControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.chevron_left,
                  color: Color(0xFF333333), size: 22),
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.settings_outlined,
                color: Color(0xFF333333), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          _buildTimeInfo(),
          const SizedBox(height: 16),
          _buildProgressBar(),
          const SizedBox(height: 20),
          Container(height: 1, color: divider),
          _buildDeliveryStatus(),
          Container(height: 1, color: divider),
          _buildCourierInfo(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimeInfo() {
    return const Column(
      children: [
        Text(
          '10 minutes left',
          style: TextStyle(
            color: textLight,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Delivery to Phase 1 Hayatabad',
          style: TextStyle(color: textMuted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _progressAnim,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progressAnim.value,
              backgroundColor: const Color(0xFF3A3A3A),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50)),
              minHeight: 6,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryStatus() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delivery_dining, color: primary, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivered your order',
                  style: TextStyle(
                    color: textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We will deliver your goods to you in\nthe shortest possible time.',
                  style: TextStyle(color: textMuted, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourierInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 2),
            ),
            child: ClipOval(
              child: Container(
                color: const Color(0xFF3D3530),
                child: const Icon(Icons.person, color: primary, size: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brooklyn Simmons',
                  style: TextStyle(
                    color: textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Personal Courier',
                  style: TextStyle(color: textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.phone_outlined, color: primary, size: 20),
          ),
        ],
      ),
    );
  }
}

// Custom map painter to simulate a street map
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Light map background
    final bgPaint = Paint()..color = const Color(0xFFE8E4DC);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final blockPaint = Paint()..color = const Color(0xFFD6CFC4);

    // Draw city blocks
    final blocks = [
      Rect.fromLTWH(30, 60, 80, 120),
      Rect.fromLTWH(140, 60, 90, 60),
      Rect.fromLTWH(140, 140, 90, 40),
      Rect.fromLTWH(260, 80, 80, 80),
      Rect.fromLTWH(30, 210, 80, 70),
      Rect.fromLTWH(260, 200, 80, 60),
      Rect.fromLTWH(140, 210, 90, 60),
    ];
    for (final b in blocks) {
      final rrect = RRect.fromRectAndRadius(b, const Radius.circular(4));
      canvas.drawRRect(rrect, blockPaint);
    }

    // Draw horizontal roads
    for (double y = 60; y < size.height - 60; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    // Draw vertical roads
    for (double x = 120; x < size.width; x += 120) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    // Minor roads
    for (double y = 95; y < size.height - 60; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorRoadPaint);
    }

    // Draw route path (highlighted)
    final routePaint = Paint()
      ..color = const Color(0xFFD4724A)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path()
      ..moveTo(80, 260)
      ..lineTo(80, 130)
      ..lineTo(240, 130)
      ..lineTo(240, 190);

    canvas.drawPath(routePath, routePaint);

    // Destination pin
    _drawPin(canvas, Offset(240, 190), const Color(0xFFD4724A));

    // Origin dot
    final originPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawCircle(const Offset(80, 260), 8, originPaint);
    canvas.drawCircle(
        const Offset(80, 260), 8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  void _drawPin(Canvas canvas, Offset center, Color color) {
    const double pinH = 28;
    const double pinR = 12;

    final pinPaint = Paint()..color = color;
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: pinR))
      ..moveTo(center.dx, center.dy + pinR)
      ..lineTo(center.dx - 6, center.dy + pinH)
      ..lineTo(center.dx + 6, center.dy + pinH)
      ..close();
    canvas.drawPath(path, pinPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
