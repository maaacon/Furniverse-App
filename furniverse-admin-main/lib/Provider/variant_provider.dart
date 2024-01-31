import 'package:furniverse_admin/models/edit_product_variants_model.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/services/upload_image_services.dart';
import 'package:furniverse_admin/services/upload_model_services.dart';
import 'package:flutter/material.dart';

class VariantsProvider extends ChangeNotifier {
  final List<ProductVariants> _variant = [];
  List<ProductVariants> get variant => _variant;
  final List<EditProductVariants> _oldvariants = [];
  List<EditProductVariants> get oldvariants => _oldvariants;

  void addVariant(ProductVariants productVariants) {
    _variant.add(productVariants);

    notifyListeners();
  }

  void addOldVariant(EditProductVariants editProductVariants) {
    _oldvariants.add(editProductVariants);
  }

  void removeVariant(ProductVariants productVariants) {
    _variant.remove(productVariants);

    notifyListeners();
  }

  void clearVariant() {
    _variant.clear();
  }

  void clearOldVariant() {
    _oldvariants.clear();
  }

  void updateVariant(
    ProductVariants productVariants,
    ProductVariants newVariant,
  ) {
    int indexOfValue = _variant.indexOf(productVariants);
    if (indexOfValue != -1) {
      // Check if the value exists in the list
      _variant[indexOfValue] =
          newVariant; // Replace the value with the new value
    } else {
      // Handle the case where the value is not found in the list
      print("Value $productVariants not found in the list.");
    }

    notifyListeners();
  }

  void updateOldVariants(
    EditProductVariants productVariants,
    EditProductVariants newVariant,
  ) {
    int indexOfValue = _oldvariants.indexOf(productVariants);
    if (indexOfValue != -1) {
      // Check if the value exists in the list
      _oldvariants[indexOfValue] =
          newVariant; // Replace the value with the new value
    } else {
      // Handle the case where the value is not found in the list
      print("Value $productVariants not found in the list.");
    }

    notifyListeners();
  }

  List<String> getToDeleteFiles() {
    List<String> toDeleteFiles = [];

    for (EditProductVariants variant in _oldvariants) {
      if (variant.selectedNewImage != null) {
        toDeleteFiles.add(variant.image);
      }
      if (variant.selectedNewModel != null) {
        toDeleteFiles.add(variant.model);
      }
    }

    return toDeleteFiles;
  }

  Future<List<Map<String, dynamic>>> getMap() async {
    List<Map<String, dynamic>> productMaps = [];

    for (EditProductVariants variant in _oldvariants) {
      String? imageReference = variant.image;
      String? modelReference = variant.model;

      if (variant.selectedNewImage != null) {
        imageReference =
            await uploadVariantImageToFirebase(variant.selectedNewImage);
      }
      if (variant.selectedNewModel != null) {
        modelReference = await uploadModelToFirebase(variant.selectedNewModel);
      }

      productMaps.add({
        'variant_name': variant.variantName,
        'material': variant.material,
        'length': variant.length,
        'width': variant.width,
        'height': variant.height,
        'metric': variant.metric,
        'color': variant.color,
        'price': variant.price,
        'stocks': variant.stocks,
        'image': imageReference,
        'model': modelReference,
        'id': variant.id,
      });
    }

    for (ProductVariants product in _variant) {
      String? imageReference = '';
      String? modelReference = '';

      imageReference = await uploadVariantImageToFirebase(product.image);

      // final imageFile = product.image!;
      // final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final imageTask = storage.ref().child('images/$imageFileName').putFile(imageFile);
      // await imageTask.whenComplete(() async {
      //   imageReference = await imageTask.snapshot.ref.getDownloadURL();
      // });

      modelReference = await uploadModelToFirebase(product.model);

      // if (product.modelFile != null) {
      //   final modelFile = product.modelFile!;
      //   final modelFileName = DateTime.now().millisecondsSinceEpoch.toString();
      //   final modelTask =
      //       storage.ref().child('models/$modelFileName').putFile(modelFile);
      //   await modelTask.whenComplete(() async {
      //     modelReference = await modelTask.snapshot.ref.getDownloadURL();
      //   });
      // }

      productMaps.add({
        'variant_name': product.variantName,
        'material': product.material,
        'metric': product.metric,
        'length': product.length,
        'width': product.width,
        'height': product.height,
        'color': product.color,
        'price': product.price,
        'stocks': product.stocks,
        'image': imageReference,
        'model': modelReference,
        'id': product.id,
      });
    }

    // List<Map<String, dynamic>> productMaps = _variant.map((product) {
    //   // final image = await

    //   return {
    //     'variant name': product.variantName,
    //     'material': product.material,
    //     'size': product.size,
    //     'color': product.color,
    //     'price': product.price,
    //     'stocks': product.stocks,
    //     'image': product.image,
    //     'model': product.model,
    //   };
    // }).toList();
    // print(productMaps);
    return productMaps;
  }
}
