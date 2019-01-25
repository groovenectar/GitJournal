import 'package:flutter/material.dart';
import 'package:journal/apis/git.dart';
import 'package:journal/apis/githost_factory.dart';

class GitHostSetupAutoConfigure extends StatefulWidget {
  final GitHostType gitHostType;
  final Function onDone;

  GitHostSetupAutoConfigure({
    @required this.gitHostType,
    @required this.onDone,
  });

  @override
  GitHostSetupAutoConfigureState createState() {
    return new GitHostSetupAutoConfigureState();
  }
}

class GitHostSetupAutoConfigureState extends State<GitHostSetupAutoConfigure> {
  GitHost gitHost;

  @override
  void initState() {
    super.initState();

    gitHost = createGitHost(widget.gitHostType);
    gitHost.init(() async {
      print("GitHub Initalized");

      var repo = await gitHost.createRepo("journal");
      var publicKey = await generateSSHKeys(comment: "GitJournal");
      await gitHost.addDeployKey(publicKey, repo.fullName);

      widget.onDone(repo.cloneUrl);
    });
    gitHost.launchOAuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Text(
        'Configuring ...',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.display1,
      ),
      SizedBox(height: 8.0),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          value: null,
        ),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}