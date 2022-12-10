import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:need_to/controller/cart_controller.dart';
import 'package:need_to/controller/category_controller.dart';
import 'package:need_to/controller/data_controller.dart';
import 'package:need_to/view/cart_page.dart';
import 'package:need_to/view/variations_screen.dart';

import '../models/user_model.dart';
import '../util/menu_item_card.dart';

class CategoriesScreen extends StatefulWidget {
  Product? model;
  BuildContext? context;
  CategoriesScreen({super.key, this.model, this.context});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  String search = "94";
  var addButtonVisibility;
  var moreOptionsVisibility;

  //CategoryController dependency injection//=========================
  CategoryController categoryController = Get.find();
  DataController dataController = Get.find();
  CartController cartController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => CartPage());
            },
            child: Badge(
                toAnimate: true,
                animationType: BadgeAnimationType.scale,
                position: BadgePosition.topEnd(top: 15, end: 40),
                elevation: 0,
                badgeContent: Obx(
                  () => Text(
                    cartController.numberOfItemsInCart.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                ),
                child: Icon(
                  Icons.shopping_cart_checkout,
                  size: 40,
                )),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(
        () => dataController.isHomePageDataLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Explore menu",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  print(
                                    categoryController
                                        .categoryList!.data![index].catId,
                                  );
                                  setState(() {
                                    search = categoryController
                                        .categoryList!.data![index].catId
                                        .toString();
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  child: Center(
                                    child: Text(categoryController
                                        .categoryList!.data![index].catName!),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount:
                                categoryController.categoryList!.data!.length)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: dataController
                              .userList!.data!.bestsellerProducts!.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool addButtonVisibility = false;
                            var currentProduct = dataController
                                .userList!.data!.bestsellerProducts![index];

                            late String catgeryIId = dataController.userList!
                                .data!.bestsellerProducts![index].categoryId
                                .toString();
                            if (currentProduct.variations == null) {
                              addButtonVisibility = true;
                              moreOptionsVisibility = false;
                            } else {
                              moreOptionsVisibility = true;
                            }
                            if (catgeryIId
                                .toString()
                                .contains(search.toString())) {
                              return currentProduct.variations == null
                                  ? menuitemCard(
                                      moreOptionsVisibility:
                                          moreOptionsVisibility,
                                      addButtonVisibility: addButtonVisibility,
                                      index: index,
                                      dataController: dataController,
                                      variationdClickHandler: () {
                                        if (currentProduct.variations != null) {
                                          // Get.to(() => VariationScreen(
                                          //       indexx: index,
                                          //     ));
                                        } else {}

                                        print(currentProduct.variations);
                                      },
                                    )

                                  /// variation scroller
                                  : Container(
                                      height: 240,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 250, 250),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  currentProduct.name!,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 120,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            currentProduct
                                                                .image!),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12)),
                                                  ),
                                                ),
                                                Container(
                                                    width: 300,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                      color: Color.fromARGB(
                                                          255, 250, 217, 217),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              currentProduct
                                                                  .variations![
                                                                      index]
                                                                  .title!,
                                                              style: TextStyle(
                                                                  fontSize: 22),
                                                            ),
                                                            Text(
                                                              "Rs: ${currentProduct.variations![index].price.toString()}",
                                                              style: TextStyle(
                                                                  fontSize: 22),
                                                            )
                                                          ],
                                                        ),
                                                        ElevatedButton(
                                                          // add to cat button/============
                                                          onPressed: () {
                                                            print(currentProduct
                                                                .variations![
                                                                    index]
                                                                .title);
                                                            cartController
                                                                .additemToCart(
                                                              currentProduct,
                                                              index,
                                                            );
                                                          },
                                                          child: Text(
                                                            "add",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 10,
                                            );
                                          },
                                          itemCount: currentProduct
                                              .variations!.length),
                                    );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
