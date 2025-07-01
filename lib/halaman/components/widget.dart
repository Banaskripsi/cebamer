import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, {String? judul, String? deskripsi}) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left)
            ), l10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul ?? 'Judul',
                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                  ),
                  Text(
                    deskripsi ?? 'Deskripsi',
                    style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

Widget divider(BuildContext context, String label) {
  return Row(
    children: [
      Flexible(
        child: Divider(
          endIndent: 8,
          indent: 0,
          thickness: 2,
          color: primer3,
        ),
      ),
      Text(label),
      Flexible(
        child: Divider(
          endIndent: 0,
          indent: 8,
          thickness: 2,
          color: primer3,
        ),
      )
    ],
  );
}

class Formnya extends StatelessWidget {
  const Formnya({
    super.key,
    required this.controller,
    required this.hintText,
    required this.inputType,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.icon,
    this.fungsi,
    this.isOptional = false,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.labelText,
  });
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType inputType;
  final Widget? prefix;
  final String? prefixText;
  final Widget? suffix;
  final IconData? icon;
  final void Function()? fungsi;
  final bool isOptional;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) { 
          return 'Form ini wajib diisi.';
        }

        if (!isOptional && (inputType == TextInputType.number || inputType == TextInputType.numberWithOptions(decimal: true))) {
          if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
            return 'Harap masukkan angka yang valid.';
          }
        }
        return null;
      },
      keyboardType: inputType,
      onTap: fungsi,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefix: prefix,
        prefixText: prefixText,
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixIconColor: primer1,
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primer3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primer1, width: 2)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: salahInd)
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final String description;
  const Header({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primer2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.chevron_left),
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: Colors.white)),
                  Text(description, style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: Colors.white), textAlign: TextAlign.start,)
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}