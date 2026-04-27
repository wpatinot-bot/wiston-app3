import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../models/item_model.dart';
import 'form_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

  List<ItemModel> _items = [];
  String _username = 'Usuario';
  String _searchQuery = '';
  bool _isLoading = true;

  final List<String> _categorias = [
    'Todos',
    'Personal',
    'Trabajo',
    'Estudio',
    'Otro'
  ];
  String _filtroCategoria = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final username = await _authService.getUsername();
    final items = await _dataService.getItems();
    setState(() {
      _username = username ?? 'Usuario';
      _items = items;
      _isLoading = false;
    });
  }

  List<ItemModel> get _filteredItems {
    return _items.where((item) {
      final matchSearch = _searchQuery.isEmpty ||
          item.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.descripcion.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCat =
          _filtroCategoria == 'Todos' || item.categoria == _filtroCategoria;
      return matchSearch && matchCat;
    }).toList();
  }

  void _showDeleteDialog(ItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 48),
        title: const Text('Eliminar registro'),
        content: Text(
            '¿Estás seguro de que deseas eliminar "${item.nombre}"?\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _dataService.deleteItem(item.id);
              await _loadData();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(children: [
                    const Icon(Icons.delete_forever, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('"${item.nombre}" eliminado'),
                  ]),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 48),
        title: const Text('Limpiar todo'),
        content: const Text(
            '¿Deseas eliminar TODOS los registros? Esta acción es irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _dataService.clearAll();
              await _loadData();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos los registros fueron eliminados'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar todo',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.logout, color: Color(0xFF1565C0), size: 48),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar tu sesión actual?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.logout();
              if (!mounted) return;
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String cat) {
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

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Personal':
        return Icons.person;
      case 'Trabajo':
        return Icons.work;
      case 'Estudio':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Datos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _loadData,
          ),
          if (_items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Limpiar todo',
              onPressed: _showClearAllDialog,
            ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Banner creador
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: const Color(0xFF1565C0).withOpacity(0.08),
                  child: const Text(
                    '✦ Creado por Wiston Patiño ✦',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Buscar registros...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),

                // Filtro categoría
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categorias.length,
                    itemBuilder: (ctx, i) {
                      final cat = _categorias[i];
                      final selected = _filtroCategoria == cat;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _filtroCategoria = cat),
                          selectedColor:
                              const Color(0xFF1565C0).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF1565C0),
                        ),
                      );
                    },
                  ),
                ),

                // Contador
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        '${_filteredItems.length} registro(s)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de items
                Expanded(
                  child: _filteredItems.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: _filteredItems.length,
                          itemBuilder: (ctx, i) =>
                              _buildItemCard(_filteredItems[i]),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (result == true) {
            await _loadData();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Registro guardado exitosamente'),
                ]),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Registro'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF1A237E)],
              ),
            ),
            accountName: Text(
              _username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: const Text('Creado por Wiston Patiño'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF1565C0)),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF1565C0)),
            title: const Text('Mi Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ).then((_) => _loadData());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box, color: Color(0xFF1565C0)),
            title: const Text('Nuevo Registro'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormScreen()),
              );
              if (result == true) await _loadData();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildItemCard(ItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _categoryColor(item.categoria).withOpacity(0.15),
          child: Icon(
            _categoryIcon(item.categoria),
            color: _categoryColor(item.categoria),
          ),
        ),
        title: Text(
          item.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _categoryColor(item.categoria).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.categoria,
                    style: TextStyle(
                      fontSize: 11,
                      color: _categoryColor(item.categoria),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.fechaCreacion.day}/${item.fechaCreacion.month}/${item.fechaCreacion.year}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (val) async {
            if (val == 'edit') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FormScreen(itemToEdit: item),
                ),
              );
              if (result == true) {
                await _loadData();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registro actualizado'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            } else if (val == 'delete') {
              _showDeleteDialog(item);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [
                Icon(Icons.edit, color: Colors.blue),
                SizedBox(width: 8),
                Text('Editar'),
              ]),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Eliminar', style: TextStyle(color: Colors.red)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Sin resultados para "$_searchQuery"'
                : 'No hay registros aún',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
