import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/leaderboard.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LeaderboardScreen extends StatefulWidget {
  final UserModel user;

  const LeaderboardScreen({super.key, required this.user});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  List<LeaderboardModel> leaders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<LeaderboardModel> get filteredLeaders {
    final sorted = [...leaders]
      ..sort((a, b) => (b.totalPoints).compareTo(a.totalPoints));

    if (searchText.trim().isEmpty) return sorted;

    return sorted.where((player) {
      final name = player.userName.toLowerCase();
      return name.contains(searchText.toLowerCase());
    }).toList();
  }

  Future<void> loadLeaderboard() async {
    try {
      final fetchedLeaders = await ApiService.getUsersLeaderboard();
      setState(() {
        leaders = fetchedLeaders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error, e.g., show a snackbar or dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displayedLeaders = filteredLeaders;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3D6),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC928), Color(0xFFFFE7A3), Color(0xFFFFF3D6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(clampDouble(size.width * 0.045, 14, 22)),
            child: Column(
              children: [
                Row(
                  children: [
                    _homeButton(size),
                    const Spacer(),
                    Text(
                      "Leaderboard",
                      style: TextStyle(
                        fontSize: clampDouble(size.width * 0.065, 24, 34),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF6B3E16),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: clampDouble(size.width * 0.12, 42, 52)),
                  ],
                ),

                SizedBox(height: clampDouble(size.height * 0.025, 14, 24)),

                _topBanner(size),

                SizedBox(height: clampDouble(size.height * 0.018, 12, 18)),

                _searchBox(size),

                SizedBox(height: clampDouble(size.height * 0.018, 12, 18)),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(
                      clampDouble(size.width * 0.03, 10, 16),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF7A4A1D),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : displayedLeaders.isEmpty
                        ? Center(
                            child: Text(
                              "No student found",
                              style: TextStyle(
                                fontSize: clampDouble(
                                  size.width * 0.045,
                                  16,
                                  20,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayedLeaders.length,
                            itemBuilder: (context, index) {
                              final player = displayedLeaders[index];

                              return _leaderCard(
                                size: size,
                                rank: index + 1,
                                name: player.userName,
                                points: player.totalPoints,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeButton(Size size) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: clampDouble(size.width * 0.12, 42, 52),
        height: clampDouble(size.width * 0.12, 42, 52),
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
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
          size: clampDouble(size.width * 0.065, 24, 30),
        ),
      ),
    );
  }

  Widget _topBanner(Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: clampDouble(size.height * 0.018, 12, 20),
        horizontal: clampDouble(size.width * 0.04, 14, 20),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF8BC34A),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: clampDouble(size.width * 0.18, 62, 82),
            height: clampDouble(size.width * 0.18, 62, 82),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: clampDouble(size.width * 0.1, 36, 50),
            ),
          ),
          SizedBox(width: clampDouble(size.width * 0.04, 12, 18)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Players",
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.055, 21, 28),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Search and view student rankings",
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.035, 13, 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox(Size size) {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search student name...",
        prefixIcon: const Icon(Icons.search, color: Colors.brown),
        suffixIcon: searchText.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.brown),
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchText = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: clampDouble(size.height * 0.018, 12, 18),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.orange, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.green, width: 3),
        ),
      ),
      style: TextStyle(
        fontSize: clampDouble(size.width * 0.04, 15, 18),
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }

  Widget _leaderCard({
    required Size size,
    required int rank,
    required String name,
    required int points,
  }) {
    Color rankColor;
    IconData rankIcon;

    if (rank == 1) {
      rankColor = Colors.amber;
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey;
      rankIcon = Icons.workspace_premium;
    } else if (rank == 3) {
      rankColor = Colors.brown;
      rankIcon = Icons.military_tech;
    } else {
      rankColor = Colors.green;
      rankIcon = Icons.person;
    }

    final bool isCurrentUser = name == widget.user.userName;

    return Container(
      margin: EdgeInsets.only(bottom: clampDouble(size.width * 0.025, 8, 12)),
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.035, 12, 18),
        vertical: clampDouble(size.width * 0.03, 10, 14),
      ),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFFFFF0B3) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentUser ? Colors.green : Colors.orange,
          width: isCurrentUser ? 3 : 2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: clampDouble(size.width * 0.058, 21, 29),
            backgroundColor: rankColor,
            child: rank <= 3
                ? Icon(
                    rankIcon,
                    color: Colors.white,
                    size: clampDouble(size.width * 0.052, 19, 25),
                  )
                : Text(
                    "$rank",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: clampDouble(size.width * 0.038, 14, 17),
                    ),
                  ),
          ),
          SizedBox(width: clampDouble(size.width * 0.035, 10, 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.042, 15, 18),
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
                if (isCurrentUser)
                  Text(
                    "You",
                    style: TextStyle(
                      fontSize: clampDouble(size.width * 0.032, 12, 14),
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(size.width * 0.025, 8, 12),
              vertical: clampDouble(size.width * 0.015, 5, 8),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.amber,
                  size: clampDouble(size.width * 0.045, 17, 22),
                ),
                const SizedBox(width: 5),
                Text(
                  "$points",
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.04, 15, 18),
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
