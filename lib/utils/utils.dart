import 'package:flutter/cupertino.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:url_launcher/url_launcher_string.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;

  if(scan.tipus == 'http') {
    if(!await launchUrlString(url)) throw 'could not launch $url';
  }
  else{
    Navigator.pushNamed(context, 'mapa', arguments: scan);

  }
}