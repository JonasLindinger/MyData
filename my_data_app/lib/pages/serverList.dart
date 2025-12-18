import 'package:flutter/material.dart';
import 'package:my_data_app/utils/customPrefs.dart';
import 'package:my_data_app/widgets/serverCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerListPage extends StatefulWidget {
  const ServerListPage({super.key});

  @override
  State<ServerListPage> createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  List<String> server = [];
  
  @override
  void initState() {
    super.initState();
    loadServerList();
    // clearPrefs();
  }

  void clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
                const Text(
                  "Servers"
                ),
                IconButton(
                  onPressed: () {
                    showAddServerPopUp(context);
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0, // disable default shadow
          ),
        ),
      ),
      body: Container(
        child:
          server.isNotEmpty
            ? ListView.builder(
              itemCount: server.length,
              itemBuilder: (context, index) {
                final serverName = server[index];
                return ServerCard(
                  serverName: serverName,
                  onDelete: (name) {
                    setState(() {
                      server.remove(name); // remove from local list
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setStringList("server", server);
                        CustomPrefs.removeMap(name);
                      });
                    });
                  },
                );
              },
            )
            : SizedBox(
              height: 100,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showAddServerPopUp(context);
                  },
                  child: const Text(
                    "Add a server",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ),
              ),
            ),
      ),
    );
  }

  void showAddServerPopUp(BuildContext context) {
    final TextEditingController serverNameController = TextEditingController();
    final TextEditingController serverUrlController = TextEditingController();
    final TextEditingController serverAccessKeyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 240,
            child: Column(
              children: [
                TextField(
                  controller: serverNameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "My Data Server",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: serverUrlController,
                  decoration: InputDecoration(
                    labelText: "Server URL",
                    hintText: "https://mydataserver.de",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: serverAccessKeyController,
                  decoration: InputDecoration(
                    labelText: "Access key",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    addServer(
                      serverNameController.text,
                      serverUrlController.text,
                      serverAccessKeyController.text
                    );
                    Navigator.of(context).pop(); // close popup
                  },
                  child: Text(
                    "Add Server",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ),
              ],
            ),
          )
        );
      },
    );
  }

  void addServer(String name, String url, String accessKey) async {
    // Validate
    if (name.isEmpty || url.isEmpty || accessKey.isEmpty) {
      return;
    }

    // Check for duplicates
    if (server.contains(name)) {
      return; // Deny duplicates.
    }

    // Save server name
    final prefs = await SharedPreferences.getInstance();
    List<String>? newServerList = prefs.getStringList("server");
    newServerList ??= [];
    newServerList.add(name);
    await prefs.setStringList("server", newServerList);

    // Save server info
    CustomPrefs.saveMap(name, {
      "name": name,
      "url": url,
      "accessKey": accessKey,
    });

    // Update
    setState(() {
      server = newServerList!;
    });
  }

  void loadServerList() async {
    final prefs = await SharedPreferences.getInstance();
    final map = prefs.getStringList("server");

    // Check if there are servers.
    if (map == null) {
      return;
    }

    setState(() {
      server = map;
    });
  }
}