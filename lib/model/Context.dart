import 'package:flutter/material.dart';

class Context {
  String id;
  String name;
  Icon? icon;
  Context(this.name, {this.icon, this.id = 0});

  static Context byName(String name) {
    Context c = contexts[0];
    for (c in contexts) {
      if (c.name == name) {
        return c;
      }
    }
    return c; // At this point it'll be the last one
  }

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as Icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

List<Context> contexts = [
  Context("Home", icon: Icon(Icons.home)),
  Context("Work", icon: Icon(Icons.business)),
  Context("Phone",icon: Icon(Icons.phone)),
  Context("Email",icon: Icon(Icons.email_rounded)),
  Context("Medical",icon: Icon(Icons.medical_information)),
  Context("Model RR",icon: Icon(Icons.directions_transit)),
  Context("3D Printing"),
  Context("Development",icon: Icon(Icons.computer_rounded)),
  Context("Writing"),
  Context("SysAdmin"),
  Context('Default'),
];


