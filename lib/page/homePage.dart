import 'package:flutter/material.dart';
import 'package:tigerstogether/helper/enum.dart';
import 'package:tigerstogether/helper/utility.dart';
import 'package:tigerstogether/page/feed/feedPage.dart';
import 'package:tigerstogether/page/message/chatListPage.dart';
import 'package:tigerstogether/state/appState.dart';
import 'package:tigerstogether/state/authState.dart';
import 'package:tigerstogether/state/chats/chatState.dart';
import 'package:tigerstogether/state/feedState.dart';
import 'package:tigerstogether/state/notificationState.dart';
import 'package:tigerstogether/state/searchState.dart';
import 'package:tigerstogether/widgets/bottomMenuBar/bottomMenuBar.dart';
import 'package:provider/provider.dart';
import 'common/sidebar.dart';
import 'notification/notificationPage.dart';
import 'search/SearchPage.dart';
import '../proconian/tabs/home_tab.dart';
import './CovidPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initTweets();
      initProfile();
      initSearch();
      initNotificaiton();
      initChat();
    });

    super.initState();
  }

  void initTweets() {
    var state = Provider.of<FeedState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initNotificaiton() {
    var state = Provider.of<NotificationState>(context, listen: false);
    var authstate = Provider.of<AuthState>(context, listen: false);
    state.databaseInit(authstate.userId);
    state.initfirebaseService();
  }

  void initChat() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.databaseInit(state.userId, state.userId);

    /// It will update fcm token in database
    /// fcm token is required to send firebase notification
    state.updateFCMToken();

    /// It get fcm server key
    /// Server key is required to configure firebase notification
    /// Without fcm server notification can not be sent
    chatState.getFCMServerKey();
  }

  /// On app launch it checks if app is launch by tapping on notification from notification tray
  /// If yes, it checks for  which type of notification is recieve
  /// If notification type is `NotificationType.Message` then chat screen will open
  /// If notification type is `NotificationType.Mention` then user profile will open who taged you in a tweet
  ///
  void _checkNotification() {
    final authstate = Provider.of<AuthState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<NotificationState>(context);

      /// Check if user recieve chat notification from firebase
      /// Redirect to chat screen
      /// `notificationSenderId` is a user id who sends you a message
      /// `notificationReciverId` is a your user id.
      if (state.notificationType == NotificationType.Message &&
          state.notificationReciverId == authstate.userModel.userId) {
        state.setNotificationType = null;
        state.getuserDetail(state.notificationSenderId).then((user) {
          cprint("Opening user chat screen");
          final chatState = Provider.of<ChatState>(context, listen: false);
          chatState.setChatUser = user;
          Navigator.pushNamed(context, '/ChatScreenPage');
        });
      }

      /// Checks for user tag tweet notification
      /// If you are mentioned in tweet then it redirect to user profile who mentioed you in a tweet
      /// You can check that tweet on his profile timeline
      /// `notificationSenderId` is user id who tagged you in a tweet
      else if (state.notificationType == NotificationType.Mention &&
          state.notificationReciverId == authstate.userModel.userId) {
        state.setNotificationType = null;
        Navigator.of(context)
            .pushNamed('/ProfilePage/' + state.notificationSenderId);
      }
    });
  }

  Widget _body() {
    _checkNotification();
    return Container(
      child: _getPage(Provider.of<AppState>(context).pageIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      //for Proconian news
      case 0:
        return HomeTab(
          scaffoldKey: _scaffoldKey,
        );
        break;

      // for followed people and tweets
      case 1:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;

      // for direct messages
      case 2:
        return ChatListPage(scaffoldKey: _scaffoldKey);
        break;

      // for search peoples
      case 3:
        return SearchPage(scaffoldKey: _scaffoldKey);

        break;

      //for COVID
      case 4:
        return CovidPage(
          scaffoldKey: _scaffoldKey,
        );
        break;

      /*case 5:
        return NotificationPage(scaffoldKey: _scaffoldKey);
        break;  */

      default:
        return HomeTab(scaffoldKey: _scaffoldKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      drawer: SidebarMenu(),
      body: _body(),
    );
  }
}
