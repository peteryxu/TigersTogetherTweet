import 'package:flutter/material.dart';
import 'package:tigerstogether/helper/constant.dart';
import 'package:tigerstogether/page/common/usersListPage.dart';
import 'package:tigerstogether/state/authState.dart';
import 'package:provider/provider.dart';

class FollowingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return UsersListPage(
        pageTitle: 'Following',
        userIdsList: state.profileUserModel.followingList,
        appBarIcon: AppIcon.follow,
        emptyScreenText:
            '${state?.profileUserModel?.userName ?? state.userModel.userName} isn\'t follow anyone',
        emptyScreenSubTileText: 'When they do they\'ll be listed here.');
  }
}
