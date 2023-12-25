class Date {
  Date({required this.dateTime});
  final DateTime dateTime;

  @override
  String toString() {
    return dateTime.toString();
  }
}

class Subject {
  Subject({
    required this.period,
    required this.subject,
    required this.belongings,
  });
  final int period;
  final String subject;
  final List belongings;

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      period: json["period"] as int,
      subject: json["subject_name"] as String,
      belongings: json["belongings"] as List,
    );
  }
}

class DayBelongings {
  DayBelongings(
      {required this.selectedDate,
      required this.subjects,
      required this.items,
      required this.additionalItems});

  final String selectedDate;
  final List subjects;
  final List items;
  final List additionalItems;

  factory DayBelongings.fromJson(Map<String, dynamic> json) {
    return DayBelongings(
      selectedDate: json["selectedDate"] as String,
      subjects: json["subjects"].map((item) => Subject.fromJson(item)).toList()
          as List,
      items: json["itemNames"] as List,
      additionalItems: json["additionalItemNames"] as List,
    );
  }
}



// {name: Hattori, locale: ja-JP},{name: Kyoko, locale: ja-JP}, {name: Lana, locale: hr-HR}, {name: Laura, locale: sk-SK}, {name: Lekha, locale: hi-IN}, {name: Lesya, locale: uk-UA}, {name: Li-Mu, locale: zh-CN}, {name: Linh, locale: vi-VN}, {name: Luciana, locale: pt-BR}, {name: Majed, locale: ar-001}, {name: Marie, locale: fr-FR}, {name: Martha, locale: en-GB}, {name: Martin, locale: de-DE}, {name: Meijia, locale: zh-TW}, {name: Melina, locale: el-GR}, {name: Milena, locale: ru-RU}, {name: Moira, locale: en-IE}, {name: Montse, locale: ca-ES}, {name: Mónica, locale: es-ES}, {name: Nicky, locale: en-US}, {name: Nora, locale: nb-NO}, {name: O-Ren, locale: ja-JP}, {name: Organ, locale: en-US}, {name: Paulina, locale: es-MX}, {name: Ralph, locale: en-US}, {name: Reed (German (Germany)), locale: de-DE}, {name: Reed (English (United Kingdom)), locale: en-GB}, {name: Reed (English (United States)), locale: en-US}, {name: Reed (Spanish (Spain)), locale: es-ES}, {name: Reed (Spanish (Mexico)), locale: es-MX}, {name: Reed (Finnish (Finland)), locale: fi-FI}, {name: Reed (French (Canada)), locale: fr-CA}, {name: Reed (Italian (Italy)), locale: it-IT}, {name: Reed (Portuguese (Brazil)), locale: pt-BR}, {name: Rishi, locale: en-IN}, {name: Rocko (German (Germany)), locale: de-DE}, {name: Rocko (English (United Kingdom)), locale: en-GB}, {name: Rocko (English (United States)), locale: en-US}, {name: Rocko (Spanish (Spain)), locale: es-ES}, {name: Rocko (Spanish (Mexico)), locale: es-MX}, {name: Rocko (Finnish (Finland)), locale: fi-FI}, {name: Rocko (French (Canada)), locale: fr-CA}, {name: Rocko (French (France)), locale: fr-FR}, {name: Rocko (Italian (Italy)), locale: it-IT}, {name: Rocko (Portuguese (Brazil)), locale: pt-BR}, {name: Sandy (German (Germany)), locale: de-DE}, {name: Sandy (English (United Kingdom)), locale: en-GB}, {name: Sandy (English (United States)), locale: en-US}, {name: Sandy (Spanish (Spain)), locale: es-ES}, {name: Sandy (Spanish (Mexico)), locale: es-MX}, {name: Sandy (Finnish (Finland)), locale: fi-FI}, {name: Sandy (French (Canada)), locale: fr-CA}, {name: Sandy (French (France)), locale: fr-FR}, {name: Sandy (Italian (Italy)), locale: it-IT}, {name: Sandy (Portuguese (Brazil)), locale: pt-BR}, {name: Sara, locale: da-DK}, {name: Satu, locale: fi-FI}, {name: Shelley (German (Germany)), locale: de-DE}, {name: Shelley (English (United Kingdom)), locale: en-GB}, {name: Shelley (English (United States)), locale: en-US}, {name: Shelley (Spanish (Spain)), locale: es-ES}, {name: Shelley (Spanish (Mexico)), locale: es-MX}, {name: Shelley (Finnish (Finland)), locale: fi-FI}, {name: Shelley (French (Canada)), locale: fr-CA}, {name: Shelley (French (France)), locale: fr-FR}, {name: Shelley (Italian (Italy)), locale: it-IT}, {name: Shelley (Portuguese (Brazil)), locale: pt-BR}, {name: Sinji, locale: zh-HK}, {name: Superstar, locale: en-US}, {name: Tessa, locale: en-ZA}, {name: Thomas, locale: fr-FR}, {name: Tingting, locale: zh-CN}, {name: Trinoids, locale: en-US}, {name: Tünde, locale: hu-HU}, {name: Whisper, locale: en-US}, {name: Wobble, locale: en-US}, {name: Xander, locale: nl-NL}, {name: Yelda, locale: tr-TR}, {name: Yu-shu, locale: zh-CN}, {name: Yuna, locale: ko-KR}, {name: Zarvox, locale: en-US}, {name: Zosia, locale: pl-PL}, {name: Zuzana, locale: cs-CZ}, {name: Google Deutsch, locale: de-DE}, {name: Google US English, locale: en-US}, {name: Google UK English Female, locale: en-GB}, {name: Google UK English Male, locale: en-GB}, {name: Google español, locale: es-ES}, {name: Google español de Estados Unidos, locale: es-US}, {name: Google français, locale: fr-FR}, {name: Google हिन्दी, locale: hi-IN}, {name: Google Bahasa Indonesia, locale: id-ID}, {name: Google italiano, locale: it-IT}, {name: Google 日本語, locale: ja-JP}, {name: Google 한국의, locale: ko-KR}, {name: Google Nederlands, locale: nl-NL}, {name: Google polski, locale: pl-PL}, {name: Google português do Brasil, locale: pt-BR}, {name: Google русский, locale: ru-RU}, {name: Google 普通话（中国大陆）, locale: zh-CN}, {name: Google 粤語（香港）, locale: zh-HK}, {name: Google 國語（臺灣）, locale: zh-TW},]