import 'package:depd_2024_mvvm/data/response/api_response.dart';
import 'package:depd_2024_mvvm/model/costs/costs.dart';
import 'package:depd_2024_mvvm/model/model.dart';
import 'package:depd_2024_mvvm/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewmodel with ChangeNotifier{
  final _homeRepo = HomeRepository();
  ApiResponse<List<Province>> provinceList = ApiResponse.loading();

  setProvinceList(ApiResponse<List<Province>> response){
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async{
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value){
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace){
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  Future<dynamic> getCityOriginList(var provId) async {
    _homeRepo.fetchCityList(provId).then((value) {
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();
  setCityDestinationList(ApiResponse<List<City>> response) {
    cityDestinationList = response;
    notifyListeners();
  }

  Future<dynamic> getCityDestinationList(var provId) async {
    _homeRepo.fetchCityList(provId).then((value) {
      setCityDestinationList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityDestinationList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<Costs>> costs = ApiResponse.notStarted();
  setCosts(ApiResponse<List<Costs>> response) {
    costs = response;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<dynamic> getCostsList(String origin, String destination, int weight, String courier) async {
    setLoading(true);
    _homeRepo.fetchCost(origin, destination, weight, courier).then((value) {
      setCosts(ApiResponse.completed(value));
      setLoading(false);
    }).onError((error, stackTrace) {
      setCosts(ApiResponse.error(error.toString()));
    });
  }

}