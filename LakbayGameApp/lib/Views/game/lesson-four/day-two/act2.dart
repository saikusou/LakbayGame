import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Views/lesson4.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonFourDayTwoActTwo extends StatefulWidget {
  final UserModel user;

  const LessonFourDayTwoActTwo({super.key, required this.user});

  @override
  State<LessonFourDayTwoActTwo> createState() => _LessonFourDayTwoActTwoState();
}

class _LessonFourDayTwoActTwoState extends State<LessonFourDayTwoActTwo> {
  final List<Map<String, String>> correctAnswers = [
    {
      'image': 'assets/datu.png',
      'role': 'Datu',
      'meaning': 'Pinuno ng\nBarangay',
    },
    {
      'image': 'assets/maharlika.png',
      'role': 'Maharlika',
      'meaning': 'Mandirigma at\ntagapagtanggol',
    },
    {
      'image': 'assets/timawa.png',
      'role': 'Timawa',
      'meaning': 'Malayang\nmamamayan',
    },
    {
      'image': 'assets/alipin.png',
      'role': 'Alipin',
      'meaning': 'Nagsisilbi sa\nnakatataas',
    },
  ];

  late List<String?> placedImages;
  late List<String?> placedRoles;
  late List<String> availableImages;
  late List<String> availableRoles;

  bool submitted = false;

  @override
  void initState() {
    super.initState();
    resetLists();
  }

  void resetLists() {
    placedImages = List.filled(4, null);
    placedRoles = List.filled(4, null);

    availableImages = correctAnswers.map((e) => e['image']!).toList()
      ..shuffle();

    availableRoles = correctAnswers.map((e) => e['role']!).toList()..shuffle();
  }

  void resetGame() {
    setState(() {
      resetLists();
      submitted = false;
    });
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  bool get allFilled =>
      placedImages.every((e) => e != null) &&
      placedRoles.every((e) => e != null);

  void checkAnswers() {
    int score = 0;

    for (int i = 0; i < correctAnswers.length; i++) {
      if (placedImages[i] == correctAnswers[i]['image']) {
        score += 5;
      }

      if (placedRoles[i] == correctAnswers[i]['role']) {
        score += 5;
      }
    }

    setState(() => submitted = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Resulta',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          score == 40
              ? 'Mahusay! Tama lahat ang sagot mo.\n\nIskor: $score / 40'
              : 'Natapos mo ang gawain.\n\nIskor: $score / 40',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Ulitin'),
          ),
        ],
      ),
    );
  }

  Color imageBorderColor(int index) {
    if (!submitted) return Colors.green.shade800;

    return placedImages[index] == correctAnswers[index]['image']
        ? Colors.green
        : Colors.red;
  }

  Color roleBorderColor(int index) {
    if (!submitted) return Colors.green.shade800;

    return placedRoles[index] == correctAnswers[index]['role']
        ? Colors.green
        : Colors.red;
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget headerBox(String title, double width, double fontSize) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget dropImageBox(int index, double width, double height, double fontSize) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        return !submitted && details.data.contains('assets/');
      },
      onAcceptWithDetails: (details) {
        setState(() {
          if (placedImages[index] != null) {
            availableImages.add(placedImages[index]!);
          }

          placedImages[index] = details.data;
          availableImages.remove(details.data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (placedImages[index] != null && !submitted) {
              setState(() {
                availableImages.add(placedImages[index]!);
                placedImages[index] = null;
              });
            }
          },
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.94),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: imageBorderColor(index), width: 1.7),
            ),
            child: placedImages[index] == null
                ? Center(
                    child: Text(
                      'Ilagay\nang larawan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  )
                : Image.asset(placedImages[index]!, fit: BoxFit.contain),
          ),
        );
      },
    );
  }

  Widget dropRoleBox(int index, double width, double height, double fontSize) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        return !submitted && !details.data.contains('assets/');
      },
      onAcceptWithDetails: (details) {
        setState(() {
          if (placedRoles[index] != null) {
            availableRoles.add(placedRoles[index]!);
          }

          placedRoles[index] = details.data;
          availableRoles.remove(details.data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (placedRoles[index] != null && !submitted) {
              setState(() {
                availableRoles.add(placedRoles[index]!);
                placedRoles[index] = null;
              });
            }
          },
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.94),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: roleBorderColor(index), width: 1.7),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  placedRoles[index] ?? 'Ilagay\nang salita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget meaningBox(String text, double width, double height, double fontSize) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade800, width: 1.7),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget draggableImage(String image, double size) {
    final child = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: submitted ? Colors.grey.shade300 : Colors.white,
        border: Border.all(
          color: submitted ? Colors.grey : Colors.green.shade800,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Image.asset(image, width: size, height: size, fit: BoxFit.contain),
    );

    if (submitted) return child;

    return Draggable<String>(
      data: image,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          image,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: child),
      child: child,
    );
  }

  Widget roleChip(String role, double width, double fontSize) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade800),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        role,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }

  Widget draggableRole(String role, double width, double fontSize) {
    if (submitted) {
      return Opacity(opacity: 0.5, child: roleChip(role, width, fontSize));
    }

    return Draggable<String>(
      data: role,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: roleChip(role, width, fontSize),
      ),
      child: roleChip(role, width, fontSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool smallPhone = size.width < 380;
    final bool verySmallPhone = size.width < 340;

    final tableWidth = clampDouble(size.width * 0.985, 300, 620);

    final gap = verySmallPhone
        ? 2.5
        : smallPhone
        ? 4.0
        : 6.0;

    final columnWidth = (tableWidth - (gap * 2)) / 3;

    final rowHeight = clampDouble(
      size.height * (smallPhone ? 0.068 : 0.076),
      48,
      72,
    );

    final imageSize = clampDouble(
      size.width * (smallPhone ? 0.105 : 0.12),
      34,
      58,
    );

    final roleWidth = clampDouble(
      size.width * (smallPhone ? 0.20 : 0.22),
      62,
      110,
    );

    final titleSize1 = clampDouble(size.width * 0.068, 20, 31);
    final titleSize2 = clampDouble(size.width * 0.056, 17, 27);

    final normalFont = clampDouble(size.width * 0.028, 9, 12);
    final headerFont = clampDouble(size.width * 0.028, 9, 12);

    final iconSize = clampDouble(size.width * 0.12, 42, 58);
    final sidePadding = clampDouble(size.width * 0.03, 8, 18);
    final iconTop = clampDouble(size.height * 0.01, 6, 14);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7ED957), Color(0xFFFFF2C2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: smallPhone ? 3 : 6,
                      right: smallPhone ? 3 : 6,
                      bottom: MediaQuery.of(context).padding.bottom + 18,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: smallPhone ? 3 : 6),

                          Text(
                            'GAWAIN 2:',
                            style: TextStyle(
                              fontSize: titleSize1,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            'TUKUYIN AT ITUGMA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize2,
                              fontWeight: FontWeight.w900,
                              color: Colors.yellow,
                              shadows: const [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: tableWidth,
                            margin: EdgeInsets.only(
                              top: smallPhone ? 4 : 6,
                              bottom: smallPhone ? 5 : 7,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: smallPhone ? 5 : 7,
                              vertical: smallPhone ? 5 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.brown,
                                width: 1.7,
                              ),
                            ),
                            child: Text.rich(
                              const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Panuto: ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Pagdugtungin ang tamang larawan, salita, at kahulugan. Ilagay ang mga larawan at salita sa loob ng kahon.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: normalFont),
                            ),
                          ),

                          SizedBox(
                            width: tableWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                headerBox('LARAWAN', columnWidth, headerFont),
                                headerBox(
                                  'URI NG TAO',
                                  columnWidth,
                                  headerFont,
                                ),
                                headerBox('KAHULUGAN', columnWidth, headerFont),
                              ],
                            ),
                          ),

                          const SizedBox(height: 4),

                          for (int i = 0; i < correctAnswers.length; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: gap),
                              child: SizedBox(
                                width: tableWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    dropImageBox(
                                      i,
                                      columnWidth,
                                      rowHeight,
                                      normalFont,
                                    ),
                                    dropRoleBox(
                                      i,
                                      columnWidth,
                                      rowHeight,
                                      normalFont,
                                    ),
                                    meaningBox(
                                      correctAnswers[i]['meaning']!,
                                      columnWidth,
                                      rowHeight,
                                      normalFont,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          SizedBox(height: smallPhone ? 5 : 8),

                          Container(
                            width: tableWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: smallPhone ? 5 : 7,
                              vertical: smallPhone ? 5 : 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.brown,
                                width: 1.7,
                              ),
                            ),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: smallPhone ? 4 : 7,
                                  runSpacing: smallPhone ? 4 : 7,
                                  alignment: WrapAlignment.center,
                                  children: availableImages
                                      .map(
                                        (img) => draggableImage(img, imageSize),
                                      )
                                      .toList(),
                                ),

                                SizedBox(height: smallPhone ? 5 : 7),

                                Wrap(
                                  spacing: smallPhone ? 4 : 6,
                                  runSpacing: smallPhone ? 4 : 6,
                                  alignment: WrapAlignment.center,
                                  children: availableRoles
                                      .map(
                                        (role) => draggableRole(
                                          role,
                                          roleWidth,
                                          normalFont,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: smallPhone ? 7 : 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: allFilled && !submitted
                                    ? checkAnswers
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade800,
                                  disabledBackgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: smallPhone ? 16 : 26,
                                    vertical: smallPhone ? 8 : 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: Text(
                                  'ISUMITE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: clampDouble(
                                      size.width * 0.037,
                                      13,
                                      15,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              ElevatedButton(
                                onPressed: resetGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: smallPhone ? 15 : 24,
                                    vertical: smallPhone ? 8 : 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: Text(
                                  'ULITIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: clampDouble(
                                      size.width * 0.037,
                                      13,
                                      15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            top: iconTop,
            right: sidePadding,
            child: SafeArea(
              child: circleButton(
                icon: Icons.home,
                color: Colors.orange,
                size: iconSize,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson4Screen(user: widget.user),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
