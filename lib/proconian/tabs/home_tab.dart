import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';

import '../config.dart';
import '../model/post_entity.dart';
import '../pages/single_category.dart';
import '../widgets/featured_category_list.dart';
import '../widgets/posts_list.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'TIGERS TOGETHER',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            child: Image.asset('assets/images/icon-480.png'),
            padding: const EdgeInsets.all(8.0),
          ),
          /*
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.logout,
                    size: 26.0,
                  ),
                )),
            
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.more_vert),
                )),
                
          ],
          */
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                ListHeading(FEATURED_CATEGORY_TITLE, FEATURED_CATEGORY_ID),
                Container(
                  height: 250.0,
                  child: FeaturedCategoryList(),
                ),
                ListHeading('Latest', 0),
                Flexible(
                  fit: FlexFit.loose,
                  child: PostsList(),
                ),
              ],
            ),
          ),
        ));
  }
}

class ListHeading extends StatelessWidget {
  final String title;
  final int categoryId;

  ListHeading(this.title, this.categoryId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.display1,
          ),
          GestureDetector(
            onTap: () {
              PostCategory category = PostCategory(name: title, id: categoryId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCategory(category)));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).primaryColor),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Text('Show All'),
            ),
          )
        ],
      ),
    );
  }
}
