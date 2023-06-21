import 'package:akademi_bootcamp/core/base/state/base_state.dart';
import 'package:akademi_bootcamp/core/components/app_bar/custom_app_bar.dart';
import 'package:akademi_bootcamp/core/components/buttons/custom_button.dart';
import 'package:akademi_bootcamp/core/components/textfield/custom_textfield.dart';
import 'package:akademi_bootcamp/core/constants/theme/theme_constants.dart';
import 'package:akademi_bootcamp/core/model/event_model.dart';
import 'package:akademi_bootcamp/product/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/components/cards/event_item_card.dart';
import '../../core/components/cards/poster_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> {
  HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(context: context, center: AppBarWidgets.LOGO, right: AppBarWidgets.NOTIFICATION),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumSize),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextfield(hintText: "Search", controller: TextEditingController(), keyboardType: TextInputType.name, textInputAction: TextInputAction.search, isSearch: true),
                body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Observer body() {
    return Observer(builder: (_) {
      return _viewModel.isLoading
          ? loadingWidget()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                horizontalCategoriesWidget(),
                eventBody(),
              ],
            );
    });
  }

  Column loadingWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget eventBody() {
    return _viewModel.selectedIndex >= 0
        ? Column(
            children: [activityInfoHeader(), horizontalCards(), verticalCards()],
          )
        : SizedBox();
  }

  Padding activityInfoHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${_viewModel.categoryList?[_viewModel.selectedIndex].name} Aktiviteleri", style: TextStyle().copyWith(color: Colors.white)),
          InkWell(
            onTap: () => _viewModel.seeAll(),
            child: Column(
              children: [
                Icon(!_viewModel.seeAllIsActive ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.vanillaShake),
                Text("See All", style: TextStyle().copyWith(color: AppColors.vanillaShake)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Visibility verticalCards() {
    return Visibility(
      visible: _viewModel.seeAllIsActive,
      child: SingleChildScrollView(
        child: Column(
            children: List.generate(_viewModel.filteredEventList?.length ?? 0, (index) {
          return EventItemCard(deviceWidth: deviceWidth, eventModel: _viewModel.filteredEventList![index]);
        })),
      ),
    );
  }

  Visibility horizontalCards() {
    return Visibility(
      visible: !_viewModel.seeAllIsActive,
      child: SingleChildScrollView(
          controller: _viewModel.scrollController,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: _viewModel.filteredEventList != null
              ? Row(
                  children: List.generate(_viewModel.filteredEventList!.length, (index) {
                  EventModel eventModel = _viewModel.filteredEventList![index];
                  return PosterCard(
                    eventModel: eventModel,
                    deviceWidth: deviceWidth,
                    deviceHeight: deviceHeight,
                  );
                }))
              : SizedBox()),
    );
  }

  Widget horizontalCategoriesWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: _viewModel.categoryList != null
          ? Row(
              children: List.generate(_viewModel.categoryList!.length, (index) {
                Format category = _viewModel.categoryList![index];
                return CustomButton(
                    marginPadding: EdgeInsets.only(right: AppSizes.lowSize, top: AppSizes.mediumSize, bottom: AppSizes.mediumSize),
                    title: category.name!,
                    isFilled: _viewModel.isSelected(index),
                    onTap: () {
                      _viewModel.tapped(index);
                    },
                    horizontalPadding: AppSizes.lowSize,
                    verticalPadding: AppSizes.lowSize);
              }),
            )
          : SizedBox(),
    );
  }
}