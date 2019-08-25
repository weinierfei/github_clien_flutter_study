import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/Funs.dart';
import 'package:github_client_app/common/GitApi.dart';
import 'package:github_client_app/i10n/GmLocalizations.dart';
import 'package:github_client_app/models/index.dart';
import 'package:github_client_app/states/ProfileChangeNotifier.dart';
import 'package:github_client_app/widgets/RepoItem.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeRouteState();
  }
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).home),
      ),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      return Center(
        child: RaisedButton(
          child: Text(GmLocalizations.of(context).login),
          onPressed: () => Navigator.of(context).pushNamed('login'),
        ),
      );
    } else {
      return InfiniteListView<Repo>(
        onRetrieveData: (int page, List<Repo> items, bool refresh) async {
          var data = await GitApi(context).getRepos(
            refresh: refresh,
            queryParameters: {
              'page': page,
              'page_size': 20,
            },
          );
          items.addAll(data);
          return data.length > 0 && data.length % 20 == 0;
        },
        itemBuilder: (List list, int index, BuildContext context) {
          return RepoItem(list[index]);
        },
      );
    }
  }
}

class MyDrawer extends StatelessWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: _buildMenus(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel model, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ClipOval(
                    child: model.isLogin
                        ? gmAvatar(model.user.avatar_url, width: 80)
                        : Image.asset(
                            "imgs/avatar.png",
                            width: 80,
                          ),
                  ),
                ),
                Text(
                  model.isLogin
                      ? model.user.login
                      : GmLocalizations.of(context).login,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            if (!model.isLogin) {
              Navigator.of(context).pushNamed("login");
            }
          },
        );
      },
    );
  }

  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel model, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            if (model.isLogin)
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text(gm.logout),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: Text(gm.logoutTip),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(gm.cancel),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text(gm.yes),
                              onPressed: () {
                                model.user = null;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
          ],
        );
      },
    );
  }
}
