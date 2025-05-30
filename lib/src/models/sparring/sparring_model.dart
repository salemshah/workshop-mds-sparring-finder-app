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
      id: json['id'] as int,
      requesterId: json['requester_id'] as int,
      partnerId: json['partner_id'] as int,
      availabilityId: json['availability_id'] as int,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      cancelledByUserId: json['cancelled_by_user_id'] as int?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      requesterProfile: json['requesterProfile'] != null
          ? Profile.fromJson(json['requesterProfile'] as Map<String, dynamic>)
          : null,
      partnerProfile: json['partnerProfile'] != null
          ? Profile.fromJson(json['partnerProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requester_id': requesterId,
      'partner_id': partnerId,
      'availability_id': availabilityId,
      'scheduled_date': scheduledDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'status': status,
      'notes': notes,
      'confirmed_at': confirmedAt?.toIso8601String(),
      'cancelled_by_user_id': cancelledByUserId,
      'cancellation_reason': cancellationReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'requesterProfile': requesterProfile?.toJson(),
      'partnerProfile': partnerProfile?.toJson(),
    };
  }
}
