// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:oracle_unbound_app/widgets/video_background_scaffold.dart'; // Optional: if you want video bg here too

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Helper widget for FAQ items
  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: Colors.redAccent[100], // Lighter red for questions
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can choose a different video or no video for this screen.
    // If no video, remove VideoBackgroundScaffold and use a normal Scaffold with a dark background.
    const String aboutVideoAsset =
        'assets/videos/red_nebula.mp4'; // Or another video, or null

    return VideoBackgroundScaffold(
      // << Optional: Remove if you don't want video bg here
      videoAssetPath: aboutVideoAsset,
      child: Scaffold(
        backgroundColor: Colors.transparent, // For VideoBackgroundScaffold
        // If not using VideoBackgroundScaffold, set:
        // backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'About Chaos Magick',
            style: TextStyle(color: Colors.redAccent),
          ),
          backgroundColor: Colors.transparent, // For VideoBackgroundScaffold
          // If not using VideoBackgroundScaffold, set:
          // backgroundColor: Colors.grey[900],
          elevation: 0,
          iconTheme: const IconThemeData(
              color: Colors.redAccent), // Styles the back button
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Understanding Chaos Magick',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[300],
                    shadows: const [
                      Shadow(
                          blurRadius: 2,
                          color: Colors.red,
                          offset: Offset(0, 0))
                    ]),
              ),
              const SizedBox(height: 16),
              Text(
                'Chaos magick is a contemporary magical tradition characterized by its '
                'rejection of dogma and its emphasis on the pragmatic use of belief systems. '
                'Practitioners believe that the "belief" itself is a tool for achieving effects, '
                'rather than adhering to a single, fixed set of beliefs or traditions.',
                style: TextStyle(
                    color: Colors.grey[300], fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.redAccent.withOpacity(0.3)),
              const SizedBox(height: 20),
              Text(
                'Frequently Asked Questions (FAQ)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[300],
                ),
              ),
              const SizedBox(height: 16),
              _buildFaqItem(
                  context,
                  'Q: What is a sigil?',
                  'A: In chaos magick, a sigil is a symbol created to represent a desired outcome or intent. '
                      'It\'s typically formed from a statement of intent, condensed and stylized, then charged '
                      'with energy and often forgotten by the conscious mind to allow the subconscious to work on the intent.'),
              _buildFaqItem(
                  context,
                  'Q: How does this app help create sigils?',
                  'A: This app uses a common method where vowels and repeated consonants are removed from your stated intention. '
                      'The remaining unique consonants are then mapped to points on a circular grid (a "rose" or similar pattern) '
                      'and connected to form a unique glyph. This glyph is your sigil.'),
              _buildFaqItem(
                  context,
                  'Q: Is belief necessary?',
                  'A: Chaos magick operates on the principle of "belief as a tool." While you don\'t need to subscribe to a specific '
                      'deity or spiritual system, a temporary, focused belief in the efficacy of your sigil and the process is often '
                      'considered crucial for success. The act of creating and charging the sigil is an exercise in focusing this belief.'),
              _buildFaqItem(
                  context,
                  'Q: How do I "charge" a sigil created with this app?',
                  'A: There are many methods. Common ways include: intense concentration on the sigil during a peak emotional state '
                      '(e.g., meditation, orgasm, exhaustion, intense joy/fear), burning it, or visualizing it with focused energy. '
                      'The key is to impress the sigil upon your subconscious mind.'),
              _buildFaqItem(
                  context,
                  'Q: What happens after charging?',
                  'A: After charging, it\'s generally advised to "forget" the sigil and the desire. This is to prevent conscious '
                      'interference or "lust of result," allowing the subconscious and the "universe" to manifest the intent without '
                      'the ego getting in the way.'),
              _buildFaqItem(
                  context,
                  'Q: Are there any risks?',
                  'A: As the disclaimer states, magick can be unpredictable. Clearly define your intentions, as poorly worded '
                      'intentions can manifest in unexpected or undesirable ways. Be mindful of the ethical implications of your desires. '
                      'Start with small, positive intentions if you are new.'),
              const SizedBox(height: 20),
              Text(
                'This app is a tool. Your intention, focus, and belief are the true agents of change. Use responsibly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent[100],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
