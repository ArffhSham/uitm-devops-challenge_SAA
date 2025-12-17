class AnomalyDetector {
  // Rule 1: Too many failed logins
  static bool multipleFailedLogins(List<String> actions) {
    int failedCount =
        actions.where((a) => a == 'LOGIN_FAILED').length;
    return failedCount >= 5;
  }

  // Rule 2: Login at abnormal hour
  static bool abnormalLoginHour(DateTime time) {
    return time.hour < 5 || time.hour > 23;
  }

  // Rule 3: Login from new country
  static bool newCountry(String country) {
    return country == 'Unknown';
  }

  // Overall risk score
  static double calculateRiskScore({
    required bool failedLogins,
    required bool abnormalHour,
    required bool newLocation,
  }) {
    double score = 0.0;

    if (failedLogins) score += 0.4;
    if (abnormalHour) score += 0.3;
    if (newLocation) score += 0.3;

    return score;
  }
}