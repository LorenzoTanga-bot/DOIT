import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doit/providers/SearchProvider.dart';

class SearchFilter extends StatefulWidget {
  _SearchFilter createState() => _SearchFilter();
}

class _SearchFilter extends State<SearchFilter> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Projects"),
                Switch(
                  value: Provider.of<SearchProvider>(context, listen: false)
                      .getSearchProject(),
                  onChanged: (value) {
                    {
                      setState(() {
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchProject(value);
                      });
                    }
                  },
                )
              ],
            ),
            Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Users"),
              Switch(
                  value: Provider.of<SearchProvider>(context, listen: false)
                      .getSearchUser(),
                  onChanged: (bool newValue) {
                    setState(() {
                      if (!newValue) {
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchDesigner(false);
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchProjectProposer(false);
                      } else {
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchDesigner(true);
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchProjectProposer(true);
                      }
                      Provider.of<SearchProvider>(context, listen: false)
                          .setSearchUser(newValue);
                    });
                  })
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              if (!Provider.of<SearchProvider>(context, listen: false)
                  .getSearchUser())
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Project Proposers",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              if (Provider.of<SearchProvider>(context, listen: false)
                  .getSearchUser())
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Project Proposers"),
                ),
              Switch(
                  value: Provider.of<SearchProvider>(context, listen: false)
                      .getSearchProjectProposer(),
                  onChanged: (bool newValue) {
                    setState(() {
                      if (Provider.of<SearchProvider>(context, listen: false)
                          .getSearchUser()) {
                        if (!Provider.of<SearchProvider>(context, listen: false)
                                .getSearchDesigner() &&
                            !newValue) {
                          Provider.of<SearchProvider>(context, listen: false)
                              .setSearchUser(false);
                        }
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchProjectProposer(newValue);
                      }
                    });
                  })
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              if (!Provider.of<SearchProvider>(context, listen: false)
                  .getSearchUser())
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Designers",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              if (Provider.of<SearchProvider>(context, listen: false)
                  .getSearchUser())
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Designers"),
                ),
              Switch(
                  value: Provider.of<SearchProvider>(context, listen: false)
                      .getSearchDesigner(),
                  onChanged: (bool newValue) {
                    setState(() {
                      if (Provider.of<SearchProvider>(context, listen: false)
                          .getSearchUser()) {
                        if (!Provider.of<SearchProvider>(context, listen: false)
                                .getSearchProjectProposer() &&
                            !newValue) {
                          Provider.of<SearchProvider>(context, listen: false)
                              .setSearchUser(false);
                        }
                        Provider.of<SearchProvider>(context, listen: false)
                            .setSearchDesigner(newValue);
                      }
                    });
                  })
            ])
          ],
        ),
      ),
    );
  }
}
