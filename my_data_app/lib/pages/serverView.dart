import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_data_app/widgets/accessCard.dart';

class ServerView extends StatefulWidget {
  final Map<String, dynamic> serverInfo;

  const ServerView({
    super.key,
    required this.serverInfo,
  });

  @override
  State<ServerView> createState() => _ServerViewState();
}

class _ServerViewState extends State<ServerView> {
  ServerState state = ServerState.offline;

  @override
  void initState() {
    super.initState();

    fetchServerStatus(
      widget.serverInfo["url"],
      false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.serverInfo["name"]),
                Text(
                  state.name,
                  style: TextStyle(
                    fontSize: 18,
                    color:
                      state == ServerState.offline
                        ? Colors.red :
                      state == ServerState.online
                        ? Colors.green
                        : Colors.grey,
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            AccessCard(
              accessName: "Global",
              serverInfo: widget.serverInfo,
            ),
            AccessCard(
              accessName: "MyData",
              serverInfo: widget.serverInfo,
            ),
          ],
        ),
      ),
    );
  }

  void fetchServerStatus(String serverUrl, bool secure) async {
    final uri = Uri.parse(serverUrl + "/ping");

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        state = ServerState.online;
      });
    } else {
      print("Request failed with status: " + response.statusCode.toString() + ".");
    }
  }
}

enum ServerState {
  offline,
  online
}