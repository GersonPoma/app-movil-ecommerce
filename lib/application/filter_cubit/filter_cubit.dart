import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/category/category.dart';
import '../../data/models/product/filter_params_model.dart';

class FilterCubit extends Cubit<FilterProductParams> {
  final TextEditingController productsSearchController =
      TextEditingController();
  FilterCubit() : super(const FilterProductParams());

  bool isSelectedCategory(Category category) {
    return state.categories.contains(category);
  }

  void update({
    String? keyword,
    List<Category>? categories,
    Category? category,
  }) {
    List<Category> updatedCategories = List.from(state.categories);

    if (category != null) {
      updatedCategories = [category];
    } else if (categories != null) {
      updatedCategories = List.from(categories);
    }

    emit(FilterProductParams(
      keyword: keyword ?? state.keyword,
      categories: updatedCategories,
    ));
  }

  void updateCategory({required Category category}) {
    final updatedCategories = List<Category>.from(state.categories);

    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      updatedCategories.add(category);
    }

    emit(state.copyWith(categories: updatedCategories));
  }

  int getFiltersCount() {
    return state.categories.length;
  }

  void reset() => emit(const FilterProductParams());
}
