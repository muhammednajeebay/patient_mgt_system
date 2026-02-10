import 'package:patient_mgt_system/data/models/patient_list.dart';

class TreatmentList {
    final bool? status;
    final String? message;
    final List<Treatment>? treatments;

    TreatmentList({
        this.status,
        this.message,
        this.treatments,
    });

    TreatmentList copyWith({
        bool? status,
        String? message,
        List<Treatment>? treatments,
    }) => 
        TreatmentList(
            status: status ?? this.status,
            message: message ?? this.message,
            treatments: treatments ?? this.treatments,
        );

    factory TreatmentList.fromJson(Map<String, dynamic> json) => TreatmentList(
        status: json["status"],
        message: json["message"],
        treatments: json["treatments"] == null ? [] : List<Treatment>.from(json["treatments"]!.map((x) => Treatment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "treatments": treatments == null ? [] : List<dynamic>.from(treatments!.map((x) => x.toJson())),
    };
}

class Treatment {
    final int? id;
    final List<Branch>? branches;
    final String? name;
    final String? duration;
    final String? price;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Treatment({
        this.id,
        this.branches,
        this.name,
        this.duration,
        this.price,
        this.isActive,
        this.createdAt,
        this.updatedAt,
    });

    Treatment copyWith({
        int? id,
        List<Branch>? branches,
        String? name,
        String? duration,
        String? price,
        bool? isActive,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Treatment(
            id: id ?? this.id,
            branches: branches ?? this.branches,
            name: name ?? this.name,
            duration: duration ?? this.duration,
            price: price ?? this.price,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        id: json["id"],
        branches: json["branches"] == null ? [] : List<Branch>.from(json["branches"]!.map((x) => Branch.fromJson(x))),
        name: json["name"],
        duration: json["duration"],
        price: json["price"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "branches": branches == null ? [] : List<dynamic>.from(branches!.map((x) => x.toJson())),
        "name": name,
        "duration": duration,
        "price": price,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
