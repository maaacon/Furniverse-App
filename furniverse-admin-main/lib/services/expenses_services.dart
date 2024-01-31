import 'package:furniverse_admin/services/color_services.dart';
import 'package:furniverse_admin/services/materials_services.dart';

class ExpenseServices {
  Future<double> getTotalExpenses(int year) async {
    double totalExpenses = await ColorService().getTotalExpense(year) +
        await MaterialsServices().getTotalExpense(year);

    print(totalExpenses);
    return totalExpenses;
  }
}
