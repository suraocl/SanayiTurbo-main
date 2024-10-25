enum Categories {
  car,
  chemical,
  glass,
  food,
  machine,
  cement,
}

String enumToString(Categories c) {
  switch (c) {
    case Categories.car:
      return "Car";
    case Categories.chemical:
      return "chemical";
    case Categories.glass:
      return "glass";
    case Categories.food:
      return "food";
    case Categories.machine:
      return "machine";
    case Categories.cement:
      return "cement";
    default:
      return "aaaa";
  }
}

Categories stringToEnum(String category) {
  switch (category) {
    case "Car":
      return Categories.car;
    case "chemical":
      return Categories.chemical;
    case "glass":
      return Categories.glass;
    case "food":
      return Categories.food;
    case "machine":
      return Categories.machine;
    case "cement":
      return Categories.cement;
    default:
      return Categories.car;
  }
}
