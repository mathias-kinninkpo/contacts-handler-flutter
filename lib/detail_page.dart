import 'package:flutter/material.dart';


class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);



  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String _firstname = "";
  String _lasttname = "";
  String _profession = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail des contacts", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text("Nom : $_lasttname \n"),
                Text("Prénom : $_firstname \n"),
                Text("Profession : $_profession \n"),
              ],
            ),
          )
        ],
      ),
    );
  }
}


