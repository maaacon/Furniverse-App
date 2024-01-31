class SalesAnalytics {
  final String name;
  final String address;
  final String link;
  final List<RowCity> cities;
  final List<RowFurniture> furnitures;

  SalesAnalytics(
      this.name, this.address, this.link, this.cities, this.furnitures);

  int totalRetail() => furnitures.fold(
      0, (previousValue, element) => previousValue + element.totalRetailSales);
  int totalPotentialRetailSales() => furnitures.fold(0,
      (previousValue, element) => previousValue + element.potentialRetailSales);
  int totalSurplus() => furnitures.fold(
      0, (previousValue, element) => previousValue + element.surplus);
  int totalTradeCapture() => furnitures.fold(
      0, (previousValue, element) => previousValue + element.tradeAreaCapture);
  int totalPullFactor() => furnitures.fold(
      0, (previousValue, element) => previousValue + element.pullFactor);
}

class RowFurniture {
  final String furniture;
  final int totalRetailSales;
  final int potentialRetailSales;
  final int surplus;
  final int tradeAreaCapture;
  final int pullFactor;

  RowFurniture(this.furniture, this.totalRetailSales, this.potentialRetailSales,
      this.surplus, this.tradeAreaCapture, this.pullFactor);
}

class RowCity {
  final int population;
  final int totalRetailSales;
  final int perCapitaIncome;
  final int tradeAreaCapture;
  final int totalSalesPullFactor;

  RowCity(this.population, this.totalRetailSales, this.perCapitaIncome,
      this.tradeAreaCapture, this.totalSalesPullFactor);
}
