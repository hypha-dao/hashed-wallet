import 'dart:io';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';

class PickImageStateMapper extends StateMapper {
  EditRegionEventState mapResultToState(EditRegionEventState currentState, Result<File?> result) {
    if (result.isError) {
      return currentState.copyWith(
          pictureBoxState: currentState.file != null ? PictureBoxState.imagePicked : PictureBoxState.pickImage,
          pageCommand: ShowErrorMessage("Error on selecting image"));
    } else {
      final File? file = result.asValue!.value;
      if (file != null) {
        return currentState.copyWith(
          file: result.asValue!.value,
          pictureBoxState: PictureBoxState.imagePicked,
          isSaveChangesButtonEnable: true,
        );
      } else {
        return currentState.copyWith(pictureBoxState: PictureBoxState.pickImage);
      }
    }
  }
}
