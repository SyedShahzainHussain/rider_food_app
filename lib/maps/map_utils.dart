import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static void launchMapFromSourceToDestiantion(
      sourcelat, sourcelng, deslat, deslng) async {
    String option = [
      "saddr=$sourcelat,$sourcelng",
      "daddr=$deslat,$deslng",
      "dir_action=navigate"
    ].join("&");
    final mapUrl = "https://www.google.com/maps?$option";

    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    } else {
      throw "Could not launched $mapUrl";
    }
  }
}
