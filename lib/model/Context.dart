import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Context {
  String id;
  String name;
  Icon? icon;
  Context({required this.name, this.icon, this.id = ""});

  static Context byName(String name, List<Context> contexts) {
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
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
    };
  }

  // Factory constructor to deserialize a Firestore document into a Context object.
  // We use QueryDocumentSnapshot from the Firestore stream.
  factory Context.fromFirestore(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Context(
      id: doc.id,
      name: data['name'] as String,
      // Check if 'iconCodePoint' exists before trying to access it
      icon: data.containsKey('iconCodePoint')
          ? Icon(
        IconData(
          data['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
      )
          : null,
    );
  }
}

// To be written to the contexts DB if it is empty
List<Context> defaultContexts = [
  Context(name: "Home", icon: Icon(Icons.home)),
  Context(name: "Work", icon: Icon(Icons.business)),
  Context(name: "Phone",icon: Icon(Icons.phone)),
  Context(name: "Email",icon: Icon(Icons.email_rounded)),
  Context(name: 'Default'),
];

// Temporary, until the above-implied code gets written
List<Context> Contexts = [
  Context(name: "Home", icon: Icon(Icons.home)),
  Context(name: "Work", icon: Icon(Icons.business)),
  Context(name: "Phone",icon: Icon(Icons.phone)),
  Context(name: "Email",icon: Icon(Icons.email_rounded)),
  Context(name: "Medical",icon: Icon(Icons.medical_information)),
  Context(name: "Model RR",icon: Icon(Icons.directions_transit)),
  Context(name: "3D Printing"),
  Context(name: "Development",icon: Icon(Icons.computer_rounded)),
  Context(name: "Writing"),
  Context(name: "SysAdmin"),
  Context(name: 'Default'),
];

