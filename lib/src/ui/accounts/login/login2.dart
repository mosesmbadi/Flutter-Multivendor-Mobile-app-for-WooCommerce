import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/app_state_model.dart';
import './tabs3/forgot_password2.dart';
import './tabs3/login_tab2.dart';
import './tabs3/register_tab2.dart';

class Login2 extends StatefulWidget {

  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController emailController = new TextEditingController();
  AppStateModel appStateModel  = AppStateModel();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  return DefaultTabController(
                    length: 4,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        LoginTab(
                            context: context,
                            model: model,
                            tabController: _tabController),
                        RegisterTab(
                            context: context,
                            model: model,
                            tabController: _tabController),
                        ForgotPassword(
                            context: context,
                            model: model,
                            emailController: emailController,
                            tabController: _tabController),
                        ResetPassword(
                            context: context,
                            model: model,
                            emailController: emailController,
                            tabController: _tabController),
                      ],
                    ),
                  ); //widget(child: buildCartStack(context, localTheme, model));
                },
              ),
            ),
            ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  if (model.loginLoading) {
                    return Center(
                      child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Wrap(
                            children: [
                              new Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new CircularProgressIndicator(),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  new Text(appStateModel.blocks.localeText.pleaseWait),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}