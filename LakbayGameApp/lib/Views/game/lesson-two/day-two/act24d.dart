import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson2.dart';
// Add this import - adjust the path based on your project structure

class LessonTwoDayTwoActTwoE extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwoE({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwoE> createState() => _LessonTwoDayTwoActTwoEState();
}

class _LessonTwoDayTwoActTwoEState extends State<LessonTwoDayTwoActTwoE> {
  final List<Map<String, dynamic>> questions = [
    {
      "id": 1,
      "text":
          "Angular na distansya pasilangan o pakanluran mula sa Prime Meridian.",
      "answer": "longitude",
    },
    {
      "id": 2,
      "text": "Angular na distansya pahilaga o patimog mula sa ekwador.",
      "answer": "latitude",
    },
    {
      "id": 3,
      "text": "Tinatawag rin itong Greenwich Meridian.",
      "answer": "prime",
    },
    {"id": 4, "text": "Pabilog na representasyon ng mundo.", "answer": "globe"},
    {
      "id": 5,
      "text": "Nabubuong espasyo mula sa pagtatagpo ng latitud at longhitud.",
      "answer": "map",
    },
  ];

  final List<Map<String, dynamic>> choices = [
    {"id": "prime", "image": "assets/prime_meridian.jpg"},
    {"id": "longitude", "image": "assets/longitude.jpg"},
    {"id": "latitude", "image": "assets/latitude.jpg"},
    {"id": "map", "image": "assets/map_grid.jpg"},
    {"id": "globe", "image": "assets/globe.webp"},
  ];

  Map<int, String> placed = {};

  bool isFinished() {
    return placed.length == questions.length;
  }

  // Responsive helper methods
  double getImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth < 600) {
      return 70; // Mobile
    } else if (screenWidth < 900) {
      return 85; // Tablet
    } else {
      return 100; // Desktop
    }
  }

  double getDropHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 80;
    } else {
      return 100;
    }
  }

  double getFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 12;
    } else if (screenWidth < 600) {
      return 14;
    } else if (screenWidth < 900) {
      return 16;
    } else {
      return 18;
    }
  }

  double getPaddingSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 8;
    } else if (screenWidth < 600) {
      return 12;
    } else {
      return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    final imageSize = getImageSize(context);
    final dropHeight = getDropHeight(context);
    final fontSize = getFontSize(context);
    final padding = getPaddingSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gawain 2",
          style: TextStyle(fontSize: isSmallScreen ? 18 : 22),
        ),
        toolbarHeight: isSmallScreen ? 56 : 64,
        // Add a back button to go to Lesson2Screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to Lesson2Screen with user data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Lesson2Screen(user: widget.user),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: isSmallScreen ? 14 : 18,
                          child: Text(
                            "${question["id"]}",
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question["text"],
                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 10),
                              DragTarget<String>(
                                onAcceptWithDetails: (details) {
                                  if (details.data == question["answer"]) {
                                    setState(() {
                                      placed[index] = details.data;
                                    });

                                    if (isFinished()) {
                                      Future.delayed(
                                        const Duration(milliseconds: 300),
                                        () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Congratulations! 🎉",
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 18
                                                        : 22,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Natapos mo ang gawain!",
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 14
                                                        : 16,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      // Close the dialog first
                                                      Navigator.pop(context);
                                                      // Then navigate to Lesson2Screen with user data
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Lesson2Screen(
                                                                user:
                                                                    widget.user,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      "NEXT",
                                                      style: TextStyle(
                                                        fontSize: isSmallScreen
                                                            ? 14
                                                            : 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Maling Sagot!",
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, candidate, rejected) {
                                  if (placed.containsKey(index)) {
                                    final image = choices.firstWhere(
                                      (e) => e["id"] == placed[index],
                                    );

                                    return Container(
                                      height: dropHeight,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: isSmallScreen ? 2 : 3,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(
                                        image["image"],
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  }

                                  return Container(
                                    height: dropHeight,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: isSmallScreen ? 1.5 : 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Drag Image Here",
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              thickness: isSmallScreen ? 1 : 1.5,
              height: isSmallScreen ? 16 : 24,
            ),
            SizedBox(
              height: isSmallScreen ? 100 : 120,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = isSmallScreen ? 70 : 90;
                  final totalWidth = choices.length * (itemWidth + 16);

                  if (totalWidth <= constraints.maxWidth) {
                    // Center the items if they fit
                    return Center(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: getChoiceWidgets(imageSize, isSmallScreen),
                      ),
                    );
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: getChoiceWidgets(imageSize, isSmallScreen),
                  );
                },
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 16),
          ],
        ),
      ),
    );
  }

  List<Widget> getChoiceWidgets(double imageSize, bool isSmallScreen) {
    return choices
        .where((choice) {
          return !placed.containsValue(choice["id"]);
        })
        .map((choice) {
          return Padding(
            padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
            child: Draggable<String>(
              data: choice["id"],
              feedback: Material(
                child: Image.asset(choice["image"], width: imageSize),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Image.asset(choice["image"], width: imageSize),
              ),
              child: Image.asset(choice["image"], width: imageSize),
            ),
          );
        })
        .toList();
  }
}
