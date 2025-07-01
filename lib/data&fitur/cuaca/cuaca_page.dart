import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/data&fitur/cuaca/cuaca_model.dart';
import 'package:cebamer/data&fitur/cuaca/cuaca_service.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class CuacaPage extends StatefulWidget {
  const CuacaPage({super.key});

  @override
  State<CuacaPage> createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage> {
  final _cuacaService = CuacaService('0bc4bb43c4d3ef8a37be50c1a9f3498e');
  Cuaca? _cuaca;
  bool _isLoading = false;
  String? _errorMessage;

  String hurufHARUSKAPITAL(String text) {
    return text
      .split(' ')
      .map((kata) => kata.isNotEmpty ? kata[0].toUpperCase() + kata.substring(1) : '')
      .join(' ');
  }

  _fetchCuaca() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? namaKota = await _cuacaService.getNamaKota();
      
      if (namaKota == null) {
        throw Exception('Tidak dapat mendapatkan lokasi kota');
      }
      
      final cuaca = await _cuacaService.getDataCuaca(namaKota);
      setState(() {
        _cuaca = cuaca;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCuaca();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Memuat data cuaca...'),
              ] else if (_errorMessage != null) ...[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchCuaca,
                  child: const Text('Coba Lagi'),
                ),
              ] else if (_cuaca != null) ...[
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _cuaca!.namaKota,
                          style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer1)
                        ),
                        Text(
                          '${_cuaca!.suhu.round()}°C',
                          style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)
                        ),
                        Text(
                          hurufHARUSKAPITAL(_cuaca!.kondisi),
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                        ),
                        j20,
                        divider(context, 'Detail'), j10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeatherInfo('Kelembaban Udara', '${_cuaca!.kelembaban}%'),
                            _buildWeatherInfo('Tekanan Udara', '${_cuaca!.tekanan} hPa'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeatherInfo('Kecepatan Angin', '${_cuaca!.kecepatanAngin} m/s'),
                            _buildWeatherInfo('Arah Angin', '${_cuaca!.arahAngin}°'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Text('Tidak ada data cuaca'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: BanaTemaTeks.temaCerah.labelMedium!.copyWith(color: primer3)
        ),
        j5,
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}