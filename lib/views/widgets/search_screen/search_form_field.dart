import 'package:flutter/material.dart';

class SearchFormField extends StatelessWidget {
  const SearchFormField({
    super.key,
    required this.onChanged,
  });
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onSurface),
          hintText: 'Search for songs...',
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
