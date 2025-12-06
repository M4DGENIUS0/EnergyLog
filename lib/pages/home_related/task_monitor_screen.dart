import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/no_result_error_widget.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

class TaskMonitorScreen extends StatefulWidget {
  const TaskMonitorScreen({super.key});

  @override
  State<TaskMonitorScreen> createState() => _TaskMonitorScreenState();
}

class _TaskMonitorScreenState extends State<TaskMonitorScreen> {
  List<AppUsageInfo> _infos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUsageStats();
  }

  void _getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 24));
      List<AppUsageInfo> infoList = await AppUsage().getAppUsage(
        startDate,
        endDate,
      );
      setState(() {
        _infos = infoList;
        _infos.sort((a, b) => b.usage.inSeconds.compareTo(a.usage.inSeconds));
        _isLoading = false;
      });
    } catch (exception) {
      debugPrint(exception.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _infos.isEmpty
          ? noResultFoundPage()
          : Column(
              children: [
                if (_infos.isNotEmpty) _buildMostUsedAppCard(_infos.first),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _infos.length,
                    itemBuilder: (context, index) {
                      var info = _infos[index];
                      return Card(
                        color: AppThemePreferences().appTheme.genericInfoCardColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: APP_PRIMARY_COLOR,
                            child: Text(
                              info.appName.isNotEmpty
                                  ? info.appName[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: GenericTextWidget(
                            info.appName,
                            style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle!.copyWith(
                              fontSize: 16
                            ),
                          ),
                          subtitle: GenericTextWidget(
                            info.packageName,
                            style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle,
                          ),
                          trailing: GenericTextWidget(
                            _formatDuration(info.usage),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("nothing_found_app_usage"),
      hideGoBackButton: true,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
  Widget _buildMostUsedAppCard(AppUsageInfo info) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [APP_PRIMARY_COLOR.withOpacity(0.8), APP_PRIMARY_COLOR],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: APP_PRIMARY_COLOR.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(AppThemePreferences.starFilledIcon, color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GenericTextWidget(
                "most_used_apps",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              GenericTextWidget(
                info.appName,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              GenericTextWidget(
                _formatDuration(info.usage),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m";
  }
}
