import 'package:flutter/material.dart';

class SearchFormField extends StatefulWidget {
  const SearchFormField({
    super.key,
    required this.onChanged,
  });
  final void Function(String)? onChanged;

  @override
  State<SearchFormField> createState() => _SearchFormFieldState();
}

class _SearchFormFieldState extends State<SearchFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onSurface),
          hintText: 'Search for tracks...',
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6)),
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
