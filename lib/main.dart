import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/firebase_user_provider.dart';
import 'package:project/splash_screen/splash_screen_widget.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'my_tasks/my_tasks_widget.dart';
import 'completed_tasks/completed_tasks_widget.dart';
import 'my_profile/my_profile_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<ProjectFirebaseUser> userStream;
  ProjectFirebaseUser initialUser;

  @override
  void initState() {
    super.initState();
    userStream = projectFirebaseUserStream()
      ..listen((user) => initialUser ?? setState(() => initialUser = user));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialUser == null
          ? Center(
              child: Builder(
                builder: (context) => Image.asset(
                  'assets/images/pixite-thumb.png',
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          : currentUser.loggedIn
              ? NavBarPage()
              : SplashScreenWidget(),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key key, this.initialPage}) : super(key: key);

  final String initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'myTasks';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'myTasks': MyTasksWidget(),
      'CompletedTasks': CompletedTasksWidget(),
      'MyProfile': MyProfileWidget(),
    };
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.playlist_add,
              color: Color(0xFF9E9E9E),
              size: 32,
            ),
            label: 'My Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.alarm_on,
              color: Color(0xFF9E9E9E),
              size: 32,
            ),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Color(0xFF9E9E9E),
              size: 32,
            ),
            activeIcon: Icon(
              Icons.person_sharp,
              color: FlutterFlowTheme.primaryColor,
              size: 32,
            ),
            label: 'Home',
          )
        ],
        backgroundColor: Color(0xFFA13636),
        currentIndex: tabs.keys.toList().indexOf(_currentPage),
        selectedItemColor: FlutterFlowTheme.grayBG,
        unselectedItemColor: FlutterFlowTheme.white,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        // Temporary fix for https://github.com/flutter/flutter/issues/84556
        selectedLabelStyle: const TextStyle(fontSize: 0.001),
        unselectedLabelStyle: const TextStyle(fontSize: 0.001),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
