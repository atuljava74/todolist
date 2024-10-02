import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_sheet/tag_category/tag_category_viewmodel.dart';

import '../../widgets/button_widget.dart';
import '../create_category/create_category.dart';

class TagCategoryDialog extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback parameter to return selected category

  const TagCategoryDialog({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  _TagCategoryDialogState createState() => _TagCategoryDialogState();
}

class _TagCategoryDialogState extends State<TagCategoryDialog> {
  late TagCategoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    Provider.of<TagCategoryViewModel>(context, listen: false).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<TagCategoryViewModel>();

    return AlertDialog(
      backgroundColor: const Color(0xff363636),
      title: const Center(
        child: Column(
          children: [
            Text(
              'Tag Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Divider(
              thickness: 2,
              color: Color(0xff979797),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 40,
                  runSpacing: 15,
                  children: List.generate(_viewModel.imagePaths.length + _viewModel.newCategoryLabels.length, (index) {
                    String label;
                    String imagePath;
                    Color color;

                    // Determine if index is for predefined or new category
                    if (index < _viewModel.imagePaths.length) {
                      label = _viewModel.labels[index];
                      imagePath = _viewModel.imagePaths[index];
                      color = _viewModel.colors[index];
                    } else {
                      int newIndex = index - _viewModel.imagePaths.length; // Adjust for new categories
                      label = _viewModel.newCategoryLabels[newIndex];
                      imagePath = _viewModel.newCategoryIcons[newIndex];
                      color = _viewModel.newCategoryColors[newIndex];
                    }

                    return GestureDetector(
                      onTap: () {
                        _viewModel.selectCategory(index, context); // Update selected category index
                        widget.onCategorySelected(label); // Call the callback
                        print(label);
                        setState(() {}); // Trigger a rebuild to reflect selection
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tagDialog(imagePath, color, isSelected: _viewModel.selectedCategoryIndex == index),
                          const SizedBox(height: 5),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Jost',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                    ..add(createIconContainer()),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: CustomButton(
                text: 'Add Category',
                onPressed: () {
                  if (_viewModel.selectedCategoryIndex != -1) {
                    final selectedLabel = _viewModel.selectedCategoryIndex < _viewModel.labels.length
                        ? _viewModel.labels[_viewModel.selectedCategoryIndex]
                        : _viewModel.newCategoryLabels[_viewModel.selectedCategoryIndex - _viewModel.labels.length];

                    widget.onCategorySelected(selectedLabel);
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a category before adding.")),
                    );
                  }
                },
                buttonColor: const Color(0xff8687E7),
                borderRadius: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tagDialog(String imagePath, Color color, {bool isSelected = false}) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow : color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            imagePath,
            height: 30,
            width: 30,
          ),
        ),
      ),
    );
  }

  Widget createIconContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateCategoryPage(
            onSave: (label, icon, color) {
              _viewModel.addCategory(label, icon, color); // Add the new category to the view model

              // Automatically select the new category
              int newCategoryIndex = _viewModel.newCategoryLabels.length - 1; // New category index
              _viewModel.selectCategory(_viewModel.labels.length + newCategoryIndex, context); // Select the newly created category

              widget.onCategorySelected(label); // Call the callback with the new label
              Navigator.of(context).pop(); // Close the dialog
              setState(() {}); // Trigger a rebuild to reflect the new category
            },
          ),
        ));
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Create New",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'Jost',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
