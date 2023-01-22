import 'package:flutter/cupertino.dart';
import 'package:qr_scan/providers/providers.dart';
import '../models/scan_models.dart';

//Clase manejar bd, Lista ScanModel, descarga las instancias de la base de datos
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';
  
  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if(nouScan.tipus == tipusSeleccionat) {
      scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    //Permite anadir lista en otra lista, anadiendo, no sustituyendo, util para anadir varias
     //this.scans = [...scans]; equivalente en este caso a:
    this.scans = scans;
    notifyListeners();
  }

  carregaScanPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScansByType(tipus);
    this.scans = [...scans];
    tipusSeleccionat = tipus;
    notifyListeners();
  }

  esborraTots() async {
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }
  esborraPerId(int id) async {
    await DBProvider.db.deleteScan(id);
    notifyListeners();
  }

}