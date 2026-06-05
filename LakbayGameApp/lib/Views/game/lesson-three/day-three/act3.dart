import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonThreeDayOneActThree(),
    );
  }
}

class LessonThreeDayOneActThree extends StatefulWidget {
  const LessonThreeDayOneActThree({super.key});

  @override
  State<LessonThreeDayOneActThree> createState() =>
      _LessonThreeDayOneActThreeState();
}

class _LessonThreeDayOneActThreeState extends State<LessonThreeDayOneActThree> {
  final TextEditingController _row2Controller = TextEditingController();
  final TextEditingController _row3Controller = TextEditingController();
  final TextEditingController _row4Controller = TextEditingController();
  final TextEditingController _row5Controller = TextEditingController();

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    _row2Controller.dispose();
    _row3Controller.dispose();
    _row4Controller.dispose();
    _row5Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double topSpace = clampDouble(size.height * 0.28, 160, 230);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// FULL RESPONSIVE BACKGROUND
            Positioned.fill(
              child: Image.asset(
                scale: 1,
                'assets/lesson-three-day3-act3.png',
                fit: BoxFit.fill,
              ),
            ),

            /// CONTENT
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: clampDouble(size.width * 0.04, 12, 24),
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    SizedBox(height: topSpace),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(6),
                        },
                        border: TableBorder.all(
                          color: Colors.black54,
                          width: 1.5,
                        ),
                        children: [
                          _buildTableHeaderRow(),
                          _buildStaticRow(
                            '1. Lolo/Lola',
                            'Hal. Ang aking lolo ay isang magsasaka, nakatutulong ang aking lolo sa mga tao para magkaroon ng pagkain.',
                          ),
                          _buildFillableRow('2. Nanay/Tatay', _row2Controller),
                          _buildFillableRow('3. Ako', _row3Controller),
                          _buildFillableRow('4. Mga Kapatid', _row4Controller),
                          _buildFillableRow(
                            '5. Bunsong Kapatid',
                            _row5Controller,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Lesson3Screen()),
                  );
                },
                child: Container(
                  width: clampDouble(size.width * 0.14, 50, 70),
                  height: clampDouble(size.width * 0.14, 50, 70),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: clampDouble(size.width * 0.08, 28, 40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    return const TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'ANG AKING PAMILYA',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'AMBAG SA PAMAYANAN',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildStaticRow(String familyMember, String contribution) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              familyMember,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              contribution,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildFillableRow(
    String familyMember,
    TextEditingController controller,
  ) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              familyMember,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Isulat dito...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
