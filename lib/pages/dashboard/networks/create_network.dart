import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../server_details.dart';

class CreateNetwork extends StatefulWidget {
  const CreateNetwork({super.key});

  @override
  State<CreateNetwork> createState() => CreateNetworkState();
}

class CreateNetworkState extends State<CreateNetwork> {
  late String networkName = "";

  String userCmd = "";
  late var cmdOutput = "";

  web(userCmd, ip) async {
    var url = await http.get(
      Uri.http("$ip", "/cgi-bin/cmdTestH.py", {"cmd": userCmd}),
    );
    setState(() {
      cmdOutput = url.body;
      // ignore: avoid_print
      print(cmdOutput);
    });
  }

  void _printInputValues() {
    // ignore: avoid_print
    print("Network Name: $networkName\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Network Name',
                    hintText: "Enter Network Name",
                    helperText: 'example: myNetwork',
                    filled: true,
                    hoverColor: Colors.blue.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xff4A6572),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xff4A6572),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      networkName = value;
                    });
                  },
                ),
              ),
              SizedBox(
                // width: 500,
                child: FloatingActionButton.extended(
                    icon: const Icon(Icons.add),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      _printInputValues();
                      if (networkName.isNotEmpty) {
                        userCmd = "docker network create $networkName";

                        // ignore: avoid_print
                        print(userCmd);
                        web(userCmd, serverIP);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Network Created')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter Network name correctly')));
                      }
                    },
                    label: const Text("Create Network")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
