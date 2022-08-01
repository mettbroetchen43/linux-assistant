import 'package:flutter/material.dart';
import 'package:linux_helper/enums/browsers.dart';
import 'package:linux_helper/layouts/action_entry_card.dart';
import 'package:linux_helper/layouts/recommendation_card.dart';
import 'package:linux_helper/models/action_entry.dart';
import 'package:linux_helper/services/action_handler.dart';
import 'package:linux_helper/services/linux.dart';

class MainSearch extends StatefulWidget {
  late List<ActionEntry> actionEntries;

  MainSearch({Key? key, required this.actionEntries}) : super(key: key);

  @override
  State<MainSearch> createState() =>
      _MainSearchState(actionEntries: actionEntries);
}

class _MainSearchState extends State<MainSearch> {
  late List<ActionEntry> actionEntries;

  String _lastKeyword = "";

  List<ActionEntry> _foundEntries = [];

  var selectedIndex = 1;

  final searchBarController = TextEditingController();

  _MainSearchState({required this.actionEntries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter a search term..."),
              controller: searchBarController,
              autofocus: true,
              onChanged: (value) => _runFilter(value),
              onSubmitted: (value) {
                if (_foundEntries.length == 1) {
                  ActionHandler.handleActionEntry(_foundEntries[0], clear);
                }
              },
            ),
            _foundEntries.length == 0
                ? RecommendationCard()
                : Expanded(
                    child: ListView(
                      children: List.generate(
                          _foundEntries.length,
                          (index) => ActionEntryCard(
                              actionEntry: _foundEntries[index],
                              callback: clear,
                              selected: selectedIndex == index)),
                    ),
                  )
          ],
        )),
      ),
    );
  }

  void clear() {
    _lastKeyword = "";
    searchBarController.clear();
    _runFilter("");
  }

  void _runFilter(String keyword, {bool runSetState = true}) {
    _lastKeyword = keyword;
    keyword = keyword.toLowerCase();
    List<ActionEntry> results = [];
    if (keyword.isEmpty) {
      results = [];
    } else {
      results = actionEntries
          .where((actionEntry) =>
              (actionEntry.name.toLowerCase().contains(keyword) ||
                  actionEntry.description.toLowerCase().contains(keyword)))
          .toList();
    }

    if (results.isEmpty &&
        keyword != "" &&
        Linux.currentEnviroment.browser == BROWSERS.FIREFOX) {
      results.add(ActionEntry("Search in web for " + keyword,
          "look for online results..", "websearch:" + keyword));
    }

    if (Uri.parse(keyword).isAbsolute) {
      ActionEntry actionEntry = ActionEntry("Open " + keyword,
          "Open default webbrowser", "openwebsite:" + keyword);
      actionEntry.priority = 10;
      results.add(actionEntry);
    }

    results.sort((a, b) => b.priority.compareTo(a.priority));

    _foundEntries = results;

    if (runSetState) {
      setState(() {});
    }
  }
}