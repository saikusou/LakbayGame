import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayTwoActFour extends StatefulWidget {
  final UserModel user;

  const LessonOneDayTwoActFour({super.key, required this.user});

  @override
  State<LessonOneDayTwoActFour> createState() => _LessonOneDayTwoActFourState();
}

class _LessonOneDayTwoActFourState extends State<LessonOneDayTwoActFour> {
  static const String backgroundImage = 'assets/lesson-two-day2-act4a.png';

  final Map<String, String?> answers = {
    'Teoryang Austronesyano': null,
    'Core Population': null,
    'Kaalamang Bayan': null,
  };

  final Map<String, String> correctAnswers = {
    'Teoryang Austronesyano': 'Taiwan',
    'Core Population': 'Sinaunang Grupo',
    'Kaalamang Bayan': 'Alamat',
  };

  final List<Map<String, String>> choices = [
    {
      'id': 'Taiwan',
      'text': 'Nagmula sa Taiwan gamit ang bangka.',
      'icon': '⛵',
    },
    {
      'id': 'Sinaunang Grupo',
      'text': 'Umunlad mula sa mga sinaunang grupong nanirahan sa kapuluan.',
      'icon': '👨‍👩‍👧‍👦',
    },
    {
      'id': 'Alamat',
      'text': 'Mga alamat at kwento ng mga ninuno.',
      'icon': '📖',
    },
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String getChoiceText(String id) {
    return choices.firstWhere((choice) => choice['id'] == id)['text']!;
  }

  void placeAnswer(String rowTitle, String choiceId) {
    setState(() {
      answers.updateAll((key, value) => value == choiceId ? null : value);
      answers[rowTitle] = choiceId;
    });
  }

  void removeAnswer(String choiceId) {
    setState(() {
      answers.updateAll((key, value) => value == choiceId ? null : value);
    });
  }

  int getScore() {
    int total = 0;

    answers.forEach((key, value) {
      if (value == correctAnswers[key]) total++;
    });

    return total;
  }

  void checkAnswers() {
    final total = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final bool perfect = total == 3;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6D8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.brown, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 54)),
                const SizedBox(height: 8),
                Text(
                  perfect ? 'Congratulations!' : 'Magaling!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  perfect
                      ? 'Nakuha mo lahat ng tamang sagot!'
                      : 'Natapos mo ang gawain!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Text(
                    'Score: $total / 3',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Lesson1Screen(user: widget.user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget header(double iconSize) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Lesson1Screen(user: widget.user),
              ),
            );
          },
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: iconSize * 0.58,
            ),
          ),
        ),
      ],
    );
  }

  Widget tableHeaderText(String text, double fontSize) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget tableHeader(double fontSize, double height) {
    return Container(
      height: height,
      color: Colors.blue[900],
      child: Row(
        children: [
          tableHeaderText('PALIWANAG', fontSize),
          tableHeaderText('PANGUNAHING IDEYA', fontSize),
          tableHeaderText('URI', fontSize),
        ],
      ),
    );
  }

  Widget tableRow({
    required String title,
    required String leftIcon,
    required String rightIcon,
    required String rightText,
    required Color dropColor,
    required double rowHeight,
    required double iconSize,
    required double titleFont,
    required double answerFont,
  }) {
    final current = answers[title];

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.blue.shade900)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: rowHeight,
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: Row(
                children: [
                  Text(leftIcon, style: TextStyle(fontSize: iconSize)),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: titleFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DragTarget<String>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (details) {
                placeAnswer(title, details.data);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: rowHeight,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: dropColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: dropColor, width: 1.5),
                  ),
                  child: current == null
                      ? Text(
                          'I-drag ang sagot dito',
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: answerFont,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Draggable<String>(
                          data: current,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 230,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: dropColor, width: 2),
                              ),
                              child: Text(
                                getChoiceText(current),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: answerFont + 2,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Text(
                            'I-drag ang sagot dito',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: answerFont,
                              color: Colors.grey[600],
                            ),
                          ),
                          child: Text(
                            getChoiceText(current),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: answerFont,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              height: rowHeight,
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: Row(
                children: [
                  Text(rightIcon, style: TextStyle(fontSize: iconSize)),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      rightText,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: titleFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableBox(Size size) {
    final rowHeight = clampDouble(size.height * 0.105, 62, 88);
    final iconSize = clampDouble(size.width * 0.055, 16, 25);
    final titleFont = clampDouble(size.width * 0.024, 8, 12);
    final answerFont = clampDouble(size.width * 0.022, 7, 11);
    final headerHeight = clampDouble(size.height * 0.045, 28, 36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tableHeader(titleFont, headerHeight),
          tableRow(
            title: 'Teoryang Austronesyano',
            leftIcon: '⛵',
            rightIcon: '🧪',
            rightText: 'Siyentipikong\nPag-aaral',
            dropColor: Colors.lightBlue,
            rowHeight: rowHeight,
            iconSize: iconSize,
            titleFont: titleFont,
            answerFont: answerFont,
          ),
          tableRow(
            title: 'Core Population',
            leftIcon: '🏝️',
            rightIcon: '🧪',
            rightText: 'Siyentipikong\nPag-aaral',
            dropColor: Colors.lightGreen,
            rowHeight: rowHeight,
            iconSize: iconSize,
            titleFont: titleFont,
            answerFont: answerFont,
          ),
          tableRow(
            title: 'Kaalamang Bayan',
            leftIcon: '📖',
            rightIcon: '📚',
            rightText: 'Alamat /\nKwento',
            dropColor: Colors.orange,
            rowHeight: rowHeight,
            iconSize: iconSize,
            titleFont: titleFont,
            answerFont: answerFont,
          ),
        ],
      ),
    );
  }

  Widget choiceCard(Map<String, String> choice, double width, Size size) {
    final fontSize = clampDouble(size.width * 0.023, 8, 11);

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Text(choice['icon']!, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              choice['text']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.drag_indicator, size: 16, color: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget choicesBox(Size size) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        removeAnswer(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange[100]?.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MGA PAGPIPILIAN',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...choices.map((choice) {
                final isUsed = answers.containsValue(choice['id']);

                return Opacity(
                  opacity: isUsed ? 0.35 : 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Draggable<String>(
                      data: choice['id'],
                      maxSimultaneousDrags: isUsed ? 0 : 1,
                      feedback: Material(
                        color: Colors.transparent,
                        child: choiceCard(choice, size.width * 0.70, size),
                      ),
                      childWhenDragging: const SizedBox(height: 42),
                      child: choiceCard(choice, double.infinity, size),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget bottomArea(Size size) {
    final fontSize = clampDouble(size.width * 0.022, 8, 10);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50]?.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown, width: 1.5),
            ),
            child: Text(
              'Tandaan: Basahing mabuti ang bawat paliwanag upang mailagay ang tamang impormasyon.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: checkAnswers,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(size.width * 0.03, 10, 16),
              vertical: clampDouble(size.height * 0.018, 10, 15),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          child: const Text(
            'ISUMITE ➜',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          final iconSize = clampDouble(size.width * 0.10, 38, 52);
          final horizontalPadding = clampDouble(size.width * 0.035, 10, 20);
          final topSpace = clampDouble(size.height * 0.18, 85, 155);
          final contentWidth = clampDouble(size.width * 0.92, 300, 760);

          return SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(backgroundImage, fit: BoxFit.fill),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 10,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        child: Column(
                          children: [
                            header(iconSize),
                            SizedBox(height: topSpace),
                            tableBox(size),
                            const SizedBox(height: 12),
                            choicesBox(size),
                            const SizedBox(height: 10),
                            bottomArea(size),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
