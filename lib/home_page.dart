import 'package:contact_project/sqlite/contact.dart';
import 'package:flutter/material.dart';
import 'list_contact.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sqlite/contact.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final formKey =  GlobalKey<FormState>();

  final TextEditingController contactController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  final contactProvider = new ContactProvider();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Contact app", style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fullnameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Nom & Prénom",
                      hintText: "Entrez votre nom & prénom"
                  ),
                  validator: (String? value) {
                    return (value == null || value == "") ? "Ce champ est obligatoire" : null;
                  },

                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: "Téléphone",
                      hintText: "Entrez votre numéro de téléphone"
                  ),
                  validator: ( value) {
                    return (value == null || value.isEmpty ) ? "Ce champ est obligatoire" : null;
                  },

                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                  if(formKey.currentState!.validate()){
                    Contact contact = Contact();
                    contact.id = null;
                    contact.fullName = fullnameController.text;
                    contact.phone = contactController.text;
                    contactProvider.insert(contact);
                    setState(() {
                      Fluttertoast.showToast(
                          msg: "Le contact a été enregistré avec succès",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM
                      );
                    });
                  }
              },
              child: Text("Enregistrer", style: TextStyle(color: Colors.green),)
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const listContact())
                );
              }, child: Text("Lister les contacts", style: TextStyle(color: Colors.green),)
          ),
        ],
      ),
    );
  }
}

