import 'package:flutter/material.dart';
import 'package:my_data_app/utils/CustomPrefs.dart';

class ServerCard extends StatefulWidget {
  final String serverName;
  final Function(String)? onDelete; // add this to ServerCard

  const ServerCard({
    super.key,
    required this.serverName,
    this.onDelete,
  });

  @override
  State<ServerCard> createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  late Map<String, dynamic>? serverInfo = {};

  @override
  void initState() {
    super.initState();
    loadUrl();
  }

  @override
  Widget build(BuildContext context) {
    String url = serverInfo?["url"] ?? "https://";

    return Dismissible(
      key: Key(widget.serverName), // Unique key for each server
      direction: DismissDirection.startToEnd, // swipe from left to right
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // Call a callback to remove the server from the list
        if (widget.onDelete != null) {
          widget.onDelete!(widget.serverName);
        }
        // Optional: show a snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(
            child: Text(widget.serverName + " deleted"),
          )),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4, // shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(widget.serverName),
          subtitle: Text(url),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // Optional: do something on tap
          },
        ),
      ),
    );
  }

  void loadUrl() async {
    final info = await CustomPrefs.loadMap(widget.serverName);

    setState(() {
      serverInfo = info;
    });
  }
}
