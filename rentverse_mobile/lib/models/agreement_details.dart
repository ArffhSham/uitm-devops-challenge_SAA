import 'dart:convert';

class AgreementDetails {
  final String agreementId;
  final String documentHash;
  final String documentText;

  AgreementDetails({
    required this.agreementId,
    required this.documentHash,
    required this.documentText,
  });

  // Factory method to handle incoming data from API
  factory AgreementDetails.fromJson(Map<String, dynamic> json) {
    return AgreementDetails(
      agreementId: json['id']?.toString() ?? '',
      documentHash: json['documentHash'] ?? '',
      // If documentText is missing, generate it from the raw JSON
      documentText: json['documentText'] ?? _generateAgreementHtml(json),
    );
  }

  // ADDED: This fixes the 'toJson' isn't defined error in api_service.dart
  Map<String, dynamic> toJson() {
    return {
      'id': agreementId,
      'documentHash': documentHash,
      'documentText': documentText,
    };
  }

  static String _generateAgreementHtml(Map<String, dynamic> data) {
    // Extracting variables first prevents the "raw code" rendering issue
    // because complex lookups like ${data['lease']['rent']} often fail inside large strings.
    final lease = data['lease'] ?? data;
    final landlord = lease['landlord'] ?? {};
    final tenant = lease['tenant'] ?? {};
    final property = lease['property'] ?? {};
    final signatures = data['signatures'] ?? {};

    final agreementNo = data['id'] ?? 'N/A';
    final landlordName = landlord['name'] ?? data['landlordName'] ?? 'N/A';
    final tenantName = tenant['name'] ?? data['tenantName'] ?? 'N/A';
    final address = property['address'] ?? 'N/A';
    final currency = lease['currencyCode'] ?? data['currency'] ?? 'USD';
    final rentAmount =
        lease['rentAmount']?.toString() ?? data['amount']?.toString() ?? '0.00';

    return """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: 'Times New Roman', serif; line-height: 1.6; padding: 20px; color: #333; background: white; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px; }
        .title { font-size: 22px; font-weight: bold; text-transform: uppercase; }
        .section { margin-bottom: 20px; }
        .section-title { font-weight: bold; text-decoration: underline; margin-bottom: 10px; }
        .highlight { background-color: #fff3cd; padding: 2px 4px; font-weight: bold; }
        .signature-section { margin-top: 40px; display: flex; justify-content: space-between; }
        .signature-box { flex: 1; text-align: center; }
        .signature-line { border-bottom: 2px solid #333; height: 50px; margin: 0 20px 10px 20px; }
        .qr-code img { max-width: 80px; height: auto; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="title">Residential Rental Agreement</div>
            <p><strong>Agreement No:</strong> <span class="highlight">$agreementNo</span></p>
        </div>

        <div class="section">
            <div class="section-title">1. THE PARTIES</div>
            <p><strong>Lessor:</strong> <span class="highlight">$landlordName</span></p>
            <p><strong>Lessee:</strong> <span class="highlight">$tenantName</span></p>
        </div>

        <div class="section">
            <div class="section-title">2. PREMISES</div>
            <p>Located at: <span class="highlight">$address</span></p>
        </div>

        <div class="section">
            <div class="section-title">4. RENT</div>
            <p>Monthly Rent: <span class="highlight">$currency $rentAmount</span></p>
        </div>

        <div class="signature-section">
            <div class="signature-box">
                <p><strong>LESSOR</strong></p>
                ${signatures['landlord']?['qrCode'] != null ? '<div class="qr-code"><img src="${signatures['landlord']['qrCode']}" /></div>' : '<div class="signature-line"></div>'}
                <p>$landlordName</p>
            </div>

            <div class="signature-box">
                <p><strong>LESSEE</strong></p>
                ${signatures['tenant']?['qrCode'] != null ? '<div class="qr-code"><img src="${signatures['tenant']['qrCode']}" /></div>' : '<div class="signature-line"></div>'}
                <p>$tenantName</p>
            </div>
        </div>
    </div>
</body>
</html>
""";
  }
}