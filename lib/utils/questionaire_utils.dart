import './item.dart';

class Questionaire {
  List<Item> _firstSet = [
    Item('inflorescence.jpeg', 'inflorescence', 'inflorescence'),
    Item('flowering.jpeg', 'flowering', 'flowering'),
    Item('berrydevelopment.jpeg', 'berry development', 'berrydevelopment'),
    Item('berryripening.jpeg', 'berry ripening', 'berryripening')
  ];
  List<Item> _species = [
    Item('robusta.jpeg', 'robusta', 'start'),
    Item('arabica.jpeg', 'arabica', 'start'),
    Item('liberica.jpeg', 'liberica', 'start'),
    Item('excelsa.jpeg', 'excelsa', 'start')
  ];
  List<Item> _inflorescenceSet = [
    Item('inflorescence1.jpeg', 'BBCH 51', '51'),
    Item('inflorescence2.jpeg', 'BBCH 53', '53'),
    Item('inflorescence3.jpeg', 'BBCH 55', '55'),
    Item('inflorescence4.jpeg', 'BBCH 57', '57'),
    Item('inflorescence5.jpeg', 'BBCH 59', '59'),
  ];

  List<Item> _floweringSet = [
    Item('flowering1.jpeg', 'BBCH 61', '61'),
    Item('flowering2.jpeg', 'BBCH 65', '65'),
    Item('flowering3.jpeg', 'BBCH 69', '69')
  ];

  List<Item> _berrydevelopmentSet = [
    Item('berrydevelopment1.jpeg', 'BBCH 71', '71'),
    Item('berrydevelopment2.jpeg', 'BBCH 73', '73'),
    Item('berrydevelopment3.jpeg', 'BBCH 75', '75'),
    Item('berrydevelopment4.jpeg', 'BBCH 77', '77'),
    Item('berrydevelopment5.jpeg', 'BBCH 79', '79'),
  ];

  List<Item> _berryripenningSet = [
    Item('berryripening1.jpeg', 'BBCH 81', '81')
  ];


  List<Item> get species => _species;
  List<Item> get firstSet => _firstSet;

  List<Item> nextList(String state, String kind) {
    if (state == 'start') return _firstSet;
    if (state == 'inflorescence') return _inflorescenceSet;
    if (state == 'flowering') return _floweringSet;
    if (state == 'berrydevelopment') return _berrydevelopmentSet;
    if (state == 'berryripening')
      return _berryripenningSet;
    else
      return [];
//
  }

}
