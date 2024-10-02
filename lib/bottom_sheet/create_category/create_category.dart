import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/custom_textfield.dart';
import 'create_category_viewmodel.dart';

class CreateCategoryPage extends StatefulWidget {
  final Function(String label, String icon, Color color) onSave;

  const CreateCategoryPage({Key? key, required this.onSave}) : super(key: key);

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  late CreateCategoryViewModel _viewModel;


  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<CreateCategoryViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,  // This removes the back button
        title: const Text(
          'Create New Category',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Jost',
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _viewModel.nameController,
              hintText: 'Category Name',
              hintTextColor: Color(0xffAFAFAF),
              title: "Category Name:",
              borderRadius: 5,
              borderColor: const Color(0xff979797),
              textFieldColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            const Text(
              'Category Icon:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Icon selection
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _showIconPicker,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: _viewModel.selectedIcon.isEmpty
                          ? const Text(
                        "Choose the icon",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      )
                          : SvgPicture.asset(
                        _viewModel.selectedIcon,
                        height: 30,
                        width: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category Color:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _viewModel.colorOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _viewModel.selectedColor = _viewModel.colorOptions[index];
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _viewModel.colorOptions[index],
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: _viewModel.selectedColor == _viewModel.colorOptions[index]
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(12),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xff8687E7), fontSize: 20)),
                  ),
                ),
                CustomButton(
                  text: 'Create Category',
                  onPressed: () {
                    // Save the new category
                    widget.onSave(_viewModel.nameController.text, _viewModel.selectedIcon, _viewModel.selectedColor);
                   // _showCategorySummary(); // Show the category summary
                  },
                  borderRadius: 5,
                  buttonColor: Color(0xff8687E7),
                  buttonHeight: 50,
                  buttonWidth: 180,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff363636),
      builder: (context) {
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Choose icon from library",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(_viewModel.iconPaths.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _viewModel.selectedIcon = _viewModel.iconPaths[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _viewModel.selectedIcon == _viewModel.iconPaths[index]
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              _viewModel.iconPaths[index],
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showCategorySummary() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.black,
  //         title: Text(
  //           'Category Summary',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               'Category Name: ${_nameController.text}',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             SizedBox(height: 10),
  //             SvgPicture.asset(
  //               _selectedIcon,
  //               height: 40,
  //               width: 40,
  //               color: Colors.white,
  //             ),
  //             SizedBox(height: 10),
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: _selectedColor,
  //                 shape: BoxShape.circle,
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text(
  //               'Close',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
