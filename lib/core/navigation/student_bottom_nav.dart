import 'package:flutter/material.dart';

import '../../screens/siswa/siswa_dashboard.dart';
import '../../screens/siswa/materi_page.dart';
import '../../screens/siswa/video_page.dart';
import '../../screens/siswa/profile_page.dart';

class StudentBottomNav extends StatefulWidget {
  const StudentBottomNav({super.key});

  @override
  State<StudentBottomNav> createState() =>
      _StudentBottomNavState();
}

class _StudentBottomNavState
    extends State<StudentBottomNav> {

  int currentIndex = 0;

  final pages = const [

  SiswaDashboard(),

  MateriPage(),

  VideoPage(),

  ProfilePage(),

];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(

        index: currentIndex,

        children: pages,

      ),

      bottomNavigationBar: NavigationBar(

        selectedIndex: currentIndex,

        height: 75,

        backgroundColor: Colors.white,

        indicatorColor:
            const Color(0xff2563EB)
                .withOpacity(.15),

        elevation: 0,

        onDestinationSelected: (index) {

          setState(() {

            currentIndex = index;

          });
        },

        destinations: const [

          NavigationDestination(

            icon: Icon(
              Icons.home_outlined,
            ),

            selectedIcon: Icon(
              Icons.home_rounded,
            ),

            label: "Home",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.menu_book_outlined,
            ),

            selectedIcon: Icon(
              Icons.menu_book_rounded,
            ),

            label: "Materi",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.play_circle_outline,
            ),

            selectedIcon: Icon(
              Icons.play_circle_fill,
            ),

            label: "Video",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.person_outline,
            ),

            selectedIcon: Icon(
              Icons.person,
            ),

            label: "Profil",

          ),
        ],
      ),
    );
  }
}