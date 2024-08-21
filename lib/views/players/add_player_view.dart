import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class AddPlayerView extends StatefulWidget {
  const AddPlayerView({super.key});

  @override
  State<AddPlayerView> createState() => _AddPlayerViewState();
}

class _AddPlayerViewState extends State<AddPlayerView> {
  late final TextEditingController _email;
  late final FirebaseCloudStorage _playersService;

  @override
  void initState() {
    _email = TextEditingController();
    _playersService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Add Player',
              style: TextStyle(
                color: AppColors.darkTextColor,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 12.0,
                    ),
                    child: TextField(
                      controller: _email,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Player Email',
                        hintStyle: const TextStyle(
                          color: AppColors.placeholderColor,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.placeholderColor, width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        height: 1.0,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: AppColors.primaryColor,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final currentUser = AuthService.firebase().currentUser!;
                      final email = _email.text.trim();
                      final playerId =
                          await _playersService.getUserIdByEmail(email: email);
                      await _playersService.addPlayer(
                          coachId: currentUser.id, playerId: playerId);
                      _email.clear();
                    },
                    tooltip: 'Add',
                    color: AppColors.lightBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
