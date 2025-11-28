// import 'package:flutter/material.dart';
//
// typedef RadioButtonWidgetListener = void Function(dynamic value);
//
// class RadioButtonWidget extends StatefulWidget {
//   final String label;
//   final dynamic selectedValue;
//   final List<RadioItem> itemsList;
//   final bool hideDivider;
//   final RadioButtonWidgetListener listener;
//   final EdgeInsetsGeometry? padding;
//
//   const RadioButtonWidget({
//     Key? key,
//     required this.label,
//     required this.itemsList,
//     required this.selectedValue,
//     this.hideDivider = false,
//     required this.listener,
//     this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 10),
//   }) : super(key: key);
//
//   @override
//   State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
// }
//
// class _RadioButtonWidgetState extends State<RadioButtonWidget> {
//
//   dynamic _selectedValue;
//
//   @override
//   void initState() {
//     _selectedValue = widget.selectedValue;
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: widget.padding,
//       decoration: widget.hideDivider
//           ? null
//           : AppThemePreferences.dividerDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LabelWidget(widget.label),
//           Padding(
//             padding: UtilityMethods.isRTL(context)
//                 ? const EdgeInsets.only(right: 5.0, top: 10.0)
//                 : const EdgeInsets.only(left: 5.0, top: 10.0),
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.itemsList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 RadioItem item = widget.itemsList[index];
//                 String? itemLabel = item.label;
//                 dynamic itemValue = item.value;
//
//                 return RadioButtonWidgetBody(
//                   label: itemLabel!,
//                   value: itemValue,
//                   groupValue: _selectedValue,
//                   onChanged: (value) {
//                     if (mounted) {
//                       setState(() {
//                         _selectedValue = value;
//                         widget.listener(_selectedValue);
//                       });
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RadioButtonWidgetBody extends StatelessWidget {
//   final String label;
//   final dynamic value;
//   final dynamic groupValue;
//   final void Function(dynamic)? onChanged;
//
//   const RadioButtonWidgetBody({
//     Key? key,
//     required this.label,
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Radio(
//           activeColor: AppThemePreferences().appTheme.primaryColor,
//           value: value,
//           groupValue: groupValue,
//           onChanged: onChanged,
//         ),
//         GenericTextWidget(
//           UtilityMethods.getLocalizedString(label),
//           style: AppThemePreferences().appTheme.label01TextStyle,
//         ),
//       ],
//     );
//   }
// }