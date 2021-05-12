import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';

class PlantSeedsSuccessDialog extends StatelessWidget {
  const PlantSeedsSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${BlocProvider.of<PlantSeedsBloc>(context).state.quantity}',
              style: Theme.of(context).textTheme.headline4Black,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Text(currencySeedsCode, style: Theme.of(context).textTheme.subtitle2Black),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          BlocProvider.of<PlantSeedsBloc>(context).state.fiatAmount,
          style: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack,
        ),
        const SizedBox(height: 30.0),
        Text(
          'Congratulations\nYour seeds were planted successfully!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.buttonBlack,
        ),
      ],
      singleLargeButtonTitle: 'Close',
      onSingleLargeButtonPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }
}