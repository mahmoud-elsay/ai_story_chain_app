import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late Animation<double> _particleAnimation;
  late Animation<double> _gradientAnimation;

  final List<Particle> _particles = [];
  final int _particleCount = 50;

  @override
  void initState() {
    super.initState();
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _initializeParticles();
    
    _particleController.repeat();
    _gradientController.repeat(reverse: true);
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.5 + 0.1,
        opacity: random.nextDouble() * 0.8 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_particleAnimation, _gradientAnimation]),
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            particles: _particles,
            particleAnimation: _particleAnimation.value,
            gradientAnimation: _gradientAnimation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class BackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final double particleAnimation;
  final double gradientAnimation;

  BackgroundPainter({
    required this.particles,
    required this.particleAnimation,
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

    // Draw particles
    final particlePaint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    for (final particle in particles) {
      final animatedX = (particle.x + particleAnimation * particle.speed) % 1.0;
      final animatedY = (particle.y + particleAnimation * particle.speed * 0.5) % 1.0;
      
      final x = animatedX * size.width;
      final y = animatedY * size.height;
      
      // Create glowing effect
      particlePaint.color = Color.lerp(
        const Color(0xFF8643DC).withOpacity(particle.opacity * 0.3),
        const Color(0xFF00D4FF).withOpacity(particle.opacity * 0.2),
        gradientAnimation,
      )!;
      
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        particlePaint,
      );
    }

    // Draw neural network connections
    _drawNeuralConnections(canvas, size);
  }

  void _drawNeuralConnections(Canvas canvas, Size size) {
    final connectionPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..blendMode = BlendMode.screen;

    final random = math.Random(42); // Fixed seed for consistent connections
    
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = math.sqrt(
          math.pow(particles[i].x - particles[j].x, 2) +
          math.pow(particles[i].y - particles[j].y, 2),
        );
        
        if (distance < 0.15) {
          final animatedX1 = (particles[i].x + particleAnimation * particles[i].speed) % 1.0;
          final animatedY1 = (particles[i].y + particleAnimation * particles[i].speed * 0.5) % 1.0;
          final animatedX2 = (particles[j].x + particleAnimation * particles[j].speed) % 1.0;
          final animatedY2 = (particles[j].y + particleAnimation * particles[j].speed * 0.5) % 1.0;
          
          final opacity = (1 - distance / 0.15) * 0.3;
          
          connectionPaint.color = Color.lerp(
            const Color(0xFF8643DC).withOpacity(opacity),
            const Color(0xFF00D4FF).withOpacity(opacity * 0.7),
            gradientAnimation,
          )!;
          
          canvas.drawLine(
            Offset(animatedX1 * size.width, animatedY1 * size.height),
            Offset(animatedX2 * size.width, animatedY2 * size.height),
            connectionPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
