import 'package:intl/intl.dart';

class Formater {
  static formattage(number){
      // Créez un formateur avec un séparateur de milliers
  NumberFormat formatter = NumberFormat.decimalPattern('fr');
  
  // Formatez le nombre (les décimales inutiles seront supprimées)
  return formatter.format(number);
  }


  static formatdate(dateStr){
    DateTime date = DateTime.parse(dateStr).toLocal(); // <<< ajout du toLocal()
  
  // 2. Formater la date en "dd/MM/yyyy à HH:mm"
  DateFormat dateFormat = DateFormat('le dd/MM/yyyy à HH:mm');
  return dateFormat.format(date);
  }
}