import 'dart:math' as math;
import 'package:flutter/material.dart';

class WebOptimizedBackground extends StatefulWidget {
  const WebOptimizedBackground({super.key});

  @override
  State<WebOptimizedBackground> createState() => _WebOptimizedBackgroundState();
}

class _WebOptimizedBackgroundState extends State<WebOptimizedBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  final List<Particle> _particles = [];
  static const int _particleCount = 12; // Reduced particle count for web

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(
        seconds: 12,
      ), // Slower animation for smoother performance
      vsync: this,
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _initializeParticles();
    _gradientController.repeat(reverse: true);
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 2 + 1, // Smaller particles
          speed: 0, // Static particles for better performance
          opacity: random.nextDouble() * 0.6 + 0.2, // Reduced opacity
        ),
      );
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Add RepaintBoundary for optimization
      child: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WebOptimizedBackgroundPainter(
              particles: _particles,
              gradientAnimation: _gradientAnimation.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class WebOptimizedBackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final double gradientAnimation;

  const WebOptimizedBackgroundPainter({
    required this.particles,
    required this.gradientAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(
          const Color(0xFF0A0A0A),
          const Color(0xFF1A0A2E),
          gradientAnimation,
        )!,
        Color.lerp(
          const Color(0xFF16213E),
          const Color(0xFF0F3460),
          gradientAnimation,
        )!,
        Color.lerp(
          const Color(0xFF533483),
          const Color(0xFF8643DC),
          gradientAnimation,
        )!,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Draw static particles
    final particlePaint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height;

      particlePaint.color = Color.lerp(
        const Color(0xFF8643DC).withOpacity(particle.opacity * 0.2),
        const Color(0xFF00D4FF).withOpacity(particle.opacity * 0.15),
        gradientAnimation,
      )!;

      canvas.drawCircle(Offset(x, y), particle.size, particlePaint);
    }

    // Draw minimal connections
    _drawOptimizedConnections(canvas, size);
  }

  void _drawOptimizedConnections(Canvas canvas, Size size) {
    final connectionPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          0.3 // Thinner lines for better performance
      ..blendMode = BlendMode.screen;

    const maxConnections = 8; // Very limited connections for web
    var connections = 0;

    for (int i = 0; i < particles.length && connections < maxConnections; i++) {
      for (
        int j = i + 1;
        j < particles.length && connections < maxConnections;
        j++
      ) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distSquared = dx * dx + dy * dy;

        if (distSquared > 0.04) continue; // Shorter connection distance

        connections++;
        final opacity = (1 - math.sqrt(distSquared) / 0.2) * 0.2;

        connectionPaint.color = Color.lerp(
          const Color(0xFF8643DC).withOpacity(opacity),
          const Color(0xFF00D4FF).withOpacity(opacity * 0.5),
          gradientAnimation,
        )!;

        canvas.drawLine(
          Offset(particles[i].x * size.width, particles[i].y * size.height),
          Offset(particles[j].x * size.width, particles[j].y * size.height),
          connectionPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant WebOptimizedBackgroundPainter oldDelegate) {
    return oldDelegate.gradientAnimation != gradientAnimation;
  }
}
