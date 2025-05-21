// lib/screens/sigil_generator_screen.dart
// Full Flutter Sigil Generator – Retooled with Back to Splash, Audio & Conditional Export Background
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data'; // For Uint8List
import 'dart:ui' as ui; // For ui.Image
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart'; // <<<<<<< ADDED for music

// Import SplashScreen to navigate back to it
import 'package:oracle_unbound_app/screens/splash_screen.dart';

import '../widgets/video_background_scaffold.dart'; // Ensure this path is correct

class SigilGeneratorScreen extends StatefulWidget {
  const SigilGeneratorScreen({super.key});

  @override
  State<SigilGeneratorScreen> createState() => _SigilGeneratorScreenState();
}

// <<<<<<< ADDED WidgetsBindingObserver for app lifecycle
class _SigilGeneratorScreenState extends State<SigilGeneratorScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _pathAnimationController;
  late Animation<double> _pathAnimation;
  late AnimationController _circleAnimationController;
  late Animation<double> _circleAnimation;
  late AnimationController _flyingLetterMasterController;

  Path _sigilPath = Path();
  List<Offset> _circlePoints = [];
  String _reduced = '';
  String _input = '';
  bool _showReducedText = false;
  List<Widget> _flyingLetterWidgets = [];

  bool _showIntentionBar = true;
  double _intentionBarOpacity = 1.0;
  bool _sigilAnimationsComplete = false;

  final GlobalKey _sigilBoundaryKey = GlobalKey();
  bool _isExporting = false;
  bool _drawBackgroundForExport = false;

  // --- AUDIO PLAYER ---
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // <<<<<<< ADDED audio player instance
  bool _isMusicPlaying = false; // <<<<<<< ADDED to track music state

  static const int _pathAnimationDurationMs = 5200;
  static const int _circleAnimationDurationMs = 1200;
  // ... (other static const durations remain the same)
  static const int _flyingLettersDurationMs = 1600;
  static const int _flyingLettersStaggerMs = 100;
  static const int _pauseAfterFlyingLettersMs = 200;
  static const int _pauseBeforeCircleMs = 500;
  static const int _intentionBarFadeMs = 400;
  static const int _glyphsTextFadeOutDelayMs = 700;
  static const int _glyphsTextFadeDurationMs = 400;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // <<<<<<< ADDED observer for lifecycle

    _pathAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _pathAnimationDurationMs),
    );
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _circleAnimationDurationMs),
    );
    _flyingLetterMasterController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _flyingLettersDurationMs + (_flyingLettersStaggerMs * 15),
      ),
    );
    _pathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _pathAnimationController, curve: Curves.easeInOutSine),
    )..addListener(() => setState(() {}));
    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _circleAnimationController, curve: Curves.easeOutQuint),
    )..addListener(() => setState(() {}));

    _playAmbientMusic(); // <<<<<<< ADDED call to play music
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // <<<<<<< REMOVED observer
    _stopAmbientMusic(); // <<<<<<< ADDED call to stop music
    _audioPlayer.dispose(); // <<<<<<< DISPOSE audio player

    _controller.dispose();
    _pathAnimationController.dispose();
    _circleAnimationController.dispose();
    _flyingLetterMasterController.dispose();
    super.dispose();
  }

  // --- APP LIFECYCLE CHANGES FOR MUSIC ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // <<<<<<< ADDED LIFECYCLE METHOD
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      if (_isMusicPlaying) {
        _audioPlayer.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      // Only resume if it was playing before and the screen is still active
      // And we intend for music to be playing on this screen.
      if (_isMusicPlaying && mounted) {
        _audioPlayer.resume();
      }
    }
  }

  // --- MUSIC CONTROL METHODS ---
  Future<void> _playAmbientMusic() async {
    // <<<<<<< ADDED METHOD
    try {
      // Ensure you have 'background.mp3' (or your chosen file) in 'assets/audio/'
      // and declared in pubspec.yaml
      await _audioPlayer.setSource(AssetSource('audio/background.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
      if (mounted) {
        setState(() {
          _isMusicPlaying = true;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error playing music: $e");
      if (mounted) {
        setState(() {
          _isMusicPlaying = false;
        });
      }
    }
  }

  Future<void> _stopAmbientMusic() async {
    // <<<<<<< ADDED METHOD
    try {
      await _audioPlayer.stop();
      if (mounted) {
        setState(() {
          _isMusicPlaying = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error stopping music: $e");
    }
  }
  // --- END MUSIC CONTROL METHODS ---

  // ... (_resetSigilState, _generateSigil, _generateCirclePoints, _generateSigilPath, _exportSigil methods remain IDENTICAL to your last provided block)
  void _resetSigilState() {
    _pathAnimationController.reset();
    _circleAnimationController.reset();
    _flyingLetterMasterController.reset();
    setState(() {
      _sigilPath = Path();
      _circlePoints = [];
      _reduced = '';
      _showReducedText = false;
      _flyingLetterWidgets = [];
      _showIntentionBar = true;
      _intentionBarOpacity = 1.0;
      _sigilAnimationsComplete = false;
      _drawBackgroundForExport = false;
    });
  }

  void _generateSigil() async {
    if (_controller.text.isEmpty && _showIntentionBar) return;
    if (!_showIntentionBar) {
      _resetSigilState();
      await Future.delayed(const Duration(milliseconds: 20));
      if (_controller.text.isEmpty) return;
    }
    _pathAnimationController.reset();
    _circleAnimationController.reset();
    _flyingLetterMasterController.reset();
    setState(() {
      _input = _controller.text.toUpperCase();
      _showIntentionBar = false;
      _intentionBarOpacity = 0.0;
      _sigilPath = Path();
      _circlePoints = [];
      _flyingLetterWidgets = [];
      _reduced = '';
      _showReducedText = true;
      _sigilAnimationsComplete = false;
      _drawBackgroundForExport = false;
    });

    final rawInput = _input;
    final noVowels = rawInput.replaceAll(RegExp(r'[AEIOU\s]'), '');
    final seen = <String>{};
    final reducedString =
        noVowels.split('').where((char) => seen.add(char)).join();
    if (mounted) setState(() => _reduced = reducedString);

    final List<String> simpleFlyingChars = [];
    Set<String> tempKeptChars = reducedString.split('').toSet();
    for (final char in rawInput.replaceAll(' ', '').split('')) {
      if (!tempKeptChars.contains(char)) {
        simpleFlyingChars.add(char);
      } else {
        tempKeptChars.remove(char);
      }
    }
    final size = MediaQuery.of(context).size;
    final screenCenterForFlyingLetters = Offset(
      size.width / 2,
      size.height / 2 - (AppBar().preferredSize.height / 2),
    );
    _flyingLetterMasterController.forward(from: 0.0);
    await Future.delayed(
        const Duration(milliseconds: _intentionBarFadeMs ~/ 3));
    for (int i = 0; i < simpleFlyingChars.length; i++) {
      final char = simpleFlyingChars[i];
      Future.delayed(Duration(milliseconds: i * _flyingLettersStaggerMs), () {
        if (!mounted) return;
        final angle = Random().nextDouble() * 2 * pi;
        final distance =
            (size.width / 3.5) + Random().nextDouble() * (size.width / 4.5);
        final target = Offset(
          screenCenterForFlyingLetters.dx + distance * cos(angle),
          screenCenterForFlyingLetters.dy + distance * sin(angle),
        );
        setState(() => _flyingLetterWidgets.add(FlyingLetterWidget(
              key: UniqueKey(),
              char: char,
              start: screenCenterForFlyingLetters,
              end: target,
              duration: const Duration(milliseconds: _flyingLettersDurationMs),
            )));
      });
    }
    await Future.delayed(Duration(
        milliseconds: _flyingLettersDurationMs +
            (simpleFlyingChars.length * _flyingLettersStaggerMs ~/ 2) +
            _pauseAfterFlyingLettersMs));
    Future.delayed(
        Duration(
            milliseconds: _flyingLettersDurationMs +
                (simpleFlyingChars.length * _flyingLettersStaggerMs) +
                500), () {
      if (mounted) setState(() => _flyingLetterWidgets = []);
    });

    if (reducedString.isEmpty) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() => _showReducedText = false);
          _resetSigilState();
        }
      });
      return;
    }

    const double sigilPointsRadius = 85.0;
    _circlePoints = _generateCirclePoints(reducedString, sigilPointsRadius);
    _sigilPath = _generateSigilPath(reducedString, _circlePoints);
    _pathAnimationController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: _glyphsTextFadeOutDelayMs), () {
      if (mounted) setState(() => _showReducedText = false);
    });
    await Future.delayed(const Duration(
        milliseconds: _pathAnimationDurationMs + _pauseBeforeCircleMs));
    if (!mounted) return;
    _circleAnimationController.forward(from: 0.0);
    await Future.delayed(
        const Duration(milliseconds: _circleAnimationDurationMs + 200));
    if (mounted) setState(() => _sigilAnimationsComplete = true);
  }

  List<Offset> _generateCirclePoints(String input, double radius) {
    final length = input.length;
    if (length == 0) return [];
    final angleStep = 2 * pi / length;
    return List.generate(length, (i) {
      final angle = angleStep * i;
      const jitter = 0.0;
      final r = radius + jitter;
      return Offset(r * cos(angle), r * sin(angle));
    });
  }

  Path _generateSigilPath(String input, List<Offset> points) {
    if (points.length < 2) return Path();
    final random = Random(input.hashCode);
    final pathOrder = <int>[];
    final Set<int> visitedIndices = {};
    int currentIndex = random.nextInt(points.length);
    while (visitedIndices.length < points.length) {
      pathOrder.add(currentIndex);
      visitedIndices.add(currentIndex);
      List<int> availableIndices = List.generate(points.length, (i) => i)
          .where((i) => !visitedIndices.contains(i))
          .toList();
      if (availableIndices.isEmpty) break;
      List<int> farCandidates = availableIndices.where((i) {
        int diff = (i - currentIndex).abs();
        return diff > 1 && diff < points.length - 1;
      }).toList();
      if (farCandidates.isNotEmpty) {
        currentIndex = farCandidates[random.nextInt(farCandidates.length)];
      } else {
        currentIndex =
            availableIndices[random.nextInt(availableIndices.length)];
      }
    }
    final path = Path();
    if (pathOrder.isNotEmpty) {
      path.moveTo(points[pathOrder[0]].dx, points[pathOrder[0]].dy);
      for (final index in pathOrder.skip(1)) {
        path.lineTo(points[index].dx, points[index].dy);
      }
    }
    return path;
  }

  Future<void> _exportSigil() async {
    if (!_sigilAnimationsComplete ||
        _sigilPath.computeMetrics().isEmpty ||
        _isExporting) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please wait for sigil animation to complete.')));
      return;
    }

    setState(() {
      _isExporting = true;
      _drawBackgroundForExport = true;
    });
    await Future.delayed(const Duration(milliseconds: 50));

    var storageStatus = await Permission.storage.status;
    var photosStatus = await Permission.photos.status;

    bool permissionGranted = false;
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      permissionGranted = true;
    }
    if (!permissionGranted) {
      if (photosStatus.isDenied)
        photosStatus = await Permission.photos.request();
      if (storageStatus.isDenied)
        storageStatus = await Permission.storage.request();
      permissionGranted = photosStatus.isGranted || storageStatus.isGranted;
    }

    if (permissionGranted) {
      try {
        RenderRepaintBoundary boundary = _sigilBoundaryKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) throw Exception("ByteData is null");
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final result = await ImageGallerySaver.saveImage(
          pngBytes,
          quality: 100,
          name: "sigil_${DateTime.now().millisecondsSinceEpoch}",
        );

        if (mounted) {
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Sigil saved to Gallery: ${result['filePath'] ?? ''}')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Failed to save sigil: ${result['errorMessage'] ?? 'Unknown error'}')));
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print("Error exporting sigil: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error exporting sigil: $e')));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gallery permission denied. Cannot save sigil.')));
      }
    }

    if (mounted) {
      setState(() {
        _isExporting = false;
        _drawBackgroundForExport = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoBackgroundScaffold(
      videoAssetPath: 'assets/videos/sparks.mp4',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.redAccent[100]),
            tooltip: 'Back to Home', // Updated tooltip
            onPressed: () {
              // Navigate to SplashScreen and remove all routes above it.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) =>
                    false, // This predicate removes all routes.
              );
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Sigil Generator',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Stack(
          // ... (The rest of the body Stack and its children remain IDENTICAL to your last provided block)
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _intentionBarOpacity,
                    duration: const Duration(milliseconds: _intentionBarFadeMs),
                    child: Visibility(
                      visible: _showIntentionBar,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _controller,
                            enabled: _showIntentionBar,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Enter your intention...',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6)),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.redAccent.withOpacity(0.5))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.redAccent, width: 1.5)),
                            ),
                            onSubmitted: (_) => _generateSigil(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                _showIntentionBar ? _generateSigil : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.85),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Conjure Sigil'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 20 + 22 + 10),
                    secondChild: const SizedBox.shrink(),
                    crossFadeState: _showIntentionBar
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: _intentionBarFadeMs),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeIn,
                    sizeCurve: Curves.bounceOut,
                  ),
                  AnimatedOpacity(
                    opacity: _showReducedText ? 1.0 : 0.0,
                    duration:
                        const Duration(milliseconds: _glyphsTextFadeDurationMs),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        _reduced.isNotEmpty
                            ? 'Glyphs: $_reduced'
                            : (_input.isNotEmpty && !_showIntentionBar
                                ? 'Processing...'
                                : ''),
                        style: TextStyle(
                          color: Colors.redAccent.withOpacity(0.9),
                          fontSize: 18,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black54,
                                offset: Offset(1, 1))
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      key: _sigilBoundaryKey,
                      child: CustomPaint(
                        painter: AnimatedSigilPainter(
                          fullPath: _sigilPath,
                          progress: _pathAnimation.value,
                          circlePoints: _circlePoints,
                          circleProgress: _circleAnimation.value,
                          drawBackgroundOnExport: _drawBackgroundForExport,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  if (_sigilAnimationsComplete &&
                      !_showIntentionBar &&
                      _sigilPath.computeMetrics().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton.icon(
                        icon: _isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save_alt),
                        label: Text(_isExporting
                            ? 'Exporting...'
                            : 'Export Sigil as PNG'),
                        onPressed: _isExporting ? null : _exportSigil,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueGrey[700]?.withOpacity(0.85),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )
                  else if (!_showIntentionBar)
                    const SizedBox(height: 56 + 16),
                  if (_sigilAnimationsComplete && !_showIntentionBar)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextButton(
                        onPressed: _resetSigilState,
                        child: const Text('Create New Sigil',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16)),
                      ),
                    )
                  else if (!_showIntentionBar)
                    const SizedBox(height: 40 + 8),
                ],
              ),
            ),
            ..._flyingLetterWidgets,
          ],
        ),
      ),
    );
  }
}

// --- FlyingLetterWidget (NO CHANGES) ---
class FlyingLetterWidget extends StatefulWidget {
  final String char;
  final Offset start;
  final Offset end;
  final Duration duration;
  final VoidCallback? onComplete;

  const FlyingLetterWidget({
    required this.char,
    required this.start,
    required this.end,
    required this.duration,
    this.onComplete,
    super.key,
  });

  @override
  State<FlyingLetterWidget> createState() => _FlyingLetterWidgetState();
}

class _FlyingLetterWidgetState extends State<FlyingLetterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete?.call();
      });
    _position = Tween<Offset>(begin: widget.start, end: widget.end).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 15),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 25),
    ]).animate(_controller);
    _scale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.5, end: 1.2)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 70),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_opacity.value <= 0.01 &&
            (_controller.isCompleted || _controller.isDismissed))
          return const SizedBox.shrink();
        return Positioned(
          left: _position.value.dx - (18 * _scale.value / 2),
          top: _position.value.dy - (18 * _scale.value / 2),
          child: Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                  scale: _scale.value,
                  child: Text(widget.char,
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                blurRadius: 6,
                                color: Colors.red,
                                offset: Offset(0, 0))
                          ])))),
        );
      },
    );
  }
}

// --- AnimatedSigilPainter (NO CHANGES) ---
class AnimatedSigilPainter extends CustomPainter {
  final Path fullPath;
  final double progress;
  final List<Offset> circlePoints;
  final double circleProgress;
  final bool drawBackgroundOnExport;

  AnimatedSigilPainter({
    required this.fullPath,
    required this.progress,
    required this.circlePoints,
    required this.circleProgress,
    required this.drawBackgroundOnExport,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || size.width <= 0 || size.height <= 0) return;

    if (drawBackgroundOnExport) {
      final backgroundPaint = Paint()..color = Colors.black;
      canvas.drawRect(Offset.zero & size, backgroundPaint);
    }

    final Offset center = Offset(size.width / 2, size.height / 2);

    final pointPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    const pointRadius = 1.75;
    for (final pointOffset in circlePoints) {
      canvas.drawCircle(pointOffset + center, pointRadius, pointPaint);
    }
    final pathPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.75
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    final metrics = fullPath.computeMetrics().toList();
    for (final metric in metrics) {
      if (metric.length == 0) continue;
      final extractLength = metric.length * progress;
      if (extractLength <= 0) continue;
      final partialPath = metric.extractPath(0, extractLength);
      canvas.drawPath(partialPath.shift(center), glowPaint);
      canvas.drawPath(partialPath.shift(center), pathPaint);
    }
    if (circleProgress > 0) {
      const double outerCircleRadius = 105.0;
      const double baseStrokeWidth = 1.5;
      final double animatedStrokeWidth = baseStrokeWidth +
          (1.0 * Curves.easeOutExpo.transform(circleProgress));
      final circleOpacity = Curves.easeInOutCubic.transform(circleProgress);
      final enclosingCirclePaint = Paint()
        ..color = Colors.redAccent.withOpacity(circleOpacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = animatedStrokeWidth
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawCircle(center, outerCircleRadius, enclosingCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedSigilPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.circleProgress != circleProgress ||
      !listEquals(oldDelegate.circlePoints, circlePoints) ||
      oldDelegate.fullPath != fullPath ||
      oldDelegate.drawBackgroundOnExport != drawBackgroundOnExport;
}

// --- listEquals Helper (NO CHANGES) ---
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// --- openAppSettings Placeholder (NO CHANGES) ---
Future<void> openAppSettings() async {
  // ignore: avoid_print
  print("Attempting to open app settings. Implement with a plugin if needed.");
}
