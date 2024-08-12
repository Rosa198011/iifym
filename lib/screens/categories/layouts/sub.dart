import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Category, CategoryModel;
import '../../../models/category/category_model.dart';
import '../../base_screen.dart';
import '../widgets/fetch_product_layout.dart';

class SubCategories extends StatelessWidget {
  /// Not support enableLargeCategory
  static const String type = 'subCategories';

  final ScrollController? scrollController;

  const SubCategories({
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SubCategoriesLayout(
      scrollController: scrollController,
    );
  }
}

class SubCategoriesLayout extends StatefulWidget {
  final ScrollController? scrollController;

  const SubCategoriesLayout({
    this.scrollController,
    super.key,
  });

  @override
  BaseScreen<SubCategoriesLayout> createState() => _StateSubCategoriesLayout();
}

class _StateSubCategoriesLayout extends BaseScreen<SubCategoriesLayout> {
  int selectedIndex = 0;
  int _numberOfTabPreload = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CategoryModel>(
      builder: (context, provider, child) {
        final categories = provider.categories?.where((category) {
          return category.name != 'Packages' &&
              category.name != 'Prefrences' &&
              category.name != 'Subscription';
        }).toList() ?? <Category>[];

        if (categories.isEmpty) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }

        if (categories.length <= selectedIndex) {
          selectedIndex = categories.length - 1;
        }

        return Column(
          children: <Widget>[
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Text(
                          categories[index].name!,
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedIndex == index
                                ? theme.primaryColor
                                : theme.hintColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Builder(
                builder: (context) {
                  if (categories[selectedIndex].image != null && categories[selectedIndex].image!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(categories[selectedIndex].image!)),
                    );
                  } else {
                    return Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/800px-Good_Food_Display_-_NCI_Visuals_Online.jpg');
                  }
                }
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  var category = categories[selectedIndex];
                  return FetchProductLayout(
                    key: Key(category.toString()),
                    category: category,
                    scrollController: widget.scrollController,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
