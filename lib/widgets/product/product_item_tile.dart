import 'package:flutter/material.dart';

import '../../common/tools.dart';
import '../../models/index.dart' show Product, ProductAttribute;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../services/services.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show
    CartButton,
    CartIcon,
    CartQuantity,
    HeartButton,
    ProductPricing,
    ProductRating,
    ProductTitle,
    StockStatus,
    StoreName;

class ProductItemTileView extends StatelessWidget with ActionButtonMixin {
  final Product item;
  final EdgeInsets? padding;
  final ProductConfig config;

  const ProductItemTileView({
    required this.item,
    this.padding,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    String? calories;
    for (var attribute in item.attributes ?? []) {
      if (attribute.name?.toLowerCase() == 'calories') {
        print('Attribute: ${attribute.name}, Options: ${attribute.options}');
        if (attribute.options != null && attribute.options!.isNotEmpty) {
          var option = attribute.options!.first;
          if (option is Map<String, dynamic>) {
            var rawCalories = option['name']?.toString();
            if (rawCalories != null) {
              calories = _extractCalories(rawCalories);
            }
          } else if (option is String) {
            calories = _extractCalories(option);
          }
        }
        break;
      }
    }

    return Container(
      child: InkWell(
        onTap: () => onTapProduct(context, product: item, config: config),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 8),
                // Image Section
                Flexible(
                  flex: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: getImageFeature(
                                () => onTapProduct(context, product: item, config: config),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text Section
                Flexible(
                  flex: 3,
                  child: _ProductDescription(
                    item: item,
                    config: config,
                  ),
                ),
                // Calories Section// تحقق إذا كانت السعرات الحرارية موجودة
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit,size: 15),
                            onPressed: () {
                              onTapProduct(context, product: item, config: config);
                            },
                          ),
                        ),
                      ),
                      Text(
                        '$calories Cal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة لاستخراج السعرات الحرارية وتنظيف النص
  String _extractCalories(String rawCalories) {
    // إزالة الصيغة الخاصة مثل [:en] والنصوص المشابهة
    final regex = RegExp(r'\[\:.*?\]|\[.*?\]');
    return rawCalories.replaceAll(regex, '').trim();
  }

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: Image.network(
        item.imageFeature ?? '',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  final ProductConfig config;
  final Product item;

  const _ProductDescription({
    required this.config,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: config.hPadding,
        vertical: config.vPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (item.categoryName != null)
            Text(
              item.categoryName!.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ProductTitle(
              product: item,
              hide: config.hideTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
              maxLines: config.titleLine,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description ?? '',
            maxLines: 1,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
