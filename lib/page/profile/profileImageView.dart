import 'package:flutter/material.dart';
import 'package:tigerstogether/helper/theme.dart';
import 'package:tigerstogether/helper/utility.dart';
import 'package:tigerstogether/page/profile/profilePage.dart';
import 'package:tigerstogether/state/authState.dart';
import 'package:tigerstogether/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Choice> choices = const <Choice>[
      const Choice(title: 'Share image link', icon: Icons.share),
      const Choice(title: 'Open in browser', icon: Icons.open_in_browser),
      const Choice(title: 'Save', icon: Icons.save),
    ];
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (d) {
              switch (d.title) {
                case "Share image link":
                  share(authstate.profileUserModel.profilePic);
                  break;
                case "Open in browser":
                  launchURL(authstate.profileUserModel.profilePic);
                  break;
                case "Save":
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: fullWidth(context),
          // height: fullWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: customAdvanceNetworkImage(
                  authstate.profileUserModel.profilePic),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
