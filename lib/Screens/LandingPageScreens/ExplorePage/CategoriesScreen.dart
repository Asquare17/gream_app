import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/CustomWidgets/Views/category_item.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> _selectedCategories = <String>[];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchEditingController = TextEditingController();

  bool _isSearching = false;

  final List<String> _categories = <String>[
    'Food',
    'Music',
    'Fashion',
    'Design',
    'Photography',
    'Furniture',
  ];

  final List<String> _categoriesDupliate = <String>[
    'Food',
    'Music',
    'Fashion',
    'Design',
    'Photography',
    'Furniture',
  ];

  final List<String> _categories_image = <String>[
    'assets/images/cate_food.png',
    'assets/images/cate_music.png',
    'assets/images/cate_fashion.png',
    'assets/images/cate_design.png',
    'assets/images/cate_photography.png',
    'assets/images/cate_furniture.png',
  ];

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(_categoriesDupliate);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _categories.clear();
        _categories.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _categories.clear();
        _categories.addAll(_categoriesDupliate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomTextField(
              controller: searchEditingController,
              onChanged: (value) {
                setState(() {
                  _isSearching = true;
                });
                filterSearchResults(value);
                if (!_isSearching) {
                  setState(() {
                    value = '';
                  });
                }
              },
              hintText: 'Explore any category',
              suffixIcon: _isSearching
                  ? IconButton(
                      onPressed: () {
                        searchEditingController.clear();
                      },
                      icon: Icon(Icons.cancel),
                      color: Colors.grey,
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: SvgPicture.asset(
                        '$kImagesFolder/search_icon.svg',
                        width: 2.0,
                        height: 2.0,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                physics: NeverScrollableScrollPhysics(),
                children:
                    List<Widget>.generate(_categories.length, (int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryItem(
                      notSelected: appTheme.primaryColor.withOpacity(0.05),
                      selected: appTheme.primaryColor.withOpacity(0.3),
                      cateImage: _categories_image[index],
                      text: _categories[index],
                      isSelected:
                          _selectedCategories.contains(_categories[index]),
                      onSelected: () {},
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {
  final String image;
  final String title;

  const CategoriesCard({Key key, @required this.image, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              height: screenSize.height,
            ),
            Container(
              color: Colors.black12,
            ),
            Positioned(
              bottom: 12.0,
              left: 12.0,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 8.0,
              bottom: 8.0,
              child: CircleAvatar(
                radius: 12.0,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<String> _listOfCategoryName = [
  'Food',
  'Music',
  'Design',
  'Fashion',
  'Fashion',
  'Fashion',
  'Fashion',
  'Technology',
];
