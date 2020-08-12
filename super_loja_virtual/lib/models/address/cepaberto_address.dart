class CepAbertoAddress {
  final double altitude;
  final double longitude;
  final double latitude;
  final String cep;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Map<String, dynamic> map)
      : altitude = map['altitude'] as double,
        longitude = double.tryParse(map['longitude'] as String),
        latitude = double.tryParse(map['latitude'] as String),
        cep = map['cep'] as String,
        logradouro = map['logradouro'] as String,
        bairro = map['bairro'] as String,
        cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
        estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoAddress{altitude: $altitude, longitude: $longitude, latitude: $latitude, cep: $cep, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade {
  final int ddd;
  final String ibge;
  final String nome;

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }

  Cidade.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;
}

class Estado {
  final String sigla;

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }

  Estado.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String;
}
