import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/modules/user/components/sign_in_container.dart';
import 'package:snake_app/modules/user/components/sign_up_container.dart';

enum TabSelection { signIn, signUp }

class SignInOrSignUpContainer extends StatefulWidget {
  const SignInOrSignUpContainer({super.key});

  @override
  State<SignInOrSignUpContainer> createState() =>
      _SignInOrSignUpContainerState();
}

class _SignInOrSignUpContainerState extends State<SignInOrSignUpContainer> {
  TabSelection _selectedTab = TabSelection.signIn;

  _onSetSelection(TabSelection selection) {
    Provider.of<UserEntryFormState>(context, listen: false).resetFormState();
    setState(() {
      _selectedTab = selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modern Tab Selector
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(4.0),
          child: SegmentedButton<TabSelection>(
            segments: const <ButtonSegment<TabSelection>>[
              ButtonSegment<TabSelection>(
                value: TabSelection.signIn,
                label: Text('Sign In'),
                icon: Icon(Icons.login),
              ),
              ButtonSegment<TabSelection>(
                value: TabSelection.signUp,
                label: Text('Sign Up'),
                icon: Icon(Icons.person_add),
              ),
            ],
            selected: <TabSelection>{_selectedTab},
            onSelectionChanged: (Set<TabSelection> selection) =>
                _onSetSelection(selection.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context).colorScheme.onSurface;
              }),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              side: WidgetStateProperty.all<BorderSide>(BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        _selectedTab == TabSelection.signIn
            ? const SignInContainer()
            : const SignUpContainer(),
      ],
    );
  }
}
