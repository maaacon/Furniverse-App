import 'package:flutter/material.dart';

// COLORS

const backgroundColor = Color(0xFFF0F0F0);
const foregroundColor = Color(0xFF43464B);
const borderColor = Color(0xFFA9ADB2);
var outlineInputBorder = ({required label}) => InputDecoration(
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      labelText: label,
    );
const imagePlaceholder = "http://via.placeholder.com/350x150";
