import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/data_service.dart';

class FormScreen extends StatefulWidget {
  final ItemModel? itemToEdit;
  const FormScreen({super.key, this.itemToEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final DataService _dataService = DataService();

  String _categoria = 'Personal';
  bool _isSaving = false;

  final List<String> _categorias = ['Personal', 'Trabajo', 'Estudio', 'Otro'];

  bool get _isEditing => widget.itemToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nombreController.text = widget.itemToEdit!.nombre;
      _descripcionController.text = widget.itemToEdit!.descripcion;
      _categoria = widget.itemToEdit!.categoria;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 400));

    if (_isEditing) {
      widget.itemToEdit!.nombre = _nombreController.text.trim();
      widget.itemToEdit!.descripcion = _descripcionController.text.trim();
      widget.itemToEdit!.categoria = _categoria;
      await _dataService.updateItem(widget.itemToEdit!);
    } else {
      final newItem = ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        categoria: _categoria,
        fechaCreacion: DateTime.now(),
      );
      await _dataService.saveItem(newItem);
    }

    setState(() => _isSaving = false);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  void _showDiscardDialog() {
    if (_nombreController.text.isEmpty && _descripcionController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon:
            const Icon(Icons.warning_amber, color: Colors.orange, size: 44),
        title: const Text('Descartar cambios'),
        content: const Text(
            '¿Deseas salir sin guardar? Los cambios se perderán.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Seguir editando'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Salir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Personal':
        return Colors.purple;
      case 'Trabajo':
        return Colors.blue;
      case 'Estudio':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Registro' : 'Nuevo Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showDiscardDialog,
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Guardar',
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF1A237E)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing ? 'Editando registro' : 'Nuevo registro',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'Creado por Wiston Patiño',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Campo nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Ingrese el nombre del registro',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLength: 50,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El nombre es requerido';
                  if (v.trim().length < 3) return 'Mínimo 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo descripción
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción *',
                  hintText: 'Ingrese una descripción detallada',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'La descripción es requerida';
                  if (v.trim().length < 5) return 'Mínimo 5 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selector de categoría
              const Text(
                'Categoría *',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categorias.map((cat) {
                  final isSelected = _categoria == cat;
                  final color = _getCategoryColor(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _categoria = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.15)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.check_circle,
                                  color: color, size: 16),
                            ),
                          Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? color : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              _isSaving
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save),
                      label: Text(
                        _isEditing ? 'ACTUALIZAR REGISTRO' : 'GUARDAR REGISTRO',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
