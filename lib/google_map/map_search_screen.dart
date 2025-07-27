import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view_model/googleMapViewModel.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MapSearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          finish(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (kDebugMode) {
      print(query);
    }
    return TextButton(
      child: text(query),
      onPressed: () {
        finish(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Provider.of<GoogleMapViewModel>(context, listen: false)
        .updateSearchController(query);
    return Consumer<GoogleMapViewModel>(builder: (context, value, child) {
      return ListView.builder(
        itemCount: value.playList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              finish(context, value.playList[index]['description']);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: text(value.playList[index]['description']),
            ),
          );
        },
      );
    });
  }
}
