import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/appbar_widget.dart';

class SettingsScreenPage extends StatefulWidget {
  const SettingsScreenPage({super.key});

  @override
  State<SettingsScreenPage> createState() => _SettingsScreenPageState();
}

class _SettingsScreenPageState extends State<SettingsScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Settings',
        leftWidget: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
        rightWidget: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            const Text(
              "Settings",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Jost',
                color: Color(0xffAFAFAF),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            settingsItems("Change app color","assets/brush.svg"),
            const SizedBox(height: 18),
            settingsItems("Change app typography","assets/text.svg"),
            const SizedBox(height: 18),
            settingsItems("Change app language","assets/language.svg"),
            const SizedBox(height: 22),
            const Text(
              "Import",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Jost',
                color: Color(0xffAFAFAF),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            settingsItems("Import from Google calendar","assets/import.svg"),
          ],
        ),
      ),
    );
  }
  settingsItems(String text,String imagePath) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                SvgPicture.asset(imagePath, height: 25, width: 25),
                //Icon(icon,color: Colors.white,),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: const Icon(Icons.chevron_right,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}
