import 'package:flutter/material.dart';
import 'package:tigerstogether/helper/constant.dart';
import 'package:tigerstogether/helper/enum.dart';
import 'package:tigerstogether/helper/theme.dart';
import 'package:tigerstogether/model/feedModel.dart';
import 'package:tigerstogether/state/authState.dart';
import 'package:tigerstogether/state/feedState.dart';
import 'package:tigerstogether/widgets/customWidgets.dart';
import 'package:tigerstogether/widgets/newWidget/customLoader.dart';
import 'package:tigerstogether/widgets/newWidget/emptyList.dart';
import 'package:tigerstogether/widgets/tweet/tweet.dart';
import 'package:tigerstogether/widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
        },
        child: Icon(
          Icons.add,
          size: 25,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      backgroundColor: TwitterColor.mystic,
      body: Container(
        height: fullHeight(context),
        width: fullWidth(context),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: () async {
            /// refresh home page feed
            var feedState = Provider.of<FeedState>(context, listen: false);
            feedState.getDataFromDatabase();
            return Future.value(true);
          },
          child: _FeedPageBody(
            refreshIndicatorKey: refreshIndicatorKey,
            scaffoldKey: scaffoldKey,
          ),
        ),
      ),
    );
  }
}

class _FeedPageBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const _FeedPageBody({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);
  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        onPressed: () {
          /// Open up sidebaar drawer on user avatar tap
          scaffoldKey.currentState.openDrawer();
        },
        child:
            customImage(context, authState.userModel?.profilePic, height: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Consumer<FeedState>(
      builder: (context, state, child) {
        final List<FeedModel> list = state.getTweetList(authstate.userModel);
        return CustomScrollView(
          slivers: <Widget>[
            child,
            state.isBusy && list == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: fullHeight(context) - 135,
                      child: CustomScreenLoader(
                        height: double.infinity,
                        width: fullWidth(context),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : !state.isBusy && list == null
                    ? SliverToBoxAdapter(
                        child: EmptyList(
                          'No Tweet added yet',
                          subTitle:
                              'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          list.map(
                            (model) {
                              return Container(
                                color: Colors.white,
                                child: Tweet(
                                  model: model,
                                  trailing: TweetBottomSheet().tweetOptionIcon(
                                    context,
                                    model,
                                    TweetType.Tweet,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
          ],
        );
      },
      child: SliverAppBar(
        floating: true,
        elevation: 8,
        leading: _getUserAvatar(context),
        title: Text('YOUR FEED',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(0.0),
        ),
      ),
    );
  }
}
