import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_data/drop_down_data.dart';
import 'data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primaryContainer: Color(0xff002c55), // Back Button
            onBackground: Color(0xc8d7d7d7), // Text Button

            secondaryContainer: Colors.blueGrey,
            onSecondaryContainer: Color(0xffadadad),

            onPrimary: Colors.white70,

            surface: Color(0xff606060),
            onSurface: Color(0xff00ccff),

            onSurfaceVariant: Colors.red,
            onInverseSurface: Colors.white70, // Icon Selection

            primary: Colors.blue,
            secondary: Colors.blue,
            onSecondary: Colors.blue,
            error: Colors.blue,
            onError: Colors.blue,
            background: Colors.blue,
          )),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataDropDown> listData = [];

  ///
  String selectionCustomID = "";
  String selectionCustomValue = "";

  ///
  String selectionID = "";
  String selectionValue = "";

  ///
  String selectionMultiID = "";
  String selectionMultiValue = "";
  List<String> selectionListMultiID = [];

  ///
  String selectionLevelID = "";
  String selectionLevelValue = "";

  ///
  String selectionBigID = "";
  String selectionBigValue = "";
  List<String> selectionListBigID = [];

  ///
  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> listMap = [];
    listMap.add({"id": "1", "name": "agenda"});
    listMap.add({"id": "2", "name": "contact"});
    listData = List<DataDropDown>.from(
        listMap.map((model) => DataDropDown.fromJson(model)));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Selection Custom",
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            Text("selectionCustomID: $selectionCustomID"),
            Text("selectionCustomValue: $selectionCustomValue"),
            DropDownData(
              tooltip: "show menu",
              title: selectionCustomValue != "" ? " " : "selection",
              value: selectionCustomValue,
              uuidValue: selectionCustomID,
              addFirstEmpty: true,
              viewNumber: true,
              research: false,
              researchCallback: (String val) {
                setState(() {});
              },
              listData: listData,
              selectionCallback: (DataDropDown selection) {
                if (kDebugMode) {
                  print(selection);
                  print(selection.id);
                  print(selection.name);
                }
                selectionCustomValue = selection.name ?? "";
                selectionCustomID = selection.id ?? "";
                setState(() {});
              },
              childButton: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    border: Border.all(),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      selectionCustomValue != ""
                          ? selectionCustomValue
                          : "Custom Button",
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Selection",
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            Text("selectionID: $selectionID"),
            Text("selectionValue: $selectionValue"),
            DropDownData(
                tooltip: "show menu",
                title: selectionValue != "" ? " " : "selection",
                value: selectionValue,
                uuidValue: selectionID,
                addFirstEmpty: true,
                viewNumber: true,
                research: false,
                researchCallback: (String val) {
                  setState(() {});
                },
                listData: listData,
                selectionCallback: (DataDropDown selection) {
                  if (kDebugMode) {
                    print(selection);
                    print(selection.id);
                    print(selection.name);
                  }
                  selectionValue = selection.name ?? "";
                  selectionID = selection.id ?? "";
                  setState(() {});
                }),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Multi Selection",
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            Text("selectionMultiID: $selectionMultiID"),
            Text("selectionMultiValue: $selectionListMultiID"),
            DropDownData(
                title: "multi selection",
                //value: selectionMultiValue,
                uuidValues: selectionListMultiID,
                addFirstEmpty: true,
                viewNumber: false,
                research: false,
                researchCallback: (String val) {
                  setState(() {});
                },
                listData: listData,
                selectionCallback: (DataDropDown selection) {
                  if (kDebugMode) {
                    print(selection);
                    print(selection.id);
                    print(selection.name);
                  }
                  selectionMultiValue = selection.name ?? "";
                  selectionMultiID = selection.id ?? "";

                  if (selectionListMultiID.contains(selectionMultiID)) {
                    selectionListMultiID.remove(selectionMultiID);
                  } else if (selectionMultiID != "") {
                    selectionListMultiID.add(selectionMultiID);
                  } else {
                    selectionListMultiID.clear();
                  }
                  setState(() {});
                }),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Level User",
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            Text("selectionLevelID: $selectionLevelID"),
            Text("selectionLevelValue: $selectionLevelValue"),
            DropDownData(
                title:
                    selectionMultiValue != "" ? "Level User: " : "Level User",
                value: selectionMultiValue,
                uuidValue: selectionLevelValue,
                addFirstEmpty: false,
                viewNumber: true,
                research: true,
                researchCallback: (String val) {
                  setState(() {});
                },
                listData: getListData,
                selectionCallback: (DataDropDown selection) {
                  if (kDebugMode) {
                    print(selection);
                    print(selection.id);
                    print(selection.name);
                  }
                  selectionMultiValue = selection.name ?? "";
                  selectionLevelID = selection.id ?? "";

                  setState(() {});
                }),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Big Data",
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            Text("selectionBigValue: $selectionBigValue"),
            Text("selectionBigID: $selectionBigID"),
            Text("selectionListBigID: $selectionListBigID"),
            DropDownData(
                title: "Large Data",
                //value: selectionBigValue,
                uuidValues: selectionListBigID,
                addFirstEmpty: true,
                viewNumber: true,
                research: true,
                researchCallback: (String val) {
                  setState(() {});
                },
                listData: getListDataBig,
                selectionCallback: (DataDropDown selection) {
                  if (kDebugMode) {
                    print(selection);
                    print(selection.id);
                    print(selection.name);
                  }
                  selectionBigValue = selection.name ?? "";
                  selectionBigID = selection.id ?? "";

                  if (selectionListBigID.contains(selectionBigID)) {
                    selectionListBigID.remove(selectionBigID);
                  } else if (selectionBigID != "") {
                    selectionListBigID.add(selectionBigID);
                  } else {
                    selectionListBigID.clear();
                  }
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }
}
