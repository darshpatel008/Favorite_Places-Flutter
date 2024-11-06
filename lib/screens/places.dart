import 'package:favorite_place/providers/user_places.dart';
import 'package:favorite_place/screens/add_places.dart';
import 'package:favorite_place/widget/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return PlacesScreenState();
  }
}

class PlacesScreenState extends ConsumerState<PlacesScreen> {

  late Future<void> _placesFutures;

  @override
  void initState() {
    super.initState();
    _placesFutures = ref.read(UserPlacesProvider.notifier).loadPlaces();
  }


  @override
  Widget build(BuildContext context) {
    final userplace = ref.watch(UserPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => AddPlacesScreen(),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFutures ,
          builder: (context,snapshot) =>
         snapshot.connectionState == ConnectionState.waiting
             ? const Center(child: CircularProgressIndicator())
             : PlacesList(
                 places: userplace //[],   //passing new list of provider to places
               ),
        ),
      ),
    );
  }
}
