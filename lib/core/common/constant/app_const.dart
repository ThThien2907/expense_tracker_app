class AppConst {
  AppConst._();

  static const List<String> languages = [
    'en',
    'vi',
  ];

  static const List<Currency> currencies = [
    Currency(
      currencyName: 'United States Dollar',
      currencyCode: 'USD',
      currencySymbol: '\$',
    ),
    Currency(
      currencyName: 'Việt Nam Đồng',
      currencyCode: 'VND',
      currencySymbol: '₫',
    ),
  ];

  static const exchangeRates = {
    'USD': 0.000038,
    'VND': 1.0,
  };

  static const List<Map<String, String>> icons = [
    {
      'icon_name': 'film_icon.svg',
      'color': '#FF8C00'
    },
    {
      'icon_name': 'billiard_icon.svg',
      'color': '#4682B4'
    },
    {
      'icon_name': 'game_icon.svg',
      'color': '#2E8B57'
    },
    {
      'icon_name': 'badminton_icon.svg',
      'color': '#F08080'
    },
    {
      'icon_name': 'meat_icon.svg',
      'color': '#00FA9A'
    },
    {
      'icon_name': 'fruit_icon.svg',
      'color': '#FF00FF'
    },
    {
      'icon_name': 'cake_icon.svg',
      'color': '#DEB887'
    },
    {
      'icon_name': 'hamburger_icon.svg',
      'color': '#32CD32'
    },
    {
      'icon_name': 'coffee_icon.svg',
      'color': '#CD853F'
    },
    {
      'icon_name': 'birthday_icon.svg',
      'color': '#8A2BE2'
    },
    {
      'icon_name': 'wine_glass_bottle_icon.svg',
      'color': '#DC143C'
    },
    {
      'icon_name': 'clothes_icon.svg',
      'color': '#00CED1'
    },
    {
      'icon_name': 'shoes_icon.svg',
      'color': '#B8860B'
    },
    {
      'icon_name': 'watch_icon.svg',
      'color': '#7FFFD4'
    },
    {
      'icon_name': 'perfume_icon.svg',
      'color': '#DA70D6'
    },
    {
      'icon_name': 'lipstick_icon.svg',
      'color': '#B22222'
    },
    {
      'icon_name': 'jewelry_icon.svg',
      'color': '#ADFF2F'
    },
    {
      'icon_name': 'swim_icon.svg',
      'color': '#1E90FF'
    },
    {
      'icon_name': 'football_icon.svg',
      'color': '#228B22'
    },
    {
      'icon_name': 'company_icon.svg',
      'color': '#D8BFD8'
    },
    {
      'icon_name': 'cloud_icon.svg',
      'color': '#00FFFF'
    },
    {
      'icon_name': 'wifi_icon.svg',
      'color': '#F4A460'
    },
    {
      'icon_name': 'usb_icon.svg',
      'color': '#DC143C'
    },
    {
      'icon_name': 'printer_icon.svg',
      'color': '#BA55D3'
    },
    {
      'icon_name': 'computer_icon.svg',
      'color': '#808000'
    },
    {
      'icon_name': 'phone_icon.svg',
      'color': '#9932CC'
    },
    {
      'icon_name': 'sofa_icon.svg',
      'color': '#A0522D'
    },
    {
      'icon_name': 'gift_icon.svg',
      'color': '#DCB732'
    },
    {
      'icon_name': 'school_icon.svg',
      'color': '#468499'
    },
    {
      'icon_name': 'book_icon.svg',
      'color': '#B0E0E6'
    },
    {
      'icon_name': 'repair_icon.svg',
      'color': '#8B0000'
    },
    {
      'icon_name': 'paint_icon.svg',
      'color': '#4169E1'
    },
    {
      'icon_name': 'paint_brush_icon.svg',
      'color': '#FFD700'
    },
    {
      'icon_name': 'travel_suitcase_icon.svg',
      'color': '#708090'
    },
    {
      'icon_name': 'travel_icon.svg',
      'color': '#556B2F'
    },
    {
      'icon_name': 'flight_icon.svg',
      'color': '#3CB371'
    },
    {
      'icon_name': 'car_icon.svg',
      'color': '#FF4500'
    },
    {
      'icon_name': 'motorcycle_icon.svg',
      'color': '#D2691E'
    },
    {
      'icon_name': 'gas_station_icon.svg',
      'color': '#FFB6C1'
    },
    {
      'icon_name': 'hospital_icon.svg',
      'color': '#20B2AA'
    },
    {
      'icon_name': 'hospital_bed_icon.svg',
      'color': '#993333'
    },
    {
      'icon_name': 'medicine_icon.svg',
      'color': '#7CFC00'
    },
    {
      'icon_name': 'pet_icon.svg',
      'color': '#2F4F4F'
    },
    {
      'icon_name': 'baby_kid_icon.svg',
      'color': '#6495ED'
    },
  ];
}

class Currency {
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;

  const Currency({
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
  });
}
