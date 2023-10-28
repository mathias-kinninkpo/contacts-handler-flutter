import 'package:flutter/material.dart';
import 'sqlite/contact.dart';


class SecondPage extends StatefulWidget {
  final int contactId;
  const SecondPage({required this.contactId});



  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String _fullName = "";
  String _phone = "";
  ContactProvider _databaseService = new ContactProvider();

  _loadContactData() async {
    Contact contact = await _databaseService.getContact(widget.contactId);
    setState(() {
      _fullName = contact.fullName ?? "";
      _phone = contact.phone ?? "";
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>  _loadContactData());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail des contacts", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Détails du contact",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.person, size: 48),
                    title: Text(
                      _fullName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, size: 48),
                    title: Text(
                      _phone,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}


