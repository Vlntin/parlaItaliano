import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget? leading;
  final Widget? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

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
              Text(userData.level.toString(), style: TextStyle(fontSize: 16)),
              const SizedBox(width: 20),
              Icon(
                Icons.group,
              ),
              const SizedBox(width: 4),
              Text(userData.amount_of_friends.toString(), style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Füge neue Freunde hinzu!',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
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
}