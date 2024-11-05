import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/adminScreens/globalData.dart' as gD;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      SingleChildScrollView(child:
        Column(
              children: [
                const SizedBox(height: 8),
                const Text('Generelle Idee:',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Zu jedem Thema gibt es eine Tabelle mit Wörtern. Jeder Tabelle gehört ein Level an. Die Level repräsentieren nicht die Schwierigkeit,sondern eher die Reihenfolge, in der die Vokabeln gelernt werden sollen. Man beginnt also mit den Vokabeln auf Level 1. Ein Level besteht aus nur einer Tabelle. Eine Tabelle besteht dann aus den eigentlichen Vokabeln. Jede Vokabel muss natürlich eine deutsche und eine italienische Übersetzung haben. Es gibt auch noch ein zusätzliches Feld, wo due eintragen kannst, was du sinnvoll findest. Du kannst es aber auch leer lassen. Bitte achte darauf, dass jedes Level insgesamt 40 bis 90 Wörter besitzt. Wenn eine Vokabel oder eine gesamte Tabelle gelöscht ist, gibt es kein Backup, also nicht aus Versehen auf den Mülleimer klicken!',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(
                  color: Colors.black
                ),
                const Text('Vorhandene Vokabellisten',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: gD.vocabularyRepo!.vocabularyTables.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          leading: Text('Level ${gD.vocabularyRepo!.vocabularyTables[index].level.toString()}'),
                          title: Row(children: [
                            SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Text(gD.vocabularyRepo!.vocabularyTables[index].title, textAlign: TextAlign.left,)
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Text('${gD.vocabularyRepo!.vocabularyTables[index].vocabularies.length.toString()} Wörter', textAlign: TextAlign.left,)
                            ),
                          ], 
                          mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,),
                          trailing: Row(children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.border_color),
                              onPressed:() {
                                context.goNamed('screen_one', pathParameters: {'id': gD.vocabularyRepo!.vocabularyTables[index].db_id, 'tablename': gD.vocabularyRepo!.vocabularyTables[index].title});
                              },
                            ),
                          ], mainAxisSize: MainAxisSize.min,))
                      ); 
                    }
                  )
                  
                ),
              ],
            )
          )
    );
  }

}