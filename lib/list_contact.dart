import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sqlite/contact.dart';
import 'detail_page.dart';

class listContact extends StatefulWidget {
  const listContact({Key? key}) : super(key: key);

  @override
  State<listContact> createState() => _listContactState();
}

class _listContactState extends State<listContact> {

  List<Contact> _contacts = [];
  ContactProvider _databaseService = new ContactProvider();

  _loadContacts() async {
    var contacts = await _databaseService.getAllContact();
    setState(() {
      _contacts = contacts ;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>  _loadContacts());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des contacts",  style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: _contacts.length > 0 ? ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(_contacts[index].fullName),
                    subtitle: Text(_contacts[index].phone),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Afficher un dialogue de confirmation
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmation de suppression"),
                                content: Text("Voulez-vous vraiment supprimer ce contact ?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Annuler"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fermer le dialogue
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Confirmer"),
                                    onPressed: () async {
                                      // Supprimer le contact
                                      await _databaseService.delete(_contacts[index].id!);
                                      _contacts = await _databaseService.getAllContact();
                                      setState(() {
                                        Fluttertoast.showToast(
                                          msg: "Le contact a été supprimé avec succès",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      });
                                      Navigator.of(context).pop(); // Fermer le dialogue après la suppression
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("SUPPRIMER"),
                      ),

                      const SizedBox(width: 8,),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(contactId: _contacts[index].id!)));
                          },
                          child: Text("detaille")
                      ),
                      const SizedBox(width: 8,)
                    ],
                  )
                ],
              ),
            );
          }
      ) : Center(
        child: Text("Aucune donnée disponible", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),),

      ),
    );
  }
}
