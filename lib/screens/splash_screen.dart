// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:oracle_unbound_app/screens/sigil_generator_screen.dart';
import 'package:oracle_unbound_app/widgets/video_background_scaffold.dart'; // Import VideoBackgroundScaffold
import 'package:oracle_unbound_app/screens/about_screen.dart'; // <<<<<<< ADD IMPORT FOR ABOUT SCREEN

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _proceedToApp() {
    Navigator.of(context).pushReplacement(
      // Use pushReplacement to prevent going back to splash
      MaterialPageRoute(
        builder: (BuildContext context) => const SigilGeneratorScreen(),
      ),
    );
  }

  void _navigateToAboutScreen() {
    // <<<<<<< NEW NAVIGATION METHOD
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const AboutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String splashVideoAsset = 'assets/videos/red_nebula.mp4';

    return VideoBackgroundScaffold(
      videoAssetPath: splashVideoAsset,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // --- ICON REMOVED ---
                    // Image.asset(
                    //   'assets/images/icon.png',
                    //   width: 100,
                    //   height: 100,
                    //   errorBuilder: (context, error, stackTrace) {
                    //     return const FlutterLogo(size: 80);
                    //   },
                    // ),
                    // const SizedBox(height: 20), // Space after icon, also removed or adjusted
                    const Text(
                      'Chaos Sigil Generator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.red,
                            offset: Offset(0, 0),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.yellow[600], size: 26),
                              const SizedBox(width: 8),
                              Text(
                                'Disclaimer',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sigil magick is unpredictable and may affect your reality. Results depend on your focus, intent, and belief. We are not responsible for any outcomes that arise from its use.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              'Proceed with awareness.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent.withOpacity(0.95),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _proceedToApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        shadowColor: Colors.redAccent.withOpacity(0.5),
                      ),
                      child: const Text('Acknowledge & Proceed'),
                    ),
                    const SizedBox(
                        height: 20), // <<<<<<< SPACE BEFORE ABOUT BUTTON
                    TextButton(
                      // <<<<<<< ADDED ABOUT/FAQ BUTTON
                      onPressed: _navigateToAboutScreen,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'About Chaos Magick & FAQ',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20), // Space before version
                    Text(
                      "Version 1.0.1", // Consider updating version number
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
