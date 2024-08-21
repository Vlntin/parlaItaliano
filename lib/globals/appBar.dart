import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/handler/friendsHandler.dart';
import 'package:parla_italiano/widgets/personalizedTextformField.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget? leading;
  final Widget? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  final _newFriendFormKey = GlobalKey<FormState>();
  final _controllerUserName = TextEditingController();

  CustomAppBar({this.leading, this.title, this.backgroundColor, this.actions});

  @override
  Widget build(BuildContext context){
    return AppBar(
        //backgroundColor: Color.fromRGBO(249, 228, 183, 1),
        backgroundColor: Color.fromRGBO(248, 225, 174, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
        ),
        title:Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text(
                        'Parla Italiano',
                        textAlign: TextAlign.center,
                      )
                  ],
                ),
              ),
              /*3*/
              Icon(
                Icons.emoji_events,
              ),
              const SizedBox(width: 4),
              Text(userData.user!.level.toString(), style: TextStyle(fontSize: 16)),
              const SizedBox(width: 20),
              Icon(
                Icons.group,
              ),
              const SizedBox(width: 4),
              Text(userData.user!.friendsIDs.length.toString(), style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Füge neue Freunde hinzu!',
            onPressed: () {
              _dialogBuilderAddFriend(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_3),
            tooltip: 'Ändere dein Profil!',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout!',
            onPressed: () async {
              /**
              print('clicked');
              context.go('/signInScreen');
              print('go');
              //await UserHandler().logoutUser();
              print('finished');
              */
              print('clicked');
              if (await UserHandler().logoutUser()){
                print('go');
                context.go('/signInScreen');
              }
              
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
            child: Container(
              color: Colors.black,
              height: 2.0,
     ),
   )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> _dialogBuilderAddFriend(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Freund hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bitte gib einen Benutzernamen ein, den du zu deinen Freunden hinzufügen willst:',
              ),
              Form(
                key: _newFriendFormKey,
                child: PersonalizedTextformField(
                  controller: _controllerUserName, 
                  hintText: 'Benutzername',
                  newValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return  'Benutzername eingeben du Hund!';
                    }
                      return null;
                  },
                )
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Hinzufügen',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              onPressed: () async {
                if (_newFriendFormKey.currentState!.validate()) {
                  final username = _controllerUserName.text;
                  if ( username== userData.user!.username){
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Das bist du du Fisch'))
                    );
                  } else {
                    bool hasAlreadyThisFriend = await userData.user!.hasFriendWithUserName(username);
                    if (hasAlreadyThisFriend){
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Der Nutzer ist schon dein Freund'))
                      );
                    } else {
                      bool isSearchedUserNotExisting = await UserHandler().isUsernameNotUsed(username);
                      if (isSearchedUserNotExisting){
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Der Nutzer existiert nicht'))
                        );
                      } else {
                        bool hasAlreadySend = await userData.user!.hasAlreadySendAnRequest(username);
                        if (hasAlreadySend){
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Du hast ihm schonmal eine Anfrage geschickt'))
                          );
                        } else {
                          bool hasAlreadyReceived = await userData.user!.hasAlreadyReceivedAnRequest(username);
                          if (hasAlreadyReceived){
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Er hat dir schon eine Anfrage geschickt'))
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anfrage geschickt'))
                            );
                            FriendsHandler().sendFriendRequest(username);
                          }
                        }
                      }
                    }
                  }
                  _controllerUserName.clear();
                  Navigator.of(context).pop(false);
                } 
              }                    
            ),
          ],
        );
      },
    );
  } 
}




final _formKey = GlobalKey<FormState>();
final _controllerEmail = TextEditingController();