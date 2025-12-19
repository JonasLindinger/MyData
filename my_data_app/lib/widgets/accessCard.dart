import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_data_app/pages/accessDataView.dart';

class AccessCard extends StatefulWidget {
  final String accessName;
  final Map<String, dynamic> serverInfo;

  const AccessCard({
    super.key,
    required this.accessName,
    required this.serverInfo,
  });

  @override
  State<AccessCard> createState() => _AccessCardState();
}

class _AccessCardState extends State<AccessCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4, // shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(widget.accessName),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Open Server view
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AccessDataView(accessName: widget.accessName, serverInfo: widget.serverInfo),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // start from right
                const end = Offset.zero;        // end at 0,0
                const curve = Curves.ease;

                final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
