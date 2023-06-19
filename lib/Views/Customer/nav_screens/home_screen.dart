import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/widgets/banner_widget.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/widgets/category_widget.dart';

import 'package:sokomoja_project/Views/Customer/nav_screens/widgets/search_input_widget.dart';

import 'widgets/welcome_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeText(),
        SizedBox(
          height: 15,
        ),
        SearchInput(),
        BannerWidget(),
        CategoryText(),
      ],
    );
  }
}
