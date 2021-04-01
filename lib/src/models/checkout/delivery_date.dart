

// To parse this JSON data, do
//
//     final deliveryTime = deliveryTimeFromJson(jsonString);

import 'dart:convert';

DeliveryTime deliveryTimeFromJson(String str) => DeliveryTime.fromJson(json.decode(str));

String deliveryTimeToJson(DeliveryTime data) => json.encode(data.toJson());

class DeliveryTime {
  DeliveryTime({
    this.success,
    this.reservation,
    this.html,
    this.slots,
  });

  bool success;
  bool reservation;
  String html;
  List<Slot> slots;

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
    success: json["success"] == null ? null : json["success"],
    reservation: json["reservation"] == null ? null : json["reservation"],
    html: json["html"] == null ? null : json["html"],
    slots: json["slots"] == null ? null : List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "reservation": reservation == null ? null : reservation,
    "html": html == null ? null : html,
    "slots": slots == null ? null : List<dynamic>.from(slots.map((x) => x.toJson())),
  };
}

class Slot {
  Slot({
    this.timefrom,
    this.timeto,
    this.cutoff,
    this.lockout,
    this.shippingMethods,
    this.fee,
    this.days,
    this.id,
    this.timeId,
    this.formatted,
    this.formattedWithFee,
    this.value,
    this.slotId,
  });

  Time timefrom;
  Time timeto;
  String cutoff;
  String lockout;
  List<String> shippingMethods;
  Fee fee;
  List<String> days;
  int id;
  String timeId;
  String formatted;
  String formattedWithFee;
  String value;
  String slotId;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    timefrom: json["timefrom"] == null ? null : Time.fromJson(json["timefrom"]),
    timeto: json["timeto"] == null ? null : Time.fromJson(json["timeto"]),
    cutoff: json["cutoff"] == null ? null : json["cutoff"],
    lockout: json["lockout"] == null ? null : json["lockout"],
    shippingMethods: json["shipping_methods"] == null ? null : List<String>.from(json["shipping_methods"].map((x) => x)),
    fee: json["fee"] == null ? null : Fee.fromJson(json["fee"]),
    days: json["days"] == null ? null : List<String>.from(json["days"].map((x) => x)),
    id: json["id"] == null ? null : json["id"],
    timeId: json["time_id"] == null ? null : json["time_id"],
    formatted: json["formatted"] == null ? null : json["formatted"],
    formattedWithFee: json["formatted_with_fee"] == null ? null : json["formatted_with_fee"],
    value: json["value"] == null ? null : json["value"],
    slotId: json["slot_id"] == null ? null : json["slot_id"],
  );

  Map<String, dynamic> toJson() => {
    "timefrom": timefrom == null ? null : timefrom.toJson(),
    "timeto": timeto == null ? null : timeto.toJson(),
    "cutoff": cutoff == null ? null : cutoff,
    "lockout": lockout == null ? null : lockout,
    "shipping_methods": shippingMethods == null ? null : List<dynamic>.from(shippingMethods.map((x) => x)),
    "fee": fee == null ? null : fee.toJson(),
    "days": days == null ? null : List<dynamic>.from(days.map((x) => x)),
    "id": id == null ? null : id,
    "time_id": timeId == null ? null : timeId,
    "formatted": formatted == null ? null : formatted,
    "formatted_with_fee": formattedWithFee == null ? null : formattedWithFee,
    "value": value == null ? null : value,
    "slot_id": slotId == null ? null : slotId,
  };
}

class Fee {
  Fee({
    this.value,
    this.formatted,
  });

  String value;
  String formatted;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    value: json["value"] == null ? null : json["value"],
    formatted: json["formatted"] == null ? null : json["formatted"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "formatted": formatted == null ? null : formatted,
  };
}

class Time {
  Time({
    this.time,
    this.stripped,
  });

  String time;
  String stripped;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    time: json["time"] == null ? null : json["time"],
    stripped: json["stripped"] == null ? null : json["stripped"],
  );

  Map<String, dynamic> toJson() => {
    "time": time == null ? null : time,
    "stripped": stripped == null ? null : stripped,
  };
}

DeliveryDate deliveryDateFromJson(String str) => DeliveryDate.fromJson(json.decode(str));

String deliveryDateToJson(DeliveryDate data) => json.encode(data.toJson());

class DeliveryDate {
  DeliveryDate({
    this.success,
    this.bookableDates,
  });

  bool success;
  List<String> bookableDates;

  factory DeliveryDate.fromJson(Map<String, dynamic> json) => DeliveryDate(
    success: json["success"] == null ? null : json["success"],
    bookableDates: json["bookable_dates"] == null ? null : List<String>.from(json["bookable_dates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "bookable_dates": bookableDates == null ? null : List<dynamic>.from(bookableDates.map((x) => x)),
  };
}

