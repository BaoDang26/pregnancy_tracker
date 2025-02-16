class FractionUtils {
  static String decimalToFractionString(double decimal) {
    // Chuyển đổi số âm thành dương
    int sign = decimal < 0 ? -1 : 1;
    decimal = decimal.abs();

    // Độ chính xác
    double tolerance = 1.0E-6;

    // Biến phân liên tục
    int h1 = 1, h2 = 0;
    int k1 = 0, k2 = 1;
    double b = decimal;

    // Tính toán
    do {
      int a = b.floor();
      int aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      b = 1 / (b - a);
    } while ((decimal - h1 / k1).abs() > decimal * tolerance);

    // Kết quả
    return '${sign * h1}/${k1}';
  }
}
