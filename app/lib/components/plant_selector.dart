import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PlantSelector extends StatefulWidget {
  const PlantSelector({super.key});

  @override
  State<PlantSelector> createState() => _PlantSelectorState();
}

class _PlantSelectorState extends State<PlantSelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(

      items: const ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Menu mode",
          hintText: "country in menu mode",
        ),
      ),
      onChanged: print,
      selectedItem: "Brazil",
    );
  }
}
