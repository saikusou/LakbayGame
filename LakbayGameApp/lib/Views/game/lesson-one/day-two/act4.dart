import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

void main() {
  runApp(const EducationalGameApp());
}

class EducationalGameApp extends StatelessWidget {
  const EducationalGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonOneDayTwoActFour(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonOneDayTwoActFour extends StatefulWidget {
  final UserModel user;
  const LessonOneDayTwoActFour({super.key, required this.user});

  @override
  State<LessonOneDayTwoActFour> createState() => _LessonOneDayTwoActFourState();
}

class _LessonOneDayTwoActFourState extends State<LessonOneDayTwoActFour> {
  static const String backgroundImage = 'assets/lesson-two-day2-act4.png';

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

  void checkAnswers() {
    int total = 0;

    answers.forEach((key, value) {
      if (value == correctAnswers[key]) total++;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tapos na!'),
        content: Text('Score mo: $total / 3'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget header(double iconSize) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Lesson1Screen(user: widget.user),
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
                size: iconSize * 0.6,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget tableHeaderText(String text, double fontSize) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget tableHeader(double fontSize) {
    return Container(
      height: 34,
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
        border: Border(top: BorderSide(color: Colors.blue.shade900, width: 1)),
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
                setState(() {
                  answers[title] = details.data;
                });
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
                    border: Border.all(color: dropColor, width: 1.6),
                  ),
                  child: Text(
                    current == null
                        ? 'I-drag ang sagot dito'
                        : getChoiceText(current),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: answerFont,
                      color: current == null ? Colors.grey[600] : Colors.black,
                      fontWeight: current == null
                          ? FontWeight.normal
                          : FontWeight.bold,
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
    final rowHeight = clampDouble(size.height * 0.105, 70, 92);
    final iconSize = clampDouble(size.width * 0.06, 18, 26);
    final titleFont = clampDouble(size.width * 0.025, 8, 11);
    final answerFont = clampDouble(size.width * 0.023, 7, 10);

    return Container(
      margin: EdgeInsets.only(top: clampDouble(size.height * 0.26, 150, 245)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          tableHeader(titleFont),
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
    final fontSize = clampDouble(size.width * 0.025, 8, 11);

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
          Text(choice['icon']!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              choice['text']!,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.drag_indicator, size: 17, color: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget choicesBox(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
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
                    child: choiceCard(choice, size.width * 0.72, size),
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
  }

  Widget bottomArea(Size size) {
    final fontSize = clampDouble(size.width * 0.024, 8, 10);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
            child: const Text(
              'ISUMITE ➜',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = clampDouble(size.width * 0.11, 40, 50);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: clampDouble(size.width * 0.035, 10, 18),
                  ),
                  child: Column(
                    children: [
                      header(iconSize),
                      tableBox(size),
                      choicesBox(size),
                      bottomArea(size),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
