import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/choice.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/required_option.dart';
import 'package:splitz/data/services/image_service.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';
import 'package:splitz/ui/custom_widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class MenuItemForm extends StatefulWidget {
  final String restaurantId;
  String? categoryId;
  final MenuItemModel? menuItem;
  MenuItemForm({required this.restaurantId, this.categoryId, this.menuItem});
  @override
  _MenuItemFormState createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<MenuItemForm> {
  final String defaultImageUrl =
      'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _extras = [];
  final List<Map<String, dynamic>> _requiredOptions = [];
  File? _selectedImage;
  List<String> removedExtras = [];
  Map<String, List<String>> removedChoices = {};
  List<String> removedRequiredOptions = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _preparationTimeController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String? imageUrl;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      imageUrl = null;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.menuItem != null) {
      _nameController.text = widget.menuItem!.name;
      _descriptionController.text = widget.menuItem!.description;
      _caloriesController.text = widget.menuItem!.calories.toString();
      _preparationTimeController.text =
          widget.menuItem!.preparationTime.toString();
      _priceController.text = widget.menuItem!.price.toString();
      _discountController.text = widget.menuItem!.discount?.toString() ?? '';
      imageUrl = widget.menuItem!.image != '' ? widget.menuItem!.image : null;

      _extras.addAll(widget.menuItem!.extras
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'price': e.price.toString(),
              })
          .toList());

      _requiredOptions.addAll(widget.menuItem!.requiredOptions
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'choices': e.choices
                    .map((c) => {
                          'id': c.id,
                          'name': c.name,
                          'price': c.price.toString(),
                        })
                    .toList(),
              })
          .toList());
    }
  }

  void _addExtra() {
    setState(() {
      _extras.add({'id': '', 'name': '', 'price': ''});
    });
  }

  void _addRequiredOption() {
    setState(() {
      _requiredOptions.add({'id': '', 'name': '', 'choices': []});
    });
  }

  void _addChoice(int optionIndex) {
    setState(() {
      _requiredOptions[optionIndex]['choices']
          .add({'id': '', 'name': '', 'price': ''});
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      imageUrl == null && _selectedImage != null
          ? imageUrl = await uploadFile(_selectedImage!)
          : defaultImageUrl;

      // Convert form data to models
      List<Extra> extras = _extras
          .where((extra) => extra['name'] != null && extra['name'] != '')
          .map((extra) => Extra(
                id: extra['id'],
                name: extra['name'],
                price: double.tryParse(extra['price'] ?? '0') ?? 0,
              ))
          .toList();

      List<RequiredOption> requiredOptions = _requiredOptions
          .where((option) => option['name'] != null && option['name'] != '')
          .map((option) {
        List<Choice> choices = option['choices']
            .where((choice) => choice['name'] != null && choice['name'] != '')
            .map<Choice>((choice) => Choice(
                  id: choice['id'],
                  name: choice['name'],
                  price: double.tryParse(choice['price'] ?? '0') ?? 0,
                ))
            .toList();

        return RequiredOption(
          id: option['id'],
          name: option['name'],
          choices: choices,
        );
      }).toList();

      MenuItemModel newItem = MenuItemModel(
        id: widget.menuItem?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        image: imageUrl != '' ? imageUrl! : defaultImageUrl,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        preparationTime: int.tryParse(_preparationTimeController.text) ?? 0,
        price: double.tryParse(_priceController.text) ?? 0,
        discount: double.tryParse(_discountController.text) ?? 0,
        overallRating: 0,
        reviews: [],
        extras: extras,
        requiredOptions: requiredOptions,
      );

      if (widget.menuItem == null) {
        addItem(newItem);
      } else {
        // Updating an existing item
        updateItem(newItem);
      }
      toastification.show(
        context: context,
        title: Text(
            'Menu Item Is ${widget.menuItem != null ? "Editted" : "Added"} Successfuly!'),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.check),
        showIcon: true, // show or hide the icon
        primaryColor: Colors.green,
      );
    }
  }

  Future<void> addItem(MenuItemModel menuItem) async {
    await MenuItemService()
        .addMenuItem(widget.restaurantId, menuItem, widget.categoryId);
    Navigator.of(context).pop(true);
  }

  Future<void> updateItem(MenuItemModel newItem) async {
    await MenuItemService().updateMenuItem(
        widget.restaurantId, widget.menuItem!.id, newItem, widget.categoryId);
    await MenuItemService().deleteRemovedChoices(
        removedChoices, widget.restaurantId, widget.menuItem!.id);
    await MenuItemService().deleteRemovedOptions(
        removedRequiredOptions, widget.restaurantId, widget.menuItem!.id);
    await MenuItemService().deleteRemovedExtras(
        removedExtras, widget.restaurantId, widget.menuItem!.id);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Craft Your Signature Menu Item',
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Image Upload Section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.secondary, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  height: 170,
                  child: imageUrl == null
                      ? _selectedImage == null
                          ? const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: AppColors.textColor,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)), // Adjust for border
                              child: Image.file(
                                _selectedImage!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                      : ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(20)), // Adjust for border
                          child: Image.network(
                            imageUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              // Text Fields
              CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null),

              CustomTextField(
                controller: _caloriesController,
                labelText: 'Calories',
                isNumber: true,
              ),
              CustomTextField(
                controller: _preparationTimeController,
                labelText: 'Preparation Time',
                isNumber: true,
              ),
              CustomTextField(
                controller: _priceController,
                labelText: 'Price',
                isNumber: true,
              ),
              CustomTextField(
                controller: _discountController,
                labelText: 'Discount',
                isNumber: true,
              ),
              // CustomTextField(
              //   controller: _overallRatingController,
              //   labelText: 'Overall Rating',
              //   isNumber: true,
              // ),

              const SizedBox(height: 16),

              // Extras Section
              Row(children: [
                const Text('Extras',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                IconButton(
                  onPressed: _addExtra,
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.primary, // Set the color of the icon here
                  ),
                ),
              ]),
              ..._extras.map((extra) {
                int index = _extras.indexOf(extra);
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: extra['name'],
                          decoration: inputdecorate("Extra Name"),
                          onChanged: (value) => _extras[index]['name'] = value,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: extra['price'],
                          decoration: inputdecorate("Extra Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _extras[index]['price'] = value,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    removedExtras.add(_extras[index]['id']);
                                    _extras.removeAt(index);
                                  });
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ])
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Required Options Section
              Row(children: [
                const Text('Required Options',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                IconButton(
                    onPressed: _addRequiredOption,
                    icon: const Icon(
                      Icons.add,
                      color:
                          AppColors.primary, // Set the color of the icon here
                    )),
              ]),

              ..._requiredOptions.map((option) {
                int optionIndex = _requiredOptions.indexOf(option);
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: option['name'],
                          decoration: inputdecorate("Option Name"),
                          onChanged: (value) =>
                              _requiredOptions[optionIndex]['name'] = value,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    removedRequiredOptions.add(
                                        _requiredOptions[optionIndex]['id']);
                                  });
                                  _requiredOptions.removeAt(optionIndex);
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        ...option['choices'].map((choice) {
                          int choiceIndex = option['choices'].indexOf(choice);
                          return Column(
                            children: [
                              TextFormField(
                                initialValue: choice['name'],
                                decoration: inputdecorate("Choice Name"),
                                onChanged: (value) =>
                                    _requiredOptions[optionIndex]['choices']
                                        [choiceIndex]['name'] = value,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: choice['price'],
                                decoration: inputdecorate("Choice Price"),
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    _requiredOptions[optionIndex]['choices']
                                        [choiceIndex]['price'] = value,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print("hi");
                                        String requiredOptionId =
                                            _requiredOptions[optionIndex]['id'];
                                        String choiceId =
                                            _requiredOptions[optionIndex]
                                                ['choices'][choiceIndex]['id'];
                                        if (removedChoices
                                            .containsKey(requiredOptionId)) {
                                          removedChoices[requiredOptionId]
                                              ?.add(choiceId);
                                        } else {
                                          removedChoices[requiredOptionId] = [
                                            choiceId
                                          ];
                                        }
                                        setState(() {
                                          print("hi");
                                          _requiredOptions[optionIndex]
                                                  ['choices']
                                              .removeAt(choiceIndex);
                                        });
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }).toList(),
                        Row(
                          children: [
                            const Text('Choice',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary)),
                            IconButton(
                                onPressed: () => _addChoice(optionIndex),
                                icon: const Icon(
                                  Icons.add,
                                  color: AppColors
                                      .primary, // Set the color of the icon here
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Submit Button
              const SizedBox(height: 32),
              CustomElevatedButton(
                  text: widget.menuItem == null ? 'ADD' : 'EDIT',
                  height: 50,
                  onPressed: _submitForm),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputdecorate(labeltext) {
    return InputDecoration(
      labelText: labeltext,
      labelStyle: const TextStyle(color: Color.fromARGB(148, 0, 0, 0)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondary, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
