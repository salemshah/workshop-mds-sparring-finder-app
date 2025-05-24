import '../profile/profile_model.dart';

class Sparring {
  final int id;
  final int requesterId;
  final int partnerId;
  final int availabilityId;
  final DateTime scheduledDate;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String status;
  final String? notes;
  final DateTime? confirmedAt;
  final int? cancelledByUserId;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Profile? requesterProfile;
  final Profile? partnerProfile;

  Sparring({
    required this.id,
    required this.requesterId,
    required this.partnerId,
    required this.availabilityId,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.status,
    this.notes,
    this.confirmedAt,
    this.cancelledByUserId,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.requesterProfile,
    this.partnerProfile,
  });

  factory Sparring.fromJson(Map<String, dynamic> json) {
    return Sparring(
      id: json['id'],
      requesterId: json['requester_id'],
      partnerId: json['partner_id'],
      availabilityId: json['availability_id'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      location: json['location'],
      status: json['status'],
      notes: json['notes'],
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'])
          : null,
      cancelledByUserId: json['cancelled_by_user_id'],
      cancellationReason: json['cancellation_reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      requesterProfile: json['requesterProfile'] != null
          ? Profile.fromJson(json['requesterProfile'])
          : null,
      partnerProfile: json['partnerProfile'] != null
          ? Profile.fromJson(json['partnerProfile'])
          : null,
    );
  }
}
