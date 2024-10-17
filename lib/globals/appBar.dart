import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/handler/friendsHandler.dart';
import 'package:parla_italiano/constants/colors.dart' as colors;

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
        backgroundColor: colors.appBarColor,
        automaticallyImplyLeading: false,
        title:Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person_rounded,
                    ),
                    const SizedBox(width: 20),
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
                )
              ),
              Expanded(
                flex: 2,
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
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
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
                        if (await UserHandler().logoutUser()){
                          context.go('/signInScreen');
                        }
                      },
                    ),
                  ],
                )
              )     
            ],
        ),
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
    dynamic _validationMsg;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 2.0)),
          backgroundColor: Colors.white,
          title: const Text('Freund hinzufügen', textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bitte gib einen Benutzernamen ein, den du zu deinen Freunden hinzufügen willst:',
              ),
              Form(
                key: _newFriendFormKey,
                child: TextFormField(
                  controller: _controllerUserName, 
                  onFieldSubmitted: (value) async {
                    _validationMsg = await checkUsername(value, context, _controllerUserName);
                    _newFriendFormKey.currentState!.validate();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Benutzername',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) => _validationMsg,
                )
              ),
            ]
          ),
          actions: <Widget>[
            Flexible(
                child: Center(
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      backgroundColor: colors.popUpButtonColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5), 
                      child:const Text(
                        'Hinzufügen',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _validationMsg = await checkUsername(_controllerUserName.text, context, _controllerUserName);
                      _newFriendFormKey.currentState!.validate();
                    } 
                      
                  )
                ),
                               
            ),
          ],
        );
      },
    );
  } 
}

Future<dynamic> checkUsername(String username, context, controllerUserName) async {
  if ( username== userData.user!.username){
    return 'Das bist du du Fisch';
  } else {
    if (await userData.user!.hasFriendWithUserName(username)){
      return 'Der Nutzer ist schon dein Freund';
    } else {
      if (await UserHandler().isUsernameNotUsed(username)){
        return 'Der Nutzer existiert nicht';
      } else {
        if (await userData.user!.hasAlreadySendAnRequest(username)){
          return 'Du hast ihm schonmal eine Anfrage geschickt';
        } else {
          if (await userData.user!.hasAlreadyReceivedAnRequest(username)){
            return 'Er hat dir schon eine Anfrage geschickt';
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Anfrage geschickt'))
            );
            FriendsHandler().sendFriendRequest(username);
            controllerUserName.clear();
            Navigator.of(context).pop(false);
            return null;
          }
        }
      }
    }
  }
}