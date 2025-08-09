import 'package:flutter/material.dart';

class Context {
  String name;
  Icon? icon;
  Context(this.name, this.icon);

  static Context byName(String name) {
    Context c = contexts[0];
    for (c in contexts) {
      if (c.name == name) {
        return c;
      }
    }
    return c; // At this point it'll be the last one
  }
}

List<Context> contexts = [
  Context("Home", Icon(Icons.home)),
  Context("Work", Icon(Icons.business)),
  Context("Phone",Icon(Icons.phone)),
  Context("Email",Icon(Icons.email_rounded)),
  Context("Medical",Icon(Icons.medical_information)),
  Context("Model RR",Icon(Icons.directions_transit)),
  Context("3D Printing", null),
  Context("Development",Icon(Icons.computer_rounded)),
  Context("Writing", null),
  Context("SysAdmin", null),
  Context('Default', null),
];


