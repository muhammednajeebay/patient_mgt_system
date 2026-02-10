class PatientList {
    final bool? status;
    final String? message;
    final List<Patient>? patient;

    PatientList({
        this.status,
        this.message,
        this.patient,
    });

    PatientList copyWith({
        bool? status,
        String? message,
        List<Patient>? patient,
    }) => 
        PatientList(
            status: status ?? this.status,
            message: message ?? this.message,
            patient: patient ?? this.patient,
        );

    factory PatientList.fromJson(Map<String, dynamic> json) => PatientList(
        status: json["status"],
        message: json["message"],
        patient: json["patient"] == null ? [] : List<Patient>.from(json["patient"]!.map((x) => Patient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "patient": patient == null ? [] : List<dynamic>.from(patient!.map((x) => x.toJson())),
    };
}

class Patient {
    final int? id;
    final List<PatientdetailsSet>? patientdetailsSet;
    final Branch? branch;
    final String? user;
    final String? payment;
    final String? name;
    final String? phone;
    final String? address;
    final dynamic price;
    final int? totalAmount;
    final int? discountAmount;
    final int? advanceAmount;
    final int? balanceAmount;
    final DateTime? dateNdTime;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Patient({
        this.id,
        this.patientdetailsSet,
        this.branch,
        this.user,
        this.payment,
        this.name,
        this.phone,
        this.address,
        this.price,
        this.totalAmount,
        this.discountAmount,
        this.advanceAmount,
        this.balanceAmount,
        this.dateNdTime,
        this.isActive,
        this.createdAt,
        this.updatedAt,
    });

    Patient copyWith({
        int? id,
        List<PatientdetailsSet>? patientdetailsSet,
        Branch? branch,
        String? user,
        String? payment,
        String? name,
        String? phone,
        String? address,
        dynamic price,
        int? totalAmount,
        int? discountAmount,
        int? advanceAmount,
        int? balanceAmount,
        DateTime? dateNdTime,
        bool? isActive,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Patient(
            id: id ?? this.id,
            patientdetailsSet: patientdetailsSet ?? this.patientdetailsSet,
            branch: branch ?? this.branch,
            user: user ?? this.user,
            payment: payment ?? this.payment,
            name: name ?? this.name,
            phone: phone ?? this.phone,
            address: address ?? this.address,
            price: price ?? this.price,
            totalAmount: totalAmount ?? this.totalAmount,
            discountAmount: discountAmount ?? this.discountAmount,
            advanceAmount: advanceAmount ?? this.advanceAmount,
            balanceAmount: balanceAmount ?? this.balanceAmount,
            dateNdTime: dateNdTime ?? this.dateNdTime,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        patientdetailsSet: json["patientdetails_set"] == null ? [] : List<PatientdetailsSet>.from(json["patientdetails_set"]!.map((x) => PatientdetailsSet.fromJson(x))),
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        user: json["user"],
        payment: json["payment"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        price: json["price"],
        totalAmount: json["total_amount"],
        discountAmount: json["discount_amount"],
        advanceAmount: json["advance_amount"],
        balanceAmount: json["balance_amount"],
        dateNdTime: json["date_nd_time"] == null ? null : DateTime.parse(json["date_nd_time"]),
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "patientdetails_set": patientdetailsSet == null ? [] : List<dynamic>.from(patientdetailsSet!.map((x) => x.toJson())),
        "branch": branch?.toJson(),
        "user": user,
        "payment": payment,
        "name": name,
        "phone": phone,
        "address": address,
        "price": price,
        "total_amount": totalAmount,
        "discount_amount": discountAmount,
        "advance_amount": advanceAmount,
        "balance_amount": balanceAmount,
        "date_nd_time": dateNdTime?.toIso8601String(),
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Branch {
    final int? id;
    final Name? name;
    final int? patientsCount;
    final Location? location;
    final Phone? phone;
    final Mail? mail;
    final Address? address;
    final String? gst;
    final bool? isActive;

    Branch({
        this.id,
        this.name,
        this.patientsCount,
        this.location,
        this.phone,
        this.mail,
        this.address,
        this.gst,
        this.isActive,
    });

    Branch copyWith({
        int? id,
        Name? name,
        int? patientsCount,
        Location? location,
        Phone? phone,
        Mail? mail,
        Address? address,
        String? gst,
        bool? isActive,
    }) => 
        Branch(
            id: id ?? this.id,
            name: name ?? this.name,
            patientsCount: patientsCount ?? this.patientsCount,
            location: location ?? this.location,
            phone: phone ?? this.phone,
            mail: mail ?? this.mail,
            address: address ?? this.address,
            gst: gst ?? this.gst,
            isActive: isActive ?? this.isActive,
        );

    factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: nameValues.map[json["name"]]!,
        patientsCount: json["patients_count"],
        location: locationValues.map[json["location"]]!,
        phone: phoneValues.map[json["phone"]]!,
        mail: mailValues.map[json["mail"]]!,
        address: addressValues.map[json["address"]]!,
        gst: json["gst"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "patients_count": patientsCount,
        "location": locationValues.reverse[location],
        "phone": phoneValues.reverse[phone],
        "mail": mailValues.reverse[mail],
        "address": addressValues.reverse[address],
        "gst": gst,
        "is_active": isActive,
    };
}

enum Address {
    KOCHI_KERALA_685565,
    KOTTAYAM_KERALA_6865636,
    KOZHIKODE
}

final addressValues = EnumValues({
    "Kochi, Kerala-685565": Address.KOCHI_KERALA_685565,
    "Kottayam, Kerala-6865636": Address.KOTTAYAM_KERALA_6865636,
    "Kozhikode": Address.KOZHIKODE
});

enum Location {
    KOCHI_KERALA,
    KOZHIKODE,
    KUMARAKOM
}

final locationValues = EnumValues({
    "Kochi,kerala": Location.KOCHI_KERALA,
    "Kozhikode": Location.KOZHIKODE,
    "Kumarakom": Location.KUMARAKOM
});

enum Mail {
    USER123_GMAIL_COM,
    USER123_GMAIL_COMM
}

final mailValues = EnumValues({
    "user123@gmail.com": Mail.USER123_GMAIL_COM,
    "user123@gmail.comm": Mail.USER123_GMAIL_COMM
});

enum Name {
    EDAPPALI,
    KUMARAKOM,
    NADAKKAVU,
    THONDAYADU
}

final nameValues = EnumValues({
    "Edappali": Name.EDAPPALI,
    "KUMARAKOM": Name.KUMARAKOM,
    "Nadakkavu": Name.NADAKKAVU,
    "Thondayadu": Name.THONDAYADU
});

enum Phone {
    THE_9846123456,
    THE_9946331452,
    THE_99463314529747331452
}

final phoneValues = EnumValues({
    "9846123456": Phone.THE_9846123456,
    "9946331452, ": Phone.THE_9946331452,
    "9946331452,9747331452": Phone.THE_99463314529747331452
});

class PatientdetailsSet {
    final int? id;
    final String? male;
    final String? female;
    final int? patient;
    final int? treatment;
    final String? treatmentName;

    PatientdetailsSet({
        this.id,
        this.male,
        this.female,
        this.patient,
        this.treatment,
        this.treatmentName,
    });

    PatientdetailsSet copyWith({
        int? id,
        String? male,
        String? female,
        int? patient,
        int? treatment,
        String? treatmentName,
    }) => 
        PatientdetailsSet(
            id: id ?? this.id,
            male: male ?? this.male,
            female: female ?? this.female,
            patient: patient ?? this.patient,
            treatment: treatment ?? this.treatment,
            treatmentName: treatmentName ?? this.treatmentName,
        );

    factory PatientdetailsSet.fromJson(Map<String, dynamic> json) => PatientdetailsSet(
        id: json["id"],
        male: json["male"],
        female: json["female"],
        patient: json["patient"],
        treatment: json["treatment"],
        treatmentName: json["treatment_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "male": male,
        "female": female,
        "patient": patient,
        "treatment": treatment,
        "treatment_name": treatmentName,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
