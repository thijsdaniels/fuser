import 'swatch.dart';
import 'family.dart';

class Palette {
  final String name;
  final Map<String, Swatch> swatches;
  final List<Family> families;

  const Palette({this.name, this.swatches, this.families});
}