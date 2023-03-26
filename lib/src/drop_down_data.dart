import 'package:drop_down_data/src/dynamic_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// DropDownData
///
/// Structure Data for use Drop-down.
class DataDropDown {
  final String? id;
  final String? name;
  final Widget? icon;
  DataDropDown({this.id, this.name, this.icon});
  factory DataDropDown.fromJson(Map<String, dynamic> json) => DataDropDown(
        id: json['id'] as String?,
        name: json['name'] as String?,
        icon: json['icon'],
      );
  Map<String, dynamic> toJson(DataDropDown instance) => <String, dynamic>{
        'id': instance.id,
        'name': instance.name,
        'icon': instance.icon,
      };
  DataDropDown copyWith({String? id, String? name, Widget? icon}) {
    return DataDropDown(
      id: id ?? "",
      name: name ?? "",
      icon: icon,
    );
  }
}

/// DropDownData
///
/// Drop-down list of data.dart allowing to make one or more selections and to search among the data.dart or an identifier.
class DropDownData extends StatefulWidget {
  // ConsumerStatefulWidget

  final Widget? childButton; //  CHILD BUTTON CUSTOM
  final List<DataDropDown> listData;
  final String? tooltip;
  final String title;
  final String value; // Name Current + Selection if uuidValue !=""
  final String uuidValue; // Select uuid
  final List<String>? uuidValues; // Select uuid multi
  final bool addFirstEmpty;
  final bool viewNumber;
  final bool selection;
  final Function(DataDropDown) selectionCallback;
  final bool research;
  final Function(String)? researchCallback;

  const DropDownData({
    Key? key,
    this.childButton,
    required this.listData,
    this.tooltip,
    this.title = "",
    this.value = "",
    this.uuidValue = "",
    this.uuidValues,
    this.addFirstEmpty = false,
    this.viewNumber = false,
    this.selection = true,
    required this.selectionCallback,
    this.research = false,
    this.researchCallback,
  }) : super(key: key);

  @override
  DropDownDataState createState() => DropDownDataState();
}

class DropDownDataState extends State<DropDownData> {
  List<DataDropDown> listCurrent = [];
  bool searchEnable = false;
  int searchNumber = 0;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  /// Call back parent current Selection
  void returnSelection(int index) {
    FocusScope.of(context).unfocus();
    if (widget.selection) {
      widget.selectionCallback(listCurrent[index]);
    }
  }

  /// Remove All "é" to "e" for Search
  String getValidSearch(String path) {
    return path
        .toLowerCase()
        .replaceAll(" ", "")
        .replaceAll("é", "e")
        .replaceAll("è", "e")
        .replaceAll("ê", "e")
        .replaceAll("ë", "e");
  }

  /// Current list with Search
  List<DataDropDown> returnList() {
    listCurrent = List.generate(
        widget.listData.length, (index) => widget.listData[index]);
    listCurrent.removeWhere((thisData) =>
        searchController.value.text != "" &&
        thisData.id != null &&
        !getValidSearch(thisData.id!)
            .contains(getValidSearch(searchController.value.text)) &&
        searchController.value.text != "" &&
        thisData.name != null &&
        !getValidSearch(thisData.name!)
            .contains(getValidSearch(searchController.value.text)));
    if (widget.addFirstEmpty) {
      listCurrent.insert(0, DataDropDown(id: "", name: ""));
    }
    searchNumber =
        widget.addFirstEmpty ? listCurrent.length - 1 : listCurrent.length;
    if (widget.researchCallback != null) {
      widget.researchCallback!(searchController.value.text); //call to parent
    }
    return listCurrent;
  }

  /// Get List Init
  initListData(_) async {
    returnList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(initListData);
  }

  @override
  void dispose() {
    _searchFocus.unfocus();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return MouseRegion(
    //    cursor: SystemMouseCursors.click,
    //    child: Container(color: Colors.red,height: 50,width: 50,));

    /// If tooltip enable
    return widget.tooltip != null
        ? Tooltip(message: widget.tooltip, child: dropDown(context))
        : dropDown(context);
  }

  /// Button For Drop Data
  Widget dropDown(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.transparent,
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
        splashColor: Colors.transparent,
        // hoverColor: Colors.transparent,
        hoverColor: colorScheme.onPrimary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton(
            enabled: true,
            tooltip: "", // Disable Text Info Popup
            offset: const Offset(0.02, 40.0), // Position X/Y
            elevation: 16,
            onSelected: (dynamic index) {
              if (kDebugMode) {
                print('DropDownData => index is $index');
              }
              returnSelection(index);
            },
            onCanceled: () {
              if (kDebugMode) {
                print('DropDownData => cancelled');
              }
            },
            color: colorScheme.onSecondaryContainer,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.childButton ??
                (widget.title != ""
                    ? DynamicButton(
                        enabled: false,
                        title: '${widget.title}${widget.value}',
                        end: widget.viewNumber
                            ? Text(searchNumber.toString(),
                                style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant))
                            : null,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ), // colorScheme.onInverseSurface,
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 45,
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(blurRadius: 4, color: Colors.black45)
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ),
                      )),

            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              //for(DataDropDown thisData in  returnList())
              for (int i = 0; i < listCurrent.length; i++)
                PopupMenuItem(
                  value: i,
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.uuidValues != null &&
                                  widget.uuidValues!.contains(listCurrent[i].id)
                              ? colorScheme.primaryContainer
                              : widget.uuidValues != null &&
                                      widget.uuidValues!.isNotEmpty &&
                                      listCurrent[i].name == ""
                                  ? colorScheme.surface
                                  : widget.uuidValues != null &&
                                          widget.uuidValues!.isEmpty &&
                                          listCurrent[i].name == ""
                                      ? colorScheme.primaryContainer
                                      : widget.uuidValue != "" &&
                                              widget.uuidValue ==
                                                  listCurrent[i].id
                                          ? colorScheme.primaryContainer
                                          : widget.uuidValue != "" &&
                                                  widget.uuidValue !=
                                                      listCurrent[i].id
                                              ? colorScheme.surface
                                              : widget.value ==
                                                      listCurrent[i].name
                                                  ? colorScheme.primaryContainer
                                                  : colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (listCurrent[i].icon != null)
                              listCurrent[i].icon!,
                            if (listCurrent[i].icon == null)
                              //Icon(Icons.type_specimen_outlined, color: colorScheme.onInverseSurface, size: 20,),
                              Icon(
                                Icons.ads_click,
                                color: colorScheme.onInverseSurface,
                                size: 20,
                              ),
                            Expanded(
                              child: Column(
                                children: [
                                  if (listCurrent[i].name != "")
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: RichText(
                                          // SelectableText.rich(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: listCurrent[i]
                                                      .name
                                                      .toString(),
                                                  style: textTheme.bodyMedium!
                                                      .copyWith(
                                                          color: colorScheme
                                                              .onSurface)),
                                              //if(listCurrent[i].name != "" && listCurrent[i].id != "")const TextSpan(text: "\n"),
                                              //TextSpan(text: listCurrent[i].id.toString(), style: const TextStyle(fontSize: 10, color: Colors.white24, )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (listCurrent[i].id != "")
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: RichText(
                                          textAlign: TextAlign.right,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: listCurrent[i]
                                                      .id
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white24,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),
          if (widget.research)
            Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.transparent,
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: IconButton(
                iconSize: 20,
                icon: searchEnable
                    ? const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 18,
                      )
                    : const Icon(
                        Icons.manage_search_outlined,
                        color: Colors.red,
                        size: 18,
                      ),
                onPressed: () {
                  if (!searchEnable && searchController.value.text == "") {
                    setState(() {
                      searchEnable = true;
                    });
                    if (!mounted) return;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      FocusScope.of(context).requestFocus(_searchFocus);
                      //_fieldFocusChange(context, _nameFocus, _emailFocus);
                    });
                  } else {
                    FocusScope.of(context).unfocus();
                    searchController.value = searchController.value.copyWith(
                      text: "",
                    );
                    _searchFocus.unfocus();
                    searchEnable = false;
                    setState(() {
                      returnList();
                    });
                  }
                },
              ),
            ),
          if ((widget.research && searchEnable) ||
              searchController.value.text != "")
            SizedBox(
              width: 100,
              child: TextFormField(
                cursorColor: colorScheme.onPrimary,
                style: TextStyle(color: colorScheme.onBackground, fontSize: 12),
                controller: searchController,
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.next,
                onChanged: (research) {
                  searchController.value =
                      searchController.value.copyWith(text: research);
                  setState(() {
                    returnList();
                  });
                },
                focusNode: _searchFocus,
                onFieldSubmitted: (term) {
                  _searchFocus.unfocus();
                  searchEnable = false;
                  //_fieldFocusChange(context, _nameFocus, _emailFocus);
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: colorScheme.onPrimary),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  //labelText: "recherche",
                  //labelStyle: TextStyle(fontSize: 10, color: colorScheme.onPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
