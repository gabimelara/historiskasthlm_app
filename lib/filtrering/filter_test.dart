
class FilterList {
  final String filter;

  FilterList({this.filter});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<FilterList> filterList = [
  FilterList(filter: "1990"),
  FilterList(filter: "1900 "),
  FilterList(filter: "1995 "),
  FilterList(filter: "1994 "),
  FilterList(filter: "Persson"),
  FilterList(filter: "1992 "),
  FilterList(filter: "1986 "),
];