import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomCompulsoryText.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomDropDownButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/Model/gream.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CreateAccountScreen.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';

class PostAGream extends StatefulWidget {
  static final String id = 'postAGreamId';

  @override
  _PostAGreamState createState() => _PostAGreamState();
}

class _PostAGreamState extends State<PostAGream> {
  String descText = '';
  String titleText = '';
  List<String> _selectedCategoryList = List();
  String _selectedSubCategory;
  bool _isPickCategoryWidgetVisible = false;
  /*Distance between 'Select a category' and categories card list.
  * This changes when Card category list appears or disappears*/
  double _height = 15.0;

  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _linkCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();
  TextEditingController _titleCtrl = TextEditingController();

  ValueNotifier<bool> post_a_gream_progress = new ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => popView(context),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      'New Gream',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ))
                  ],
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Color(0XFFAAB2BA),
                height: 0.0,
              ),
              Form(
                key: _globalKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCompulsoryText('Title'),
                          Text(
                            '${titleText.length}/200',
                            style: TextStyle(
                              color: Color(0XFFAAB2BA),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        controller: _titleCtrl,
                        limit: 200,
                        onChanged: (value) {
                          setState(() {
                            titleText = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      CustomCompulsoryText('Link'),
                      CustomTextField(
                        controller: _linkCtrl,
                      ),
                      SizedBox(height: 15.0),
                      CustomCompulsoryText('Category'),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _height = 0.0;
                            _isPickCategoryWidgetVisible = true;
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: IgnorePointer(
                            child: CustomTextField(
                              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                              hintText: 'Select a category',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: _height),
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sub-category'),
                              CustomDropDownButton(
                                items: _categories,
                                selectedItem: _selectedSubCategory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSubCategory = value;
                                  });
                                },
                                hintText: 'Select a Sub-Category',
                              ),
                              SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Description'),
                                  Text(
                                    '${descText.length}/100',
                                    style: TextStyle(
                                      color: Color(0XFFAAB2BA),
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextField(
                                hintText: 'Give a description about your post',
                                maxLines: 5,
                                controller: _descCtrl,
                                onChanged: (value) {
                                  setState(() {
                                    descText = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _isPickCategoryWidgetVisible,
                            child: DropDownCategorySelectionWidget(
                                checkBoxClicked: (isChecked, index) {
                              setState(
                                () {
                                  _categoriesCheckboxBool[index] = isChecked;
                                  if (!(_selectedCategoryList
                                      .contains(_categories[index]))) {
                                    _selectedCategoryList
                                        .add(_categories[index]);
                                  }
                                },
                              );
                              print(_selectedCategoryList);
                            }, doneClicked: () {
                              setState(() {
                                _height = 15.0;
                                _isPickCategoryWidgetVisible = false;
                              });
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      ValueListenableBuilder(
                          valueListenable: post_a_gream_progress,
                          builder: (context, bool value, child) {
                            return Column(
                              children: <Widget>[
                                Visibility(
                                  visible: post_a_gream_progress.value,
                                  child: Loader(
                                    opacity: 0.05,
                                  ),
                                ),
                                Visibility(
                                    visible: !post_a_gream_progress.value,
                                    child: ActionButton(
                                        title: 'Post Gream',
                                        fillColor: appTheme.primaryColor,
                                        onPressed: () {
                                          if (_descCtrl.text != null &&
                                              _titleCtrl.text != null &&
                                              _linkCtrl.text != null &&
                                              _selectedCategoryList != null &&
                                              _selectedSubCategory != null) {
                                            post_a_gream_progress.value = true;

                                            _postGream(GreamitPost(
                                              title: _titleCtrl.text,
                                              link: _linkCtrl.text,
                                              categoryList:
                                                  _selectedCategoryList,
                                              subCategoryList: [
                                                _selectedSubCategory
                                              ],
                                              description: _descCtrl.text,
                                              comments: [],
                                              likes: [],
                                              reGreams: [],
                                              isBlocked: false,
                                              postUserFullname:
                                                  getUser.fullname,
                                              postUserPhoto: "",
                                              isMalicious: false,
                                              postUserID: getUser.uID,
                                              postTimestamp: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                            ));
                                          } else {}
                                        })),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _postGream(GreamitPost greamitPost) async {
    FirestoreCloudDb()
        .postGream(userID: getUser.uID, greamitPost: greamitPost)
        .then((value) {
      FirestoreCloudDb()
          .increaseGreamitPosts(userID: getUser.uID)
          .then((value) {
        post_a_gream_progress.value = true;
        navigateReplace(context, LandingPage());
      });
    });
  }
}

class DropDownCategorySelectionWidget extends StatefulWidget {
  final Function(bool isChecked, int index) checkBoxClicked;
  final Function doneClicked;

  DropDownCategorySelectionWidget({
    @required this.checkBoxClicked,
    @required this.doneClicked,
  });

  @override
  _DropDownCategorySelectionWidgetState createState() =>
      _DropDownCategorySelectionWidgetState();
}

class _DropDownCategorySelectionWidgetState
    extends State<DropDownCategorySelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'You can select up to 2 categories',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0XFFAAB2BA),
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.doneClicked,
                    child: Text(
                      'Done',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _categoriesCheckboxBool[index],
                        title: Text(_categories[index]),
                        activeColor: kPrimaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) {
                          widget.checkBoxClicked(isChecked, index);
                        });
                  },
                ),
              ),
            ),
            // Scrollbar(
            //   child: Column(
            //     children: List.generate(_categories.length, (index) {
            //       return CheckboxListTile(
            //           contentPadding: EdgeInsets.zero,
            //           value: _categoriesCheckboxBool[index],
            //           title: Text(_categories[index]),
            //           controlAffinity: ListTileControlAffinity.leading,
            //           onChanged: (isChecked) {
            //             setState(() {
            //               _categoriesCheckboxBool[index] = isChecked;
            //             });
            //           });
            //     }),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomDrop extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final String selectedItem;
  final Function(String) onChanged;
  final EdgeInsets contentPadding;

  CustomDrop({
    this.items,
    this.hintText,
    this.selectedItem,
    this.onChanged,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
  });

  @override
  _CustomDropState createState() => _CustomDropState();
}

class _CustomDropState extends State<CustomDrop> {
  bool categoryPicked = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(50.0)),
        child: SizedBox(
          width: deviceWidth,
          /*To hide the default underline of DropdownButton*/
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text(widget.hintText),
              isExpanded: true,
              value: widget.selectedItem,
              onChanged: (dynamic value) {
                widget.onChanged(value);
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          children: [
                            Checkbox(
                              value: categoryPicked,
                              onChanged: (isChecked) {
                                setState(() {
                                  categoryPicked = isChecked;
                                });
                                print(categoryPicked);
                                print(isChecked);
                              },
                            ),
                            Text(value)
                          ],
                        );
                      },
                    ));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/*The length of this list should match _categories length*/
List<bool> _categoriesCheckboxBool = [
  false,
  false,
  false,
  false,
  false,
  false,
];
List<String> _categories = [
  'Food',
  'Music',
  'Fashion',
  'Design',
  'Photography',
  'Furniture',
];
List<String> subCategories = [
  'Food',
  'Music',
  'Fashion',
  'Design',
  'Photography',
  'Furniture',
];
