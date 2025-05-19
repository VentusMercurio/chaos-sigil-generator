// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:oracle_unbound_app/screens/sigil_generator_screen.dart';
import 'package:oracle_unbound_app/widgets/video_background_scaffold.dart'; // Import VideoBackgroundScaffold

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _proceedToApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const SigilGeneratorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Choose a video for your splash screen.
    // You might want a different, perhaps more subtle video than the main app.
    // For this example, I'll use the same 'red_nebula.mp4'.
    // Make sure this asset exists in 'assets/videos/'.
    const String splashVideoAsset = 'assets/videos/red_nebula.mp4';

    return VideoBackgroundScaffold(
      videoAssetPath: splashVideoAsset,
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Important for video background to show
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              // <-- WRAP WITH SingleChildScrollView
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height:
                            20), // Add some top padding if needed when scrollable
                    Image.asset(
                      'assets/images/splash_logo.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const FlutterLogo(size: 80);
                      },
                    ),
                    const SizedBox(height: 20),
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
                        color: Colors.black.withOpacity(
                            0.75), // Slightly more opaque background for readability
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
                              color: Colors.white.withOpacity(
                                  0.9), // Increased opacity for readability
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
                                color: Colors.redAccent
                                    .withOpacity(0.95), // Increased opacity
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: Colors.redAccent.withOpacity(0.5),
                      ),
                      child: const Text('Acknowledge & Proceed'),
                    ),
                    const SizedBox(height: 30), // Space before version
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize:
                              12), // Lighter grey for better visibility on video
                    ),
                    const SizedBox(
                        height: 20), // Add some bottom padding if needed
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
