import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccessDataView extends StatefulWidget {
  final Map<String, dynamic> serverInfo;

  const AccessDataView({
    super.key,
    required this.serverInfo,
  });

  @override
  State<AccessDataView> createState() => _AccessDataViewState();
}

class _AccessDataViewState extends State<AccessDataView> {
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
                Text("Todo: Title"),
              ],
            )
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
