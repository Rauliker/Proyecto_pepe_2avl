import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/avatar_appbar.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/widgets/drewers.dart';
import 'package:proyecto_raul/presentations/widgets/filter_drawer.dart';
import 'package:proyecto_raul/presentations/widgets/sort_drawer.dart';
import 'package:proyecto_raul/presentations/widgets/subastas_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;
  bool _isPriceSort = false;
  bool _isDateSort = false;
  bool _isPriceSortAscending = true;
  bool _isDateSortAscending = true;
  int? precioMasAlto;
  int? precioMasBajo;

  bool _isFirstTimeSortedPrice = true;
  bool _isFirstTimeSortedDate = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchSubastas();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      if (!mounted) return;
      context.read<UserBloc>().add(UserDataRequest(email: email));
      setState(() {});
    }
  }

  Future<void> fetchSubastas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      if (!mounted) return;
      context.read<SubastasBloc>().add(FetchSubastasDeOtroUsuarioEvent(email));
    }

    if (!mounted) return;
    context.read<SubastasBloc>().stream.listen((state) {
      if (state is SubastasLoadedState) {
        final precios =
            state.subastas.map((subasta) => subasta.pujaActual).toList();

        if (precios.isNotEmpty) {
          setState(() {
            precioMasAlto = precios.reduce((a, b) => a > b ? a : b);
            precioMasBajo = precios.reduce((a, b) => a < b ? a : b);
          });
        }
      }
    });
  }

  void _filterSubastas(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _applySorting(bool isPriceSort, bool isAscending) {
    setState(() {
      _isPriceSort = isPriceSort;
      _isDateSort = !isPriceSort;
      if (isPriceSort) {
        _isPriceSortAscending = isAscending;
        if (_isFirstTimeSortedPrice) {
          _isFirstTimeSortedPrice = false;
        } else {
          _isFirstTimeSortedPrice = true;
        }
      } else {
        _isDateSortAscending = isAscending;
        if (_isFirstTimeSortedDate) {
          _isFirstTimeSortedDate = false;
        } else {
          _isFirstTimeSortedDate = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AvatarAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSubastas,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.search,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SubastasListWidget(
              searchQuery: _searchQuery,
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              isPriceSort: _isPriceSort,
              isPriceSortAscending: _isPriceSortAscending,
              isDateSort: _isDateSort,
              isDateSortAscending: _isDateSortAscending,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () =>
                showFiltersDrawer(context, _searchController, (min, max) {
              setState(() {
                _minPrice = min;
                _maxPrice = max;
              });
            }, precioMasBajo, precioMasAlto),
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () =>
                showSortDrawer(context, (isPriceSort, isAscending) {
              _applySorting(isPriceSort, isAscending);
            }, _isFirstTimeSortedPrice, _isFirstTimeSortedDate),
            child: const Icon(Icons.sort),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () => context.go('/my_sub'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.my_Bid,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
