part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewmodel homeViewmodel = HomeViewmodel();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    super.initState();
  }

  dynamic selectedCourier;
  dynamic selectedOriginProvinceId;
  dynamic selectedOriginCityId;
  dynamic selectedDestinationProvinceId;
  dynamic selectedDestinationCityId;

  final weightController = TextEditingController();

  bool isLoading = false;

  static Container LoadingScreen() {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: Colors.black26,
        child: SpinKitFadingCircle(size: 50, color: Colors.blueAccent));
  }

  String rupiahConverter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>(
        create: (BuildContext context) => homeViewmodel,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for Courier
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedCourier,
                          decoration: InputDecoration(
                            labelText: 'Kurir',
                            border: OutlineInputBorder(),
                          ),
                          items: ['jne', 'tiki', 'pos']
                              .map((courier) => DropdownMenuItem(
                                    value: courier,
                                    child: Text(courier.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCourier = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      // Weight Input
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Berat (gr)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Origin Dropdowns
                  Text("Origin", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.provinceList.status) {
                              case Status.loading:
                                return Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                              case Status.error:
                                return Text(
                                    value.provinceList.message.toString());
                              case Status.completed:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  value: selectedOriginProvinceId,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Provinsi Asal',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: value.provinceList.data!
                                      .map<DropdownMenuItem<Province>>(
                                          (Province value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.province.toString()));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOriginProvinceId = newValue;
                                      selectedOriginCityId = null;
                                    });
                                    if (newValue != null) {
                                      value.setCityOriginList(
                                          ApiResponse.loading());
                                      homeViewmodel.getCityOriginList(
                                          selectedOriginProvinceId.provinceId);
                                    }
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.cityOriginList.status) {
                              case Status.notStarted:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  value: selectedOriginCityId,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Kota Asal',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: value,
                                      child: Text("Kota belum tersedia"),
                                    )
                                  ],
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOriginCityId = newValue;
                                    });
                                  },
                                );
                              case Status.loading:
                                return Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                                ;
                              case Status.error:
                                return Text(
                                    value.cityOriginList.message.toString());
                              case Status.completed:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Kota Asal',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedOriginCityId,
                                  items: value.cityOriginList.data!
                                      .map<DropdownMenuItem<City>>((City city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city.cityName!),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOriginCityId = newValue;
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Destination Dropdowns
                  Text("Destination",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.provinceList.status) {
                              case Status.loading:
                                return Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                              case Status.error:
                                return Text(
                                    value.provinceList.message.toString());
                              case Status.completed:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  value: selectedDestinationProvinceId,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Provinsi Tujuan',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: value.provinceList.data!
                                      .map<DropdownMenuItem<Province>>(
                                          (Province value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.province.toString()));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDestinationProvinceId = newValue;
                                      selectedDestinationCityId = null;
                                    });
                                    if (newValue != null) {
                                      value.setCityDestinationList(
                                          ApiResponse.loading());
                                      homeViewmodel.getCityDestinationList(
                                          selectedDestinationProvinceId
                                              .provinceId);
                                    }
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.cityDestinationList.status) {
                              case Status.notStarted:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  value: selectedDestinationCityId,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Kota Tujuan',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: value,
                                      child: Text("Kota belum tersedia"),
                                    )
                                  ],
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDestinationCityId = newValue;
                                    });
                                  },
                                );
                              case Status.loading:
                                return Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                              case Status.error:
                                return Text(value.cityDestinationList.message
                                    .toString());
                              case Status.completed:
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih Kota Tujuan',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedDestinationCityId,
                                  items: value.cityDestinationList.data!
                                      .map<DropdownMenuItem<City>>((City city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city.cityName!),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDestinationCityId = newValue;
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Button to Calculate
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        homeViewmodel
                            .getCostsList(
                                selectedOriginCityId.cityId.toString(),
                                selectedDestinationCityId.cityId.toString(),
                                int.parse(weightController.text),
                                selectedCourier)
                            .then((onValue) {
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        elevation: 0,
                        fixedSize: Size(150, 40),
                      ),
                      child: Text(
                        "Hitung Estimasi Harga",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Consumer<HomeViewmodel>(
                      builder: (context, value, _) {
                        switch (value.costs.status) {
                          case Status.loading:
                            return Align(
                              alignment: Alignment.center,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Tidak ada data.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          case Status.error:
                            return Align(
                              alignment: Alignment.center,
                              child: Text(value.costs.message.toString()),
                            );
                          case Status.completed:
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (isLoading) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: ListView.builder(
                                itemCount: value.costs.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsetsDirectional.symmetric(
                                      vertical: 6,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${value.costs.data!.elementAt(index).description} (${value.costs.data!.elementAt(index).service})",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Biaya: ${rupiahConverter(value.costs.data!.elementAt(index).cost![0].value)}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Estimasi sampai: ${value.costs.data!.elementAt(index).cost![0].etd} hari",
                                            style: TextStyle(
                                                color: Colors.lightGreenAccent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Consumer<HomeViewmodel>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingScreen(),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
