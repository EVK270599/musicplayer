import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late RiveAnimationController _prevButtonController;
  late RiveAnimationController _nextButtonController;
  late RiveAnimationController _soundWaveController;
  late bool _isShowingLyrics;

  SMIInput<bool>? _playButtonInput;
  Artboard? _playButtonArtboard;

  void _playTrackChangeAnimation(RiveAnimationController controller) {
    if (controller.isActive == false) {
      controller.isActive = true;
    }
  }

  void _playPauseButtonAnimation() {
    if (_playButtonInput?.value == false &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = true;
      _toggleWaveAnimation();
    } else if (_playButtonInput?.value == true &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = false;
      _toggleWaveAnimation();
    }
  }

  void _toggleWaveAnimation() => setState(
        () => _soundWaveController.isActive = !_soundWaveController.isActive,
      );

  @override
  void initState() {
    super.initState();
    _prevButtonController = OneShotAnimation(
      'onPrev',
      autoplay: false,
    );
    _nextButtonController = OneShotAnimation(
      'onNext',
      autoplay: false,
    );
    _soundWaveController = SimpleAnimation(
      'loopingAnimation',
      autoplay: false,
    );

    rootBundle.load('assets/PlayPauseButton.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'PlayPauseButton',
      );
      if (controller != null) {
        artboard.addController(controller);
        _playButtonInput = controller.findInput('isPlaying');
      }
      setState(() => _playButtonArtboard = artboard);
    });

    // Initialize other variables
    _isShowingLyrics = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Center(
        child: Stack(
          children: [
            // Background gradient or animation
            // Add dynamic background here

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Interactive album cover
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingLyrics = !_isShowingLyrics;
                    });
                  },
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/album_cover.png'),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // Custom play/pause and track buttons
                _buildCustomControls(),

                SizedBox(height: 40),

                // Animated sound wave visualizer
                Container(
                  height: 100,
                  width: 400,
                  child: RiveAnimation.asset(
                    'assets/SoundWave.riv',
                    fit: BoxFit.contain,
                    controllers: [_soundWaveController],
                  ),
                ),

                SizedBox(height: 20),

                // Optional: Show lyrics
                _isShowingLyrics ? _buildLyricsDisplay() : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomControls() {
    return _playButtonArtboard == null
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (_) =>
                    _playTrackChangeAnimation(_prevButtonController),
                child: SizedBox(
                  height: 115,
                  width: 115,
                  child: RiveAnimation.asset(
                    'assets/PrevTrackButton.riv',
                    controllers: [_prevButtonController],
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => _playPauseButtonAnimation(),
                child: SizedBox(
                  height: 125,
                  width: 125,
                  child: Rive(
                    artboard: _playButtonArtboard!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) =>
                    _playTrackChangeAnimation(_nextButtonController),
                child: SizedBox(
                  height: 115,
                  width: 115,
                  child: RiveAnimation.asset(
                    'assets/NextTrackButton.riv',
                    controllers: [_nextButtonController],
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildLyricsDisplay() {
    // You can replace this with your own widget for displaying lyrics
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'See You Again',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'It s been a long day without you, my friend And I ll tell you all about it when I see you again',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
