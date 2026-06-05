import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LessonThreeDayOneActThree(),
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
  // Controllers to capture user inputs for rows 2 to 5
  final TextEditingController _row2Controller = TextEditingController();
  final TextEditingController _row3Controller = TextEditingController();
  final TextEditingController _row4Controller = TextEditingController();
  final TextEditingController _row5Controller = TextEditingController();

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
    return Scaffold(
      // The background color is removed from Scaffold to let the Container image show through
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // ⚠️ REPLACE THIS PATH WITH YOUR ACTUAL ASSET IMAGE PATH
              image: AssetImage('assets/lesson-three-day2-act5.png'),
              fit: BoxFit
                  .cover, // Ensures the image stretches beautifully to fill the screen
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section Space
                const SizedBox(height: 200),

                // Table Section
                Table(
                  // Adds a semi-transparent background to the table for text readability
                  backgroundColor: Colors.white70,
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(6),
                  },
                  border: TableBorder.all(color: Colors.black54, width: 1.5),
                  children: [
                    // Table Header Row
                    _buildTableHeaderRow(),

                    // Row 1: Static Example Text (Excluded from input)
                    _buildStaticRow(
                      '1. Lolo/Lola',
                      'Hal. Ang aking lolo ay isang magsasaka, nakatutulong ang aking lolo sa mga tao para magkaroon ng pagkain.',
                    ),

                    // Rows 2 to 5: Fillable input rows
                    _buildFillableRow('2. Nanay/Tatay', _row2Controller),
                    _buildFillableRow('3. Ako', _row3Controller),
                    _buildFillableRow('4. Mga Kapatid', _row4Controller),
                    _buildFillableRow('5. Bunsong Kapatid', _row5Controller),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Builder
  TableRow _buildTableHeaderRow() {
    return const TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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

  // Row 1: Read-only Example Row
  TableRow _buildStaticRow(String familyMember, String contribution) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              familyMember,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              contribution,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  // Rows 2-5: Dynamic Input Rows
  TableRow _buildFillableRow(
    String familyMember,
    TextEditingController controller,
  ) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              familyMember,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Center(
              child: TextField(
                controller: controller,
                maxLines: null, // Allows dynamic downward expansion
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Isulat dito...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none, // Keeps grid lines clean
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
