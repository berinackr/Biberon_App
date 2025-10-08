import 'package:biberon/common/utils/snackbar.dart';
import 'package:flutter/material.dart';

class ForumCategories extends StatelessWidget {
  const ForumCategories({
    this.horizontalPadding = 20,
    super.key,
  });

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            bottom: horizontalPadding / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forum Kategorileri',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // ListView.builder(
        //   itemCount: nuberFromTopForumCategoriesRequest.length,
        //   physics: const BouncingScrollPhysics(),
        //   itemBuilder: (context, index) => ListTile(
        //     title: Text('Kategori $index'),
        //     onTap: () {},
        //   ),
        // ),
        SizedBox(
          height: 90 + 30,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            physics: const BouncingScrollPhysics(),
            children: List.generate(
              10,
              (index) => Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Toast.showToast(
                            context,
                            '${index + 1}. kategoriye tıklandı.',
                            ToastType.success,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 90,
                          width: 90,
                          child: Center(
                            child: Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          '#konu${index.toString() * 5}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
