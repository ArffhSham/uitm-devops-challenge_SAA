enum AgreementStatus { PENDING, SIGNED, ACTIVE, EXPIRED, CANCELLED }

// Model for a full rental agreement
class AgreementModel {
  final String id;
  final String tenantId;
  final String propertyId;
  final String rentalDetails;
  final AgreementStatus status;
  final String hashChecksum; // Cryptographic integrity check

  AgreementModel({
    required this.id,
    required this.tenantId,
    required this.propertyId,
    required this.rentalDetails,
    required this.status,
    required this.hashChecksum,
  });
}