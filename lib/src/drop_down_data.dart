import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:dynamic_button/dynamic_button.dart';


class DataDropDown {
  final String? id;
  final String? name;
  final Widget? icon;
  DataDropDown({ this.id, this.name, this.icon});
  factory DataDropDown.fromJson(Map<String, dynamic> json) =>
      DataDropDown(
        id: json['id'] as String?,
        name: json['name'] as String?,
        icon: json['icon'],
      );
  Map<String,dynamic> toJson(DataDropDown instance) =>
      <String, dynamic>{
        'id': instance.id,
        'name': instance.name,
        'icon': instance.icon,
      };
  DataDropDown copyWith({String? name, String? id, Widget? icon }){
    return DataDropDown(
      id: id ?? "",
      name: name ?? "",
      icon: icon,
    );
  }
}

/// DropdownMenu
class DropDownData extends StatefulWidget { // ConsumerStatefulWidget
  const DropDownData({Key? key,
    this.child,
    this.enableChange = true,
    this.tooltip,
    this.title = "",
    this.value = "",
    this.uuidValue = "",
    this.uuidValues,
    this.addFirstEmpty = false,
    this.viewNumber = false,
    this.research = false,
    this.callbackResearch,

    required this.listData,
    required this.callback
  }) : super(key: key);
  final Widget? child; /// AFAIRE CHILD PERSO

  final bool enableChange;
  final String? tooltip;
  final String title;
  final String value;             /// Name Current + Selection if uuidValue = ""
  final String uuidValue;         /// Select uuid
  final List<String>? uuidValues; /// Select uuid multi
  final bool addFirstEmpty;
  final bool viewNumber;
  final bool research;
  final Function(String)? callbackResearch;
  final List<DataDropDown> listData;
  final Function(DataDropDown) callback;

  @override
  DropDownDataState createState() => DropDownDataState();
}

class DropDownDataState extends State<DropDownData> {
  List<DataDropDown> listCurrent = [];
  bool searchEnable = false;
  int searchNumber = 0;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  void returnSelection(int index) {
    FocusScope.of(context).unfocus(); /// Defocus Text Change
    if(widget.enableChange){
      widget.callback(listCurrent[ index ]); //call to parent
    }
  }
  String getValidSearch( String path ){
    return path.toLowerCase().replaceAll(" ", "").replaceAll("é", "e").replaceAll("è", "e").replaceAll("ê", "e").replaceAll("ë", "e");
  }
  List<DataDropDown> returnList( ) {
    listCurrent = List.generate(widget.listData.length, (index) => widget.listData[index]);
    listCurrent.removeWhere((thisData) =>
        searchController.value.text != "" && thisData.id != null && !getValidSearch(thisData.id!).contains(getValidSearch(searchController.value.text)) &&
        searchController.value.text != "" && thisData.name != null && !getValidSearch(thisData.name!).contains(getValidSearch(searchController.value.text))
    );
    if(widget.addFirstEmpty){
      listCurrent.insert(0,DataDropDown(id: "",name: ""));
    }
    searchNumber = widget.addFirstEmpty ? listCurrent.length-1 : listCurrent.length;
    if( widget.callbackResearch != null ){
      widget.callbackResearch!(searchController.value.text); //call to parent
    }
    return listCurrent;
  }
  initListData(_) async {
    returnList( );
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
    return widget.tooltip != null ? Tooltip(message: widget.tooltip,
        child: dropDown(context)) : dropDown(context);
  }
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
        hoverColor: colorScheme.secondaryContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          PopupMenuButton(
            enabled: true,
            //tooltip: "", // Disable Text Info Popup
            offset: const Offset(0.02, 40.0),// Position X/Y
            elevation: 16,
            onSelected: (dynamic index) {
              if(kDebugMode){print('index is $index');}
              returnSelection(index);
            },
            onCanceled: () {if(kDebugMode){print('cancelled!');}},
            color: colorScheme.onSecondaryContainer,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),

            child: /** widget.title != "" ?
            DynamicButton(
              enabled: false,
               // title: " ",
                 title: '${widget.title}${widget.value}',
              end: widget.viewNumber ? Text(searchNumber.toString(),style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant) ) : null,
              icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant, size: 20,), // colorScheme.onInverseSurface,
            )
                : */
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 45,
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 4, color: Colors.black45)
              ], color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.more_vert, color: Colors.grey,),
            ),

            itemBuilder: (BuildContext context) => <PopupMenuEntry>[

              //for(DataDropdown thisData in  returnList())
              for(int i = 0; i< listCurrent.length;i++)
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
                                  widget.uuidValues!.contains(listCurrent[i].id) ? colorScheme
                                  .secondaryContainer :
                              widget.uuidValue != "" && widget.uuidValue == listCurrent[i].id
                                  ? colorScheme.secondaryContainer
                                  :
                              widget.uuidValue != "" && widget.uuidValue != listCurrent[i].id
                                  ? colorScheme.primaryContainer
                                  :
                              widget.value == listCurrent[i].name
                                  ? colorScheme.secondaryContainer
                                  : colorScheme.primaryContainer,
                            ),
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(listCurrent[i].icon != null) listCurrent[i].icon!,
                                    if(listCurrent[i].icon == null)
                                    Icon(Icons.type_specimen_outlined, color: colorScheme.onInverseSurface, size: 20,),

                                    Flexible(
                                      child: RichText( // SelectableText.rich(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text:
                                            listCurrent[i].name.toString(),
                                                style: textTheme.bodyMedium!.copyWith(
                                                    color: colorScheme.onBackground)),
                                            if(listCurrent[i].id != "")TextSpan(
                                                text: "\n${listCurrent[i].id.toString()}",
                                                style: const TextStyle(fontSize: 10, color: Colors.white24)),
                                          ],),),),
                                  ],
                                ),


                          ),
                        );
                      }
                  ),
                ),
            ],
          ),

          if(widget.research)
            Theme( data: Theme.of(context).copyWith(
                cardColor: Colors.transparent,
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: IconButton(
                iconSize: 20,
                icon: searchEnable   ? const Icon(Icons.cancel_outlined ,color:  Colors.red,size: 18, ) : const Icon(Icons.manage_search_outlined ,color:  Colors.red,size: 18, ),
                onPressed: (){
                  if(!searchEnable && searchController.value.text==""){
                    setState(() {searchEnable = true;});
                    if(!mounted) return;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      FocusScope.of(context).requestFocus(_searchFocus);
                      //_fieldFocusChange(context, _nameFocus, _emailFocus);
                    });
                  }else{
                    FocusScope.of(context).unfocus(); /// Defocus Text Change
                    searchController.value = searchController.value.copyWith(text: "",);
                    _searchFocus.unfocus();
                    searchEnable = false;
                    returnList( );
                  }
                },
              ),),


          if((widget.research && searchEnable) || searchController.value.text != "")
            SizedBox(
              width: 100,
              child: TextFormField(
                cursorColor: colorScheme.onPrimary,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                controller: searchController,
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.next,
                onChanged: (research) {
                  searchController.value = searchController.value.copyWith(text: research);
                  returnList();
                },
                focusNode: _searchFocus,
                onFieldSubmitted: (term) {
                  _searchFocus.unfocus();
                  searchEnable = false;
                  //_fieldFocusChange(context, _nameFocus, _emailFocus);
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: colorScheme.onPrimary),),
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




