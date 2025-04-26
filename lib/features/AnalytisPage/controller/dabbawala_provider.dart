import 'package:dabbawala/features/AnalytisPage/models/analytic_model.dart';

class DabbawalaDataProvider {
  static List<DabbawalaStat> getMonthlyStats() {
    return [
      DabbawalaStat(month: 'Jan', income: 15000, customerCount: 42),
      DabbawalaStat(month: 'Feb', income: 16500, customerCount: 45),
      DabbawalaStat(month: 'Mar', income: 14200, customerCount: 38),
      DabbawalaStat(month: 'Apr', income: 16800, customerCount: 46),
      DabbawalaStat(month: 'May', income: 18200, customerCount: 50),
      DabbawalaStat(month: 'Jun', income: 17400, customerCount: 48),
      DabbawalaStat(month: 'Jul', income: 19000, customerCount: 52),
      DabbawalaStat(month: 'Aug', income: 20500, customerCount: 56),
      DabbawalaStat(month: 'Sep', income: 19800, customerCount: 54),
      DabbawalaStat(month: 'Oct', income: 21000, customerCount: 58),
      DabbawalaStat(month: 'Nov', income: 22500, customerCount: 62),
      DabbawalaStat(month: 'Dec', income: 24000, customerCount: 65),
    ];
  }
}
