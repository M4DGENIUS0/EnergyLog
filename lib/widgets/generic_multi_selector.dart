import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';


typedef GenericMultiSelectWidgetListener = void Function(List<String> selectedItems);

class GenericMultiSelectWidget extends StatefulWidget {
  final List<String> dataList;
  final List<String> selectedDataList;
  final GenericMultiSelectWidgetListener listener;

  const GenericMultiSelectWidget({
    Key? key,
    required this.dataList,
    required this.selectedDataList,
    required this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericMultiSelectWidgetState();
}

class GenericMultiSelectWidgetState extends State<GenericMultiSelectWidget> {
  List<String> _dataItemsList = [];
  List<String> _selectedItemsList = [];

  @override
  void initState() {
    super.initState();
    _dataItemsList = widget.dataList;
    _selectedItemsList = List.from(widget.selectedDataList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _dataItemsList.map((item) {
        final checked = _selectedItemsList.contains(item);

        return CheckboxListTile(
          activeColor: AppThemePreferences().appTheme.primaryColor,
          checkColor: AppThemePreferences().appTheme.backgroundColor,
          selectedTileColor: AppThemePreferences().appTheme.selectedItemBackgroundColor,
          value: checked,
          title: GenericTextWidget(
            UtilityMethods.getLocalizedString(item),
              strutStyle:  StrutStyle(
                height: AppThemePreferences.genericTextHeight,
              )
          ),
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (checked) => _onItemCheckedChange(item, checked ?? false),
        );
      }).toList(),
    );
  }

  void _onItemCheckedChange(String item, bool checked) {
    if (mounted) {
      setState(() {
        if (checked) {
          _selectedItemsList.add(item);
        } else {
          _selectedItemsList.remove(item);
        }
        // Notify listener on every change
        widget.listener(_selectedItemsList);
      });
    }
  }
}